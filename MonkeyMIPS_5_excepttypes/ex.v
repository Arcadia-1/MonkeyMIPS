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
    //����lw��sw���ӵĽӿ�
    input [`InstBus] inst_i,
    output [`AluOpBus] aluop_o,
    output [`RegBus] mem_addr_o,
    output [`RegBus] reg2_o, //���󴫵ݼĴ�����ַ
    
    //ת��ָ��
    
    output reg [`RegBus] branch_target_addr_o,  //ת�Ƶ�Ŀ���ַ
    output reg branch_flag_o,                   //�Ƿ���ת��
    
    //�����쳣�������ӵĽӿ�
    input [`RegBus] excepttype_i,
    input [`RegBus] current_pc_i,
    output [`RegBus] excepttype_o,
    output [`RegBus] current_pc_o,    
    
    //����Э���������ӵĽӿ�
    input [`RegBus] cp0_r_data_i,           //��CP0�еļĴ�����ȡ����ֵ
    input [`RegAddrBus] MFC0_r_addr_i,      //MFC0ָ����Ҫ���ĵ�ַ
    
    input mem_cp0_we,                       //����MEM�׶ε�ָ���Ƿ�ҪдCP0�еļĴ���
    input [`RegAddrBus] mem_cp0_w_addr,     //����MEM�׶ε�ָ��ҪдCP0�мĴ����ĵ�ַ
    input [`RegBus] mem_cp0_w_data,         //����MEM�׶ε�ָ��Ҫд��CP0����ֵ
    
    input wb_cp0_we,                        //����WB�׶ε�ָ���Ƿ�ҪдCP0�еļĴ���
    input [`RegAddrBus] wb_cp0_w_addr,      //����WB�׶ε�ָ��ҪдCP0�мĴ����ĵ�ַ
    input [`RegBus] wb_cp0_w_data,          //����WB�׶ε�ָ��Ҫд��CP0����ֵ
        
    output reg [`RegAddrBus] cp0_r_addr_o,  //Ҫ��ȡCP0�еļĴ����ĵ�ַ
    
    output reg cp0_we_o,                    //�Ƿ�ҪдCP0�еļĴ���
    output reg [`RegAddrBus] cp0_w_addr_o,  //Ҫд���CP0�мĴ����ĵ�ַ
    output reg [`RegBus] cp0_w_data_o,      //Ҫд��CP0����ֵ
  
    //��ID/EX�μ�Ĵ�����������Ϣ
    input [`AluSelBus] alusel_i,        //ALU����������
    input [`AluOpBus] aluop_i,          //ALU������������
    input [`RegBus] reg1_i,             //�����Դ������1
    input [`RegBus] reg2_i,             //�����Դ������2
    input w_reg_i,                      //�Ƿ�Ҫд��Ŀ�ļĴ���
    input [`RegAddrBus] w_dest_i,       //Ҫд���Ŀ�ļĴ�����ַ
        
    //ִ�н׶εĽ��
    output reg w_reg_o,                 //�Ƿ�Ҫд��Ŀ�ļĴ���
    output reg [`RegAddrBus] w_dest_o,  //Ҫд���Ŀ�ļĴ�����ַ
    output reg [`RegBus] w_data_o       //Ҫд��Ŀ�ļĴ���������
    );
    
    reg [`RegBus] move_result;          //�����ƶ�����Ľ��
    reg [`RegBus] logic_result;         //�����߼�����Ľ��
    reg [`RegBus] shift_result;         //������λ����Ľ��
    reg [`RegBus] arithmetric_result;   //������������Ľ��
    
    //Ϊ��֧��ת�����ı���
    reg [`RegBus] link_addr;           //ת��ָ��Ҫ����ķ��ص�ַ
    wire [`RegBus] pc_plus_4;
    wire [`RegBus] pc_plus_8;
    wire [`RegBus] imm_sll2_signedext;  //��imm����2λ��������չ
        
    assign pc_plus_8 = current_pc_i + 8;
    assign pc_plus_4 = current_pc_i + 4;
    assign imm_sll2_signedext = {{14{inst_i[15]}},inst_i[15:0],2'b00};
        
    //Ϊ�������������ı���
    wire overflow;                      //������
//    wire reg1_lt_reg2;                  //��һ�������� < �ڶ���������
    wire [`RegBus] sum;                 //�ӷ�����Ľ��
    
    //�쳣�������ָ��
    reg OverflowAssert;
    reg TrapAssert;
    assign excepttype_o ={excepttype_i[31:12],OverflowAssert,TrapAssert,excepttype_i[9:8],8'b0};
//    assign excepttype_o ={excepttype_i[31:12],OverflowAssert,1'b0,excepttype_i[9:8],8'b0};
    assign current_pc_o = current_pc_i;
    
    //load��store���
    assign aluop_o = aluop_i;
    assign mem_addr_o = reg1_i + {{16{inst_i[15]}},inst_i[15:0]};
    assign reg2_o = reg2_i;
    
    //�������ĺ�
    assign sum = reg1_i + reg2_i;
    
    //�ж�������������    
    assign overflow = ((!reg1_i[31] && !reg2_i[31]) && (sum[31]))||
                      ((reg1_i[31] && reg2_i[31])&& (!sum[31]));
//    assign overflow = 0;
    
//    �ж� ��һ�������� �Ƿ�С�� �ڶ���������
//    assign reg1_lt_reg2 = ((aluop_i == `EXE_SLT_OP))?(                  //�з������Ƚ�EXE_SLT_OP��������3�����ΪTrue��
//                          ((reg1_i[31])&&(!reg2_i[31])||                //��op1<0��op2>0����reg1_lt_reg2=True
//                          (!reg1_i[31])&&(!reg2_i[31])&&(sum[31]))||    //��op1>0��op2>0��op1-op2<0����reg1_lt_reg2=True
//                          ((reg1_i[31])&&(reg2_i[31])&&(sum[31]))       //��op1<0��op2<0��op1-op2<0����reg1_lt_reg2=True
//                          ):(reg1_i < reg2_i);                          //�޷������Ƚϣ�aluop_i == `EXE_SLTU_OP
        
    //����aluop_iָʾ�����������ͽ������㣺��ת
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
    
    //����aluop_iָʾ�����������ͽ������㣺�߼����㣨logic_result��
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
    
    //����aluop_iָʾ�����������ͽ������㣺��λ���㣨shift_result��
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
    
    //����aluop_iָʾ�����������ͽ������㣺�ƶ����㣨move_result��
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
    
    //����aluop_iָʾ�����������ͽ������㣺�������㣨arithmetric_result��
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
    
     //�ж�Trap�쳣
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
    
    //�ж�Overflow�쳣
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
    
    //����alusel_iָʾ���������ͽ������㣬����EX�׶ε�������
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
