`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/07 12:32:43
// Design Name: 
// Module Name: if_id
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//      The registers between stage IF and ID.
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module if_id(
    input clk,
    
    input flush,
    input stall,              //�Ƿ�����
    
    //��ȡָ�׶δ�������Ϣ
    input [`InstAddrBus] if_pc,
    input [`InstBus] if_inst,
    
    //���ݵ�����׶ε���Ϣ
    output reg [`InstAddrBus] id_pc,
    output reg [`InstBus] id_inst
    );
    
    always @ (posedge clk) begin
        if (flush == `FLUSH) begin
            id_pc <= `ZeroWord;                     //��ָ��
            id_inst <= `ZeroWord;
        end else if (stall != `Stall) begin
            id_pc <= if_pc;
            id_inst <= if_inst;
        end
    end
    
endmodule
