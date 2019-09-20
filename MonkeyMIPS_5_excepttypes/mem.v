`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/07 21:19:16
// Design Name: 
// Module Name: mem
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

module mem(
    //由于lw，sw增加的接口
    input [`AluOpBus] aluop_i,
    input [`RegBus] mem_addr_i,
    input [`RegBus] reg2_i,
        
    //数据存储器data_ram和外设peripheral共有的交互    
    output reg [`RegBus] mem_addr_o,    //要读取/写入的地址
    output reg [`RegBus] mem_data_o,    //要写入的数据
    
    //与数据存储器data_ram的交互
    output dataram_we_o,                //写使能信号
    input [`RegBus] dataram_data_i,
    
    //与外设peripheral的交互
    output peripheral_we_o,             //写使能信号
    input [`RegBus] peripheral_data_i,
    
    //由于异常处理增加的接口
    input [`RegBus] excepttype_i,
    input [`RegBus] current_pc_i,
    
    output reg [3:0] Execode_o,  
    output [`RegBus] current_pc_o,
    output [`RegBus] cp0_epc_o,    
    
    input [`RegBus] cp0_status_i,
    input [`RegBus] cp0_cause_i,
    input [`RegBus] cp0_epc_i,
    
    input wb_cp0_we,
    input [`RegAddrBus] wb_cp0_w_addr,
    input [`RegBus] wb_cp0_w_data,    
    
    //由于协处理器增加的接口
    input cp0_we_i,                         //是否要写CP0中的寄存器
    input [`RegAddrBus] cp0_w_addr_i,       //要写入的CP0中寄存器的地址
    input [`RegBus] cp0_w_data_i,           //要写入CP0的数值
    output reg cp0_we_o,                    //是否要写CP0中的寄存器
    output reg [`RegAddrBus] cp0_w_addr_o,  //要写入的CP0中寄存器的地址
    output reg [`RegBus] cp0_w_data_o,      //要写入CP0的数值
    
    //从EX/MEM段间寄存器传来的信息
    input w_reg_i,                          //是否要写入目的寄存器
    input [`RegAddrBus] w_dest_i,           //要写入的目的寄存器地址
    input [`RegBus] w_data_i,               //要写入目的寄存器的数据
    
    //访存阶段的结果
    output reg w_reg_o,                     //是否要写入目的寄存器 
    output reg [`RegAddrBus] w_dest_o,      //要写入的目的寄存器地址
    output reg [`RegBus] w_data_o          //要写入目的寄存器的数据    
    );
    
    reg [`RegBus] cp0_status;
    reg [`RegBus] cp0_cause;
    reg [`RegBus] cp0_epc;
    reg dataram_we;
    reg peripheral_we;

    assign current_pc_o = current_pc_i;
    
    //得到CP0中STATUS寄存器的最新值
    always @ (*) begin
        if ((wb_cp0_we == `WriteEnable)&&(wb_cp0_w_addr == `CP0_REG_STATUS)) begin
            cp0_status <= wb_cp0_w_data;
        end else begin
            cp0_status <= cp0_status_i;
        end
    end
    
    //得到CP0中EPC寄存器的最新值
    always @ (*) begin
        if ((wb_cp0_we == `WriteEnable)&&(wb_cp0_w_addr == `CP0_REG_EPC)) begin
            cp0_epc <= wb_cp0_w_data;
        end else begin
            cp0_epc <= cp0_epc_i;
        end
    end
    assign cp0_epc_o = cp0_epc;
    
    //得到CP0中CAUSE寄存器的最新值
    always @ (*) begin
        if ((wb_cp0_we == `WriteEnable)&&(wb_cp0_w_addr == `CP0_REG_CAUSE)) begin
            cp0_cause[9:8] <= wb_cp0_w_data[9:8];
            cp0_cause[22] <= wb_cp0_w_data[22];
            cp0_cause[23] <= wb_cp0_w_data[23];
        end else begin
            cp0_cause <= cp0_cause_i;
        end
    end
        
    //给出异常类型
    always @ (*) begin
        Execode_o <= `ZeroWord;
        if(current_pc_i != `ZeroWord) begin
            if ((cp0_cause_i[15:8] != 8'h00))   Execode_o <= 1'h1;      //中断
            if ((excepttype_i[9] == `TRUE))     Execode_o <= 4'ha;      //未定义指令
            if (excepttype_i[10] == `TRUE)      Execode_o <= 4'hd;      //自陷指令
            if (excepttype_i[11] == `TRUE)      Execode_o <= 4'hc;      //溢出
            if (excepttype_i[12] == `TRUE)      Execode_o <= 4'he;      //异常返回
        end
    end
    
    assign dataram_we_o = dataram_we & (~(|Execode_o));
    assign peripheral_we_o = peripheral_we & (~(|Execode_o));   

    always @ (*)begin       
        w_reg_o <= w_reg_i;
        w_dest_o <= w_dest_i;
        w_data_o <= w_data_i;
        
        cp0_we_o <= cp0_we_i;
        cp0_w_addr_o <= cp0_w_addr_i;
        cp0_w_data_o <= cp0_w_data_i;
        
        case(aluop_i)
            `EXE_LW: begin
                mem_addr_o <= mem_addr_i;
                dataram_we <=`WriteDisable;
                peripheral_we <=`WriteDisable;
                
                if (mem_addr_i[30] == 1'b0) begin
                    w_data_o <= dataram_data_i;
                end else begin
                    w_data_o <= peripheral_data_i;
                end

            end
            
            `EXE_SW: begin
                if (mem_addr_i[30] == 1'b0) begin
                    dataram_we <= `WriteEnable;
                end else begin
                    peripheral_we <= `WriteEnable;
                end
                
                mem_addr_o <= mem_addr_i;              
                mem_data_o <= reg2_i;
            end
            
            default: begin                
                mem_addr_o <= `ZeroWord;                
                dataram_we <=`WriteDisable;
                peripheral_we <=`WriteDisable;
            end
        endcase
            
    end    
endmodule
