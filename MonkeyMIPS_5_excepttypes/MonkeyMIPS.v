`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/09/10 15:29:08
// Design Name: 
// Module Name: ApeMIPS
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "defines.v"

module MonkeyMIPS(
    input rst,//复位信号
    input clk,//时钟信号
    
    input [5:0] int_i,                      //6个外部硬件中断输入    
//    output timer_int_o,                   //协处理器的定时器中断信号
       
    input [`RegBus] rom_data_i,             //从指令存储器取得的指令
    output [`InstAddrBus] rom_addr_o,       //输出到指令存储器的地址
    
    output [`RegBus] data_from_mem,         //要写入数据存储器和外设的数据                           
    output [`DataAddrBus] addr_from_mem,    //要访问的数据存储器和外设的地址
    
    output we_to_dataram,                   //是否要写数据存储器，write enable信号
    input [`RegBus] data_from_dataram,      //从数据存储器读取的数据
    
    output we_to_peripheral,                //是否要写外设，write enable信号
    input [`RegBus] data_from_peripheral    //从外设读取的数据    
    );
    
    //Stall信号
    wire stall;
    wire stall_request_from_ex;        //EX阶段的指令是否请求流水线暂停
    
    //连接IF/ID段间寄存器与ID译码模块的变量
    wire [`InstAddrBus] pc;
    wire [`InstAddrBus] id_pc_i;
    wire [`InstBus] id_inst_i;
    
    //连接ID译码模块与ID/EX段间寄存器的变量
    wire [`InstBus] id_inst_o;
    wire [`AluOpBus] id_aluop_o;
    wire [`AluSelBus] id_alusel_o;
    wire id_w_reg_o;
    wire [`RegAddrBus] id_w_dest_o;
    wire [`RegBus] id_imm;
    
    //连接ID/EX段间寄存器与EX执行模块的变量
    wire [`InstBus] ex_inst_i;
    wire [`AluOpBus] ex_aluop_i;
    wire [`AluSelBus] ex_alusel_i;
    wire [`RegBus] ex_reg1_i;
    wire [`RegBus] ex_reg2_i;
    wire ex_w_reg_i;
    wire [`RegAddrBus] ex_w_dest_i;
    
    //连接EX执行模块与EX/MEM段间寄存器的变量
    wire ex_w_reg_o;
    wire [`RegAddrBus] ex_w_dest_o;
    wire [`RegBus] ex_w_data_o;
    wire [`AluOpBus] ex_aluop_o;
    wire [`RegBus] ex_mem_addr_o;
    wire [`RegBus] ex_reg2_o;
    
    //连接EX/MEM段间寄存器与MEM访存模块的变量
    wire mem_w_reg_i;
    wire [`RegAddrBus] mem_w_dest_i;
    wire [`RegBus] mem_w_data_i;
    wire [`AluOpBus] mem_aluop_i;
    wire [`RegBus] mem_mem_addr_i;
    wire [`RegBus] mem_reg2_i;
    
    //连接MEM访存模块与MEM/WB段间寄存器的变量
    wire mem_w_reg_o;
    wire [`RegAddrBus] mem_w_dest_o;
    wire [`RegBus] mem_w_data_o;
            
    //连接MEM/WB段间寄存器与WB回写模块的变量
    wire wb_w_reg_i;
    wire [`RegAddrBus] wb_w_dest_i;
    wire [`RegBus] wb_w_data_i;
                   
    //连接ID译码模块与通用寄存器堆的变量
    wire reg1_read;
    wire reg2_read;
    wire [`RegBus] reg1_data;
    wire [`RegBus] reg2_data;
    wire [`RegAddrBus] reg1_addr;
    wire [`RegAddrBus] reg2_addr;
            
    //由于转移指令增加的变量
    wire branch_flag;
    wire [`RegBus] branch_target_addr;
    wire jump_flag;
    wire [`RegBus] jump_target_addr;
            
    //由于协处理器增加的变量
    wire cp0_we_i;
    wire [`RegAddrBus] cp0_waddr_i;
    wire [`RegBus] cp0_wdata_i;
    wire [`RegAddrBus]cp0_raddr_i;    
    wire [`RegBus] cp0_data_o;
    
    wire ex_cp0_we_o;
    wire [`RegAddrBus] ex_cp0_w_addr_o;
    wire [`RegBus] ex_cp0_w_data_o;
    
    wire mem_cp0_we_i;
    wire [`RegAddrBus] mem_cp0_w_addr_i;
    wire [`RegBus] mem_cp0_w_data_i;
    wire mem_cp0_we_o;
    wire [`RegAddrBus] mem_cp0_w_addr_o;
    wire [`RegBus] mem_cp0_w_data_o;
    
    wire [`RegBus] count_o;
    wire [`RegBus] compare_o;
    wire [`RegBus] status_o;
    wire [`RegBus] cause_o;
    wire [`RegBus] epc_o;
    
    wire [`RegAddrBus] id_MFC0_r_addr_o;
    wire [`RegAddrBus] ex_MFC0_r_addr_i;
        
    //由于异常处理增加的变量
    wire [`RegBus] new_pc;
    wire [`RegBus] ctrl_cp0_epc;
    
    wire [`RegBus] id_excepttype_o;
    wire [`RegBus] id_current_pc_o;
    
    wire [`RegBus] ex_excepttype_i;
    wire [`RegBus] ex_current_pc_i;    
    wire [`RegBus] ex_excepttype_o;
    wire [`RegBus] ex_current_pc_o;
    wire [`RegBus] mem_excepttype_i;
    wire [`RegBus] mem_current_pc_i;
    wire [3:0] mem_execode_o;
    wire [`RegBus] mem_current_pc_o;
        
    wire flush;
    wire flush_ifid;
    wire flush_idex;

    assign flush_ifid = flush | branch_flag | jump_flag;
    assign flush_idex = flush | branch_flag;
    
    //ctrl例化
    ctrl ctrl0(
        .execode_i(mem_execode_o),
        .cp0_epc_i(ctrl_cp0_epc), 
        .new_pc(new_pc),        
        .stall_request(stall_request_from_ex),
        .stall(stall),
        .flush(flush)
    );
    
    //pc_reg例化
    pc_reg pc_reg0(
        .clk(clk),.rst(rst),.stall(stall),
        
        .branch_flag_i(branch_flag),
        .branch_target_addr_i(branch_target_addr),
        .jump_flag_i(jump_flag),
        .jump_target_addr_i(jump_target_addr),    
        .pc(pc),
        
        //由于异常处理增加的接口
        .new_pc(new_pc),
        .flush(flush)
    );
    
    assign rom_addr_o = pc;
    
    //IF/ID段间寄存器例化
    if_id if_id(
        .clk(clk),.stall(stall),
        
        //从取指阶段传来的信息
        .if_pc(pc),.if_inst(rom_data_i),
        
        //传递到译码阶段的信息
        .id_pc(id_pc_i),.id_inst(id_inst_i),
        
        //由于异常处理增加的接口
        .flush(flush_ifid)        
    );
        
    
    //ID译码模块例化
    id id0(
        .pc_i(id_pc_i),.inst_i(id_inst_i),.inst_o(id_inst_o),
        .imm(id_imm),
        .MFC0_r_addr(id_MFC0_r_addr_o),
        
        //load-use hazard
        .stall_request(stall_request_from_ex),
        .ex_aluop_i(ex_aluop_i),
        .ex_wd_i(ex_w_dest_o),
        
        //跳转
        .jump_flag_o(jump_flag),
        .jump_target_addr_o(jump_target_addr),
        
        //由于异常处理增加的接口
        .excepttype_o(id_excepttype_o),.current_pc_o(id_current_pc_o),
        
        //送到regfile模块的信息
        .reg1_read_o(reg1_read),.reg2_read_o(reg2_read),
        .reg1_addr_o(reg1_addr),.reg2_addr_o(reg2_addr),

        //送到ID/EX段间寄存器的信息
        .aluop_o(id_aluop_o),.alusel_o(id_alusel_o),
        .w_reg_o(id_w_reg_o),.w_dest_o(id_w_dest_o)
    );
    
    //regfile模块例化
    regfile regfile0(
        .clk(clk),
        
        //来自WB回写模块的输入
        .we(wb_w_reg_i),.waddr(wb_w_dest_i),.wdata(wb_w_data_i),

        //来自ID译码模块的输入
        .re1(reg1_read),.raddr1(reg1_addr),
        .re2(reg2_read),.raddr2(reg2_addr),
        
        //送到ID译码模块的输入
        .rdata1(reg1_data),.rdata2(reg2_data)
    );
        
    //ID/EX段间寄存器例化
    id_ex id_ex0(
        .clk(clk),.stall(stall),

        .id_inst(id_inst_o),
        .ex_inst(ex_inst_i),
        
        //判断数据来源
        .id_imm(id_imm),
        .id_reg1_read_o(reg1_read),
        .id_reg2_read_o(reg2_read),
        .id_reg1_addr_o(reg1_addr),
        .id_reg2_addr_o(reg2_addr),
    
        //读取的Regfile的值
        .RF_reg1_data_i(reg1_data),.RF_reg2_data_i(reg2_data),
        
        //来自EX模块的输入（Forwarding）
        .ex_w_reg_o(ex_w_reg_o),.ex_w_dest_o(ex_w_dest_o),.ex_w_data_o(ex_w_data_o),
        
        //来自MEM模块的输入（Forwarding）
        .mem_w_reg_o(mem_w_reg_o),.mem_w_dest_o(mem_w_dest_o),.mem_w_data_o(mem_w_data_o),
        
        //由于异常处理增加的接口
        .flush(flush_idex),
        .id_excepttype(id_excepttype_o),
        .id_current_inst_addr(id_current_pc_o),
        .ex_excepttype(ex_excepttype_i),
        .ex_current_inst_addr(ex_current_pc_i),
        
        //由于协处理器增加的接口
        .id_MFC0_r_addr(id_MFC0_r_addr_o),
        .ex_MFC0_r_addr(ex_MFC0_r_addr_i),
        
        //从译码阶段传来的信息
        .id_alusel(id_alusel_o),.id_aluop(id_aluop_o),
        .id_wd(id_w_dest_o),.id_w_reg(id_w_reg_o),
    
        //传递到执行阶段的信息
        .ex_alusel(ex_alusel_i),.ex_aluop(ex_aluop_i),
        .ex_reg1(ex_reg1_i),.ex_reg2(ex_reg2_i),
        .ex_w_dest(ex_w_dest_i),.ex_w_reg(ex_w_reg_i)
    );
       
    //EX执行模块例化
    ex ex0(         
         //由于lw，sw增加的接口 
        .inst_i(ex_inst_i),     
        .aluop_o(ex_aluop_o),.mem_addr_o(ex_mem_addr_o),.reg2_o(ex_reg2_o),
        
        //由于转移指令增加的接口
        .branch_flag_o(branch_flag),
        .branch_target_addr_o(branch_target_addr), 
         
        //由于异常处理增加的接口
        .excepttype_i(ex_excepttype_i),.current_pc_i(ex_current_pc_i),
        .excepttype_o(ex_excepttype_o),.current_pc_o(ex_current_pc_o),  
        
        //由于协处理器增加的接口
        .cp0_r_data_i(cp0_data_o),         
        .mem_cp0_we(mem_cp0_we_o),.mem_cp0_w_addr(mem_cp0_w_addr_o),.mem_cp0_w_data(mem_cp0_w_data_o), 
        .MFC0_r_addr_i(ex_MFC0_r_addr_i),
        .wb_cp0_we(cp0_we_i),.wb_cp0_w_addr(cp0_waddr_i),.wb_cp0_w_data(cp0_wdata_i),
        .cp0_r_addr_o(cp0_raddr_i),        
        .cp0_we_o(ex_cp0_we_o),.cp0_w_addr_o(ex_cp0_w_addr_o),.cp0_w_data_o(ex_cp0_w_data_o),
                        
        //从ID/EX段间寄存器传来的信息.
        .alusel_i(ex_alusel_i),.aluop_i(ex_aluop_i),
        .reg1_i(ex_reg1_i),.reg2_i(ex_reg2_i), 
        .w_reg_i(ex_w_reg_i),.w_dest_i(ex_w_dest_i), 
        
        //执行阶段的结果.
        .w_reg_o(ex_w_reg_o),.w_dest_o(ex_w_dest_o),.w_data_o(ex_w_data_o)                
    );
    
    //EX/MEM段间寄存器例化
    ex_mem ex_mem0(
        .clk(clk),.stall(stall),
        
        //由于lw，sw增加的接口         
        .ex_aluop(ex_aluop_o),
        .ex_mem_addr(ex_mem_addr_o),
        .ex_reg2(ex_reg2_o),
        .mem_aluop(mem_aluop_i),
        .mem_mem_addr(mem_mem_addr_i),
        .mem_reg2(mem_reg2_i),
            
        //由于异常处理增加的接口
        .flush(flush),
        .ex_excepttype(ex_excepttype_o),
        .ex_current_inst_addr(ex_current_pc_o),
        .mem_excepttype(mem_excepttype_i),
        .mem_current_inst_addr(mem_current_pc_i),
                
        //由于协处理器增加的接口
        .ex_cp0_we(ex_cp0_we_o),.ex_cp0_w_addr(ex_cp0_w_addr_o),.ex_cp0_w_data(ex_cp0_w_data_o),
        .mem_cp0_we(mem_cp0_we_i),.mem_cp0_w_addr(mem_cp0_w_addr_i),.mem_cp0_w_data(mem_cp0_w_data_i),
            
        //从执行阶段传来的信息
        .ex_w_reg(ex_w_reg_o),.ex_w_dest(ex_w_dest_o),.ex_data(ex_w_data_o),
        
        //传递到访存阶段的信息
        .mem_w_reg(mem_w_reg_i),.mem_w_dest(mem_w_dest_i),.mem_w_data(mem_w_data_i)
    );
    
    //MEM访存模块例化
    mem mem0(
        //由于lw，sw增加的接口
         .aluop_i(mem_aluop_i),.mem_addr_i(mem_mem_addr_i),.reg2_i(mem_reg2_i),
        
        //数据存储器data_ram和外设peripheral共有的交互  
        .mem_addr_o(addr_from_mem),        
        .mem_data_o(data_from_mem),
                
        //与数据存储器data_ram的交互
        .dataram_we_o(we_to_dataram),
        .dataram_data_i(data_from_dataram),  
        
        //与外设peripheral的交互
        .peripheral_we_o(we_to_peripheral),             //写使能信号
        .peripheral_data_i(data_from_peripheral), 
        
        //由于异常处理增加的接口
        .excepttype_i(mem_excepttype_i),
        .current_pc_i(mem_current_pc_i),
        
        .cp0_status_i(status_o),
        .cp0_cause_i(cause_o),
        .cp0_epc_i(epc_o),
        
        .wb_cp0_we(cp0_we_i),
        .wb_cp0_w_addr(cp0_waddr_i),
        .wb_cp0_w_data(cp0_wdata_i),
        
        .cp0_epc_o(ctrl_cp0_epc),        
        .Execode_o(mem_execode_o),
        .current_pc_o(mem_current_pc_o),    
        
        //由于协处理器增加的接口
        .cp0_we_i(mem_cp0_we_i),.cp0_w_addr_i(mem_cp0_w_addr_i),.cp0_w_data_i(mem_cp0_w_data_i), 
        .cp0_we_o(mem_cp0_we_o),.cp0_w_addr_o(mem_cp0_w_addr_o),.cp0_w_data_o(mem_cp0_w_data_o),    
        
        //从EX/MEM段间寄存器传来的信息
        .w_reg_i(mem_w_reg_i),.w_dest_i(mem_w_dest_i),.w_data_i(mem_w_data_i),
        
        //访存阶段的结果
        .w_reg_o(mem_w_reg_o),.w_dest_o(mem_w_dest_o),.w_data_o(mem_w_data_o)
    );
    
    //MEM/WB段间寄存器例化
    mem_wb mem_wb0(
        .clk(clk),.flush(flush),
        
        .mem_cp0_we(mem_cp0_we_o),
        .mem_cp0_w_addr(mem_cp0_w_addr_o),
        .mem_cp0_w_data(mem_cp0_w_data_o),
      
        .wb_cp0_we(cp0_we_i),
        .wb_cp0_w_addr(cp0_waddr_i),
        .wb_cp0_w_data(cp0_wdata_i),
        
        //从访存阶段传来的信息
        .mem_w_reg(mem_w_reg_o),.mem_w_dest(mem_w_dest_o),.mem_data(mem_w_data_o),
        
        //传递到回写阶段的信息
        .wb_w_reg(wb_w_reg_i),.wb_w_dest(wb_w_dest_i),.wb_data(wb_w_data_i)
    );
    
    //CP0协处理器例化
    CP0 CP00(
        .rst(rst),.clk(clk),
        .int_i(int_i),
//        .timer_int_o(timer_int_o),
        
        //直接来自MEM访存模块的信息
        .execode_i(mem_execode_o),
        .current_pc_i(mem_current_pc_o),
        
        .raddr_i(cp0_raddr_i),
        
        .we_i(cp0_we_i),.waddr_i(cp0_waddr_i), .wdata_i(cp0_wdata_i), 
        
        .data_o(cp0_data_o),
        .count_o(count_o),
        .compare_o(compare_o),
        .status_o(status_o),
        .cause_o(cause_o),
        .epc_o(epc_o)            
    );    
    
endmodule

