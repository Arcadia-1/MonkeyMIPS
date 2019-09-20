`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/05 19:55:53
// Design Name: 
// Module Name: display
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
module divide_1khz(input sysclk, output reg sig_out);
    reg[18:0] state;
    reg[18:0] divide;
    
    initial begin
        sig_out = 0;
        state = 19'b0_0000_0000_0000_0000;
        divide = 19'b001_1000_0110_1010_0000;
        //100M /1000 = 001_1000_0110_1010_0000
        //100M /100 = 111_0100_0010_0100_0000
    end

    always@(posedge sysclk) begin
        if(state == 0) sig_out = ~sig_out;
        state = state + 2;
        if(state == divide) state = 0;
    end
endmodule

module BCD7(
	input [3:0] din,
	output [6:0] dout
);

//6543210 ABCDEFG
assign	dout=(din==4'h0)?7'b0000001:
             (din==4'h1)?7'b1001111:
             (din==4'h2)?7'b0010010:
             (din==4'h3)?7'b0000110:
             (din==4'h4)?7'b1001100:
             (din==4'h5)?7'b0100100:
             (din==4'h6)?7'b0100000:
             (din==4'h7)?7'b0001111:
             (din==4'h8)?7'b0000000:
             (din==4'h9)?7'b0000100:
			 (din==4'hA)?7'b0001000:
			 (din==4'hB)?7'b1100000:
			 (din==4'hC)?7'b0110001:
			 (din==4'hD)?7'b1000010:
			 (din==4'hE)?7'b0110000:
			 (din==4'hF)?7'b0111000:7'b0000001;
endmodule

module bcdShow(
    input[15:0] show, 
    input sysclk, 
    output [6:0] dout, 
    output reg [3:0] AN
    );
    
    wire sig_1khz;
    divide_1khz D_1k(.sysclk(sysclk), .sig_out(sig_1khz));
    
    reg[3:0] bcdIn;
    reg[1:0] control;
    
    BCD7 bcd(bcdIn, dout);

    always@(posedge sig_1khz) begin
        if (control == 2'b00) begin
            bcdIn <= show[3:0]; AN <= 4'b1110; control <= 2'b01;
        end
        else if (control == 2'b01) begin
            bcdIn <= show[7:4]; AN <= 4'b1101; control <= 2'b10;
        end
        else if (control == 2'b10) begin
            bcdIn <= show[11:8]; AN <= 4'b1011; control <= 2'b11;
        end
        else begin
            bcdIn <= show[15:12]; AN <= 4'b0111; control <= 2'b00;
        end
    end
endmodule