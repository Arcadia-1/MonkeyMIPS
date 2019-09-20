`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:  
// 
// Create Date: 2019/07/07 20:36:59
// Design Name: 
// Module Name: ex
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//      EX stage, execution
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "defines.v"

module ex(        
    //由于lw，sw增加的接口
    input [`InstBus] inst_i,
    output [`AluOpBus] aluop_o,
    output [`RegBus] mem_addr_o,
    output [`RegBus] reg2_o, //往后传递寄存器地址
    
    //转移指令
    
    output reg [`RegBus] branch_target_addr_o,  //转移的目标地址
    output reg branch_flag_o,                   //是否发生转移
    
    //由于异常处理增加的接口
    input [`RegBus] excepttype_i,
    input [`RegBus] current_pc_i,
    output [`RegBus] excepttype_o,
    output [`RegBus] current_pc_o,    
    
    //由于协处理器增加的接口
    input [`RegBus] cp0_r_data_i,           //从CP0中的寄存器读取到的值
    input [`RegAddrBus] MFC0_r_addr_i,      //MFC0指令需要读的地址
    
    input mem_cp0_we,                       //处于MEM阶段的指令是否要写CP0中的寄存器
    input [`RegAddrBus] mem_cp0_w_addr,     //处于MEM阶段的指令要写CP0中寄存器的地址
    input [`RegBus] mem_cp0_w_data,         //处于MEM阶段的指令要写入CP0的数值
    
    input wb_cp0_we,                        //处于WB阶段的指令是否要写CP0中的寄存器
    input [`RegAddrBus] wb_cp0_w_addr,      //处于WB阶段的指令要写CP0中寄存器的地址
    input [`RegBus] wb_cp0_w_data,          //处于WB阶段的指令要写入CP0的数值
        
    output reg [`RegAddrBus] cp0_r_addr_o,  //要读取CP0中的寄存器的地址
    
    output reg cp0_we_o,                    //是否要写CP0中的寄存器
    output reg [`RegAddrBus] cp0_w_addr_o,  //要写入的CP0中寄存器的地址
    output reg [`RegBus] cp0_w_data_o,      //要写入CP0的数值
  
    //从ID/EX段间寄存器传来的信息
    input [`AluSelBus] alusel_i,        //ALU操作的类型
    input [`AluOpBus] aluop_i,          //ALU操作的子类型
    input [`RegBus] reg1_i,             //运算的源操作数1
    input [`RegBus] reg2_i,             //运算的源操作数2
    input w_reg_i,                      //是否要写入目的寄存器
    input [`RegAddrBus] w_dest_i,       //要写入的目的寄存器地址
        
    //执行阶段的结果
    output reg w_reg_o,                 //是否要写入目的寄存器
    output reg [`RegAddrBus] w_dest_o,  //要写入的目的寄存器地址
    output reg [`RegBus] w_data_o       //要写入目的寄存器的数据
    );
    
    reg [`RegBus] move_result;          //保存移动运算的结果
    reg [`RegBus] logic_result;         //保存逻辑运算的结果
    reg [`RegBus] shift_result;         //保存移位运算的结果
    reg [`RegBus] arithmetric_result;   //保存算术运算的结果
    
    //为分支跳转新增的变量
    reg [`RegBus] link_addr;           //转移指令要保存的返回地址
    wire [`RegBus] pc_plus_4;
    wire [`RegBus] pc_plus_8;
    wire [`RegBus] imm_sll2_signedext;  //对imm左移2位：符号扩展
        
    assign pc_plus_8 = current_pc_i + 8;
    assign pc_plus_4 = current_pc_i + 4;
    assign imm_sll2_signedext = {{14{inst_i[15]}},inst_i[15:0],2'b00};
        
    //为算术运算新增的变量
    wire overflow;                      //溢出情况
//    wire reg1_lt_reg2;                  //第一个操作数 < 第二个操作数
    wire [`RegBus] sum;                 //加法运算的结果
    
    //异常处理相关指令
    reg OverflowAssert;
    reg TrapAssert;
    assign excepttype_o ={excepttype_i[31:12],OverflowAssert,TrapAssert,excepttype_i[9:8],8'b0};
//    assign excepttype_o ={excepttype_i[31:12],OverflowAssert,1'b0,excepttype_i[9:8],8'b0};
    assign current_pc_o = current_pc_i;
    
    //load，store相关
    assign aluop_o = aluop_i;
    assign mem_addr_o = reg1_i + {{16{inst_i[15]}},inst_i[15:0]};
    assign reg2_o = reg2_i;
    
    //两个数的和
    assign sum = reg1_i + reg2_i;
    
    //判断溢出：两种情况    
    assign overflow = ((!reg1_i[31] && !reg2_i[31]) && (sum[31]))||
                      ((reg1_i[31] && reg2_i[31])&& (!sum[31]));
//    assign overflow = 0;
    
//    判断 第一个操作数 是否小于 第二个操作数
//    assign reg1_lt_reg2 = ((aluop_i == `EXE_SLT_OP))?(                  //有符号数比较EXE_SLT_OP，在以下3种情况为True：
//                          ((reg1_i[31])&&(!reg2_i[31])||                //若op1<0，op2>0，则reg1_lt_reg2=True
//                          (!reg1_i[31])&&(!reg2_i[31])&&(sum[31]))||    //若op1>0，op2>0，op1-op2<0，则reg1_lt_reg2=True
//                          ((reg1_i[31])&&(reg2_i[31])&&(sum[31]))       //若op1<0，op2<0，op1-op2<0，则reg1_lt_reg2=True
//                          ):(reg1_i < reg2_i);                          //无符号数比较，aluop_i == `EXE_SLTU_OP
        
    //根据aluop_i指示的运算子类型进行运算：跳转
    always @ (*) begin
        link_addr <= `ZeroWord;
        branch_target_addr_o <= `ZeroWord;
        branch_flag_o <= `NoBranch;
        
        case (aluop_i)            
            `EXE_J_OP: begin               
            end
            
            `EXE_JAL_OP: begin                
                link_addr <= pc_plus_8;
            end
            
            `EXE_JR_OP: begin
                link_addr <= `ZeroWord;
                branch_target_addr_o <= reg1_i;
                branch_flag_o <= `Branch;       
            end
            
            `EXE_JALR_OP: begin
                link_addr <= pc_plus_8;
                branch_target_addr_o <= reg1_i;
                branch_flag_o <= `Branch;      
            end  
            
            `EXE_BEQ_OP: begin
                if (reg1_i == reg2_i) begin
                    branch_flag_o <= `Branch;
                    branch_target_addr_o <= pc_plus_4 + imm_sll2_signedext;
                end          
            end
            
            `EXE_BGEZ_OP: begin
                if (reg1_i[31] == 1'b0) begin
                    branch_flag_o <= `Branch;
                    branch_target_addr_o <= pc_plus_4 + imm_sll2_signedext;
                end     
            end  
            
            `EXE_BLTZ_OP: begin
                if (reg1_i[31] == 1'b1) begin
                    branch_flag_o <= `Branch;
                    branch_target_addr_o <= pc_plus_4 + imm_sll2_signedext;
                end
            end
            
            `EXE_BEQ_OP: begin
                if (reg1_i == reg2_i) begin
                    branch_flag_o <= `Branch;
                    branch_target_addr_o <= pc_plus_4 + imm_sll2_signedext;
                end 
            end
            
            `EXE_BGTZ_OP: begin
                if ((reg1_i[31] == 1'b0)&&(reg1_i != `ZeroWord)) begin
                    branch_flag_o <= `Branch;
                    branch_target_addr_o <= pc_plus_4 + imm_sll2_signedext;
                end   
            end
            
            `EXE_BLEZ_OP: begin
                if ((reg1_i[31] == 1'b1)||(reg1_i == `ZeroWord)) begin
                    branch_flag_o <= `Branch;
                    branch_target_addr_o <= pc_plus_4 + imm_sll2_signedext;
                end    
            end
            
            `EXE_BNE_OP: begin
                if (reg1_i != reg2_i) begin
                    branch_flag_o <= `Branch;
                    branch_target_addr_o <= pc_plus_4 + imm_sll2_signedext;
                end 
            end
            default: begin
            end
        endcase
    end
    
    //根据aluop_i指示的运算子类型进行运算：逻辑运算（logic_result）
    always @ (*) begin
        logic_result <= `ZeroWord;
        case (aluop_i)
            `EXE_OR_OP:     logic_result <= reg1_i | reg2_i;
            `EXE_AND_OP:    logic_result <= reg1_i & reg2_i;
            `EXE_XOR_OP:    logic_result <= reg1_i ^ reg2_i;
            `EXE_NOR_OP:    logic_result <= ~(reg1_i | reg2_i);
            default: begin end
        endcase
    end
    
    //根据aluop_i指示的运算子类型进行运算：移位运算（shift_result）
    always @(*) begin
        shift_result <= `ZeroWord;
        case (aluop_i)
            `EXE_SLL_OP: shift_result <= reg2_i << reg1_i[4:0];            
            `EXE_SRL_OP: shift_result <= reg2_i >> reg1_i[4:0];
            `EXE_SRA_OP: begin
                shift_result <= ({32{reg2_i[31]}}<<(6'b100000-{1'b0,reg1_i[4:0]})) | (reg2_i >> reg1_i[4:0]);
            end
            default: begin end            
        endcase
    end
    
    //根据aluop_i指示的运算子类型进行运算：移动运算（move_result）
    always @(*) begin   
        move_result <= `ZeroWord;    
        cp0_r_addr_o <= 5'b00000; 
        case (aluop_i)                           
            `EXE_MFC0_OP:begin
                cp0_r_addr_o <= MFC0_r_addr_i;                    
                move_result <= cp0_r_data_i;
                
                if ((mem_cp0_we == `WriteEnable)&&(mem_cp0_w_addr == MFC0_r_addr_i)) begin
                    move_result <= mem_cp0_w_data;
                end else if ((wb_cp0_we == `WriteEnable)&&(wb_cp0_w_addr == MFC0_r_addr_i)) begin
                    move_result <= wb_cp0_w_data;
                end                
            end
            default: begin
            end
                       
        endcase
    end
    
    //根据aluop_i指示的运算子类型进行运算：算术运算（arithmetric_result）
    always @ (*) begin
        arithmetric_result <= `ZeroWord;     
        case (aluop_i)                   
            `EXE_ADD_OP,`EXE_ADDU_OP: arithmetric_result <= sum;
            `EXE_SUB_OP,`EXE_SUBU_OP: arithmetric_result <= reg1_i + ~reg2_i + 1;
            `EXE_SLT_OP,`EXE_SLTU_OP: begin
//                arithmetric_result <= reg1_lt_reg2;
            end
            default: begin end
        endcase
    end
    
     //判断Trap异常
    always @ (*) begin
        TrapAssert <= `NOTRAP;
        case (aluop_i)
            `EXE_TEQ_OP: begin
                if (reg1_i == reg2_i) TrapAssert <= `TRAP;
            end            
            
            `EXE_TNE_OP: begin
                if (reg1_i != reg2_i) TrapAssert <= `TRAP;
            end            
            default: begin end
        endcase
    end
    
    //判断Overflow异常
    always @ (*) begin
        w_dest_o <= w_dest_i;
        if (((aluop_i == `EXE_ADD_OP)||(aluop_i == `EXE_SUB_OP))&&(overflow == `TRUE)) begin
            w_reg_o <= `WriteDisable;
            OverflowAssert <= `TRUE;
        end else begin
            w_reg_o <= w_reg_i;
            OverflowAssert <= `FALSE;
        end
    end
    
    //根据alusel_i指示的运算类型进行运算，给出EX阶段的运算结果
    always @(*) begin         
        case (alusel_i)        
            `EXE_RES_LOGIC:         w_data_o <= logic_result;                    
            `EXE_RES_SHIFT:         w_data_o <= shift_result;
            `EXE_RES_ARITHMETRIC:   w_data_o <= arithmetric_result;
            `EXE_RES_MOVE:          w_data_o <= move_result;
            `EXE_RES_JUMP_BRANCH:   w_data_o <= link_addr;
            default: begin
            end
        endcase
    end
    
    always @ (*) begin
        cp0_we_o <= `WriteDisable;
        cp0_w_addr_o <= `NOPRegAddr;
        cp0_w_data_o <= `ZeroWord;
        if (aluop_i == `EXE_MTC0_OP) begin
            cp0_we_o <= `WriteEnable;
            cp0_w_addr_o <= w_dest_i;
            cp0_w_data_o <= reg1_i;            
        end
    end    
endmodule
