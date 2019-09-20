`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/31 09:26:21
// Design Name: 
// Module Name: data_ram
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


module data_ram(
    input clk,
    input we,
    input [`DataAddrBus] addr,
    input [`DataBus] data_i,
    output reg [`DataBus] data_o
    );
           
    reg [`DataBus] data_mem[0:`DataMemNum-1];
    
    //写操作：上升沿写
    always @ (posedge clk) begin
        if(we ==`WriteEnable) begin
            data_mem[addr[`DataMemNumLog2+1:2]] <=data_i;
        end
    end
    
    //读操作：一直在读
    always @ (*) begin
        if(we ==`WriteDisable) begin
            data_o <= data_mem[addr[`DataMemNumLog2+1:2]];
        end else begin
            data_o <= `ZeroWord;
        end
    end
    
endmodule
