`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/19 11:03:56
// Design Name: 
// Module Name: CP0
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

module CP0(
    input clk,
    input rst,
    
    //由于异常处理增加的接口
    input [`RegBus] excepttype_i,
    input [`RegBus] current_pc_i,
    
    input we_i,                         //是否写寄存器
    input [`RegAddrBus] waddr_i,        //要写入的寄存器地址
    input [`RegBus] wdata_i,            //要写入的数据
    input [5:0] int_i,                  //6个外部硬件中断输入
    input [`RegAddrBus] raddr_i,        //要读取的CP0中寄存器的地址
    
    output reg [`RegBus] data_o,        //读出的CP0中某个寄存器的值
    output reg [`RegBus] count_o,       //Count寄存器
    output reg [`RegBus] compare_o,     //Compare寄存器
    output reg [`RegBus] epc_o,         //EPC寄存器
    output reg [`RegBus] cause_o        //Cause寄存器    
//    output reg timer_int_o            //是否有定时中断发生
    );
    
    //写寄存器
    always @ (posedge clk) begin
        if (rst == `RstEnable) begin
            count_o <= `ZeroWord;
            compare_o <= `ZeroWord;
            epc_o <= `ZeroWord;
            cause_o <= `ZeroWord;
//            timer_int_o <= `NoInterrupt;
            
        end else begin
            count_o <= count_o + 1;      //TL计数器，递增
            cause_o[15:10] <= int_i;     //cause_o[15:10]即IP[7:2]
            
//            if (compare_o != `ZeroWord && count_o ==compare_o) begin
//                timer_int_o <= `Interrupt;  //定时器中断信号
//            end
            
            if (we_i == `WriteEnable) begin     
                case (waddr_i)
                    `CP0_REG_COUNT: begin
                        count_o <= wdata_i;
                    end
                    
                    `CP0_REG_COMPARE: begin
                        compare_o <= wdata_i;
//                        timer_int_o <= `NoInterrupt;
                    end
                    
                    `CP0_REG_EPC: begin
                        epc_o <= wdata_i;
                    end
                    
                    default: begin
                    end
                endcase
            end
            
            case (excepttype_i)
                    32'h00000001: begin
                        epc_o <= current_pc_i;
                        cause_o[6:2] <= 5'b00000;
                    end
                                        
                    32'h0000000a: begin
                        epc_o <= current_pc_i;
                        cause_o[6:2] <= 5'b01010;
                    end
             
                    32'h0000000e: begin
                    end
                    
                endcase            
        end
    end    
    
    //读寄存器
    always @ (*) begin       
        case(raddr_i)
            `CP0_REG_COUNT: begin
                data_o <= count_o;
            end
            
            `CP0_REG_COMPARE: begin
                data_o <= compare_o;
            end
                        
            `CP0_REG_CAUSE: begin
                data_o <= cause_o;
            end
            
            `CP0_REG_EPC: begin
                data_o <= epc_o;
            end
                             
        endcase
        end
endmodule
