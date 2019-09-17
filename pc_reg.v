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
    input jump_flag_i,
    input [`RegBus] jump_target_addr_i,
    
    output reg[`InstAddrBus] pc              //Ҫ��ȡ��ָ���ַ
    );
    
    wire [4:0] PC_Source;
    assign PC_Source = {rst,flush,jump_flag_i,branch_flag_i,stall};
    
    //�ж�PC����Դ
    always @ (posedge clk) begin
        case(PC_Source)
            5'b10X00: pc <=  32'h00000000;
            5'b01000: pc <=  new_pc;
            5'b00100: pc <=  jump_target_addr_i;
            5'b00010: pc <=  branch_target_addr_i;
            5'b00001: begin end
            default: pc[31:0] <=  pc[31:0] + 4;
        endcase
    end
   
endmodule
