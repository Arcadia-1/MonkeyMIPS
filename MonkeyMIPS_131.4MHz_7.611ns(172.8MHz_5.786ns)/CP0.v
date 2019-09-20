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
    
    //�����쳣�������ӵĽӿ�
    input [`RegBus] excepttype_i,
    input [`RegBus] current_pc_i,
    
    input we_i,                         //�Ƿ�д�Ĵ���
    input [`RegAddrBus] waddr_i,        //Ҫд��ļĴ�����ַ
    input [`RegBus] wdata_i,            //Ҫд�������
    input [5:0] int_i,                  //6���ⲿӲ���ж�����
    input [`RegAddrBus] raddr_i,        //Ҫ��ȡ��CP0�мĴ����ĵ�ַ
    
    output reg [`RegBus] data_o,        //������CP0��ĳ���Ĵ�����ֵ
    output reg [`RegBus] count_o,       //Count�Ĵ���
    output reg [`RegBus] compare_o,     //Compare�Ĵ���
    output reg [`RegBus] epc_o,         //EPC�Ĵ���
    output reg [`RegBus] cause_o        //Cause�Ĵ���    
//    output reg timer_int_o            //�Ƿ��ж�ʱ�жϷ���
    );
    
    //д�Ĵ���
    always @ (posedge clk) begin
        if (rst == `RstEnable) begin
            count_o <= `ZeroWord;
            compare_o <= `ZeroWord;
            epc_o <= `ZeroWord;
            cause_o <= `ZeroWord;
//            timer_int_o <= `NoInterrupt;
            
        end else begin
            count_o <= count_o + 1;      //TL������������
            cause_o[15:10] <= int_i;     //cause_o[15:10]��IP[7:2]
            
//            if (compare_o != `ZeroWord && count_o ==compare_o) begin
//                timer_int_o <= `Interrupt;  //��ʱ���ж��ź�
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
    
    //���Ĵ���
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
