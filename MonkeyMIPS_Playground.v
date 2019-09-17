`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/09/10 15:31:51
// Design Name: 
// Module Name: ApeMIPS_Playground
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


module MonkeyMIPS_Playground;

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
    
    MonkeyMIPS_SOPC Monkey0(
        .clk(CLOCK_50),.rst(rst)
    );

endmodule
