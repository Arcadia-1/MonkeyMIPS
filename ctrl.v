`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/17 01:50:14
// Design Name: 
// Module Name: ctrl
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

module ctrl(    
    //�����쳣�������ӵĽӿ�
    input [3:0] execode_i,
    input [`RegBus] cp0_epc_i,    
    output reg [`RegBus] new_pc,
    output reg flush,    
    input stall_request,        //EX�׶ε�ָ���Ƿ�������ˮ����ͣ    
    output reg stall
    );
    
    always @ (*) begin
        stall <= `FALSE;
        flush <= `NOFLUSH;
        if (stall_request == `Stall) stall <= `TRUE;
        
        case (execode_i)
            4'h0: begin new_pc <= `ZeroWord;    flush <= `NOFLUSH; end
            4'h1: begin new_pc <= 32'h80000004; flush <= `FLUSH; end    //�ж�                       
            4'ha: begin new_pc <= 32'h80000008; flush <= `FLUSH; end    //δ����ָ��
            4'hd: begin new_pc <= 32'h80000004; flush <= `FLUSH; end    //����ָ��
            4'hc: begin new_pc <= 32'h80000004; flush <= `FLUSH; end    //���
            4'he: begin new_pc <= cp0_epc_i;    flush <= `FLUSH; end    //�쳣����
            default: begin end
        endcase
    end
    
endmodule
