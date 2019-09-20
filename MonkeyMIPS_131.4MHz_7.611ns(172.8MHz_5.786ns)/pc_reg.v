`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/07 12:17:54
// Design Name: 
// Module Name: pc_reg
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//      PC module, the program counter
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module pc_reg(
    input clk,
    input rst,
    input stall,                      //�Ƿ�����
    input flush,                            //��ˮ������ź�
    input [`RegBus] new_pc,                 //�쳣�����������
    
    input branch_flag_i,                     //�Ƿ���ת��
    input [`RegBus] branch_target_addr_i,    //ת�Ƶ�Ŀ���ַ
    
    output reg[`InstAddrBus] pc              //Ҫ��ȡ��ָ���ַ
    );
    
    
    //�ж�ȡֵ�����Դ������4���ж�
    always @ (posedge clk) begin        
        if (rst == `RstEnable) begin                    //��λ���ලλ����Ϊ1
            pc <=  32'h00000000;
        end else if (flush == `FLUSH) begin             //�������������쳣/�ж�
            pc <= new_pc;
        end else if (branch_flag_i == `Branch) begin    //û���쳣������ת/��֧
            pc <= branch_target_addr_i; 
        end else if (stall != `Stall) begin                                  //���������PC+4��
            pc[31:0] <= pc[31:0] + 4'h4;
        end
    end
    
endmodule
