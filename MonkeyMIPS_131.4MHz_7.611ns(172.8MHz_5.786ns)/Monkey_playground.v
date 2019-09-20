`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/08/04 14:31:02
// Design Name: 
// Module Name: Monkey_playground
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//      Testbench for the 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Monkey_playground;
    reg CLOCK_50;
    reg rst;
    
    initial begin
        CLOCK_50 = 1'b0;
        forever #5 CLOCK_50 = ~CLOCK_50;
    end
    
    initial begin
        rst = `RstEnable;
        #20 rst = `RstDisable;
//        #20000000 $stop;
    end
    
    Monkey_MIPS_sopc Monkey0(
        .clk(CLOCK_50),.rst(rst)
    );

endmodule
