`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/08/20 20:45:14
// Design Name: 
// Module Name: peripheral
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

module peripheral(
    input clk,
    input rst,
    input we,
    input SW0,
    input [`DataBus] wdata, 
    input [`DataAddrBus] addr,       
    output reg [`DataBus] rdata,
    output timer_interrupt,             //定时中断信号
    output reg [7:0] led,               //外部LED
    output [11:0] digi              //七段数码管
    );
    
    reg [`RegBus] TH;               //计时器的初值TH
    reg [`RegBus] TL;               //计时器随时间递增TL
    
    reg [`RegBus] systick;          //系统时钟计时器
    reg [`RegBus] number_show;      //要显示的数字
    reg [2:0] TCON;
    
    assign timer_interrupt = TCON[2];

    //读外设寄存器
    always @ (*) begin
        case (addr)
            32'h40000000: rdata <= TH;
            32'h40000004: rdata <= TL;
            32'h40000008: rdata <= {29'b0,TCON};
            32'h4000000C: rdata <= {24'b0,led};
            32'h40000010: rdata <= {20'b0,digi};
            32'h40000014: rdata <= systick;
            default: rdata <= `ZeroWord;
        endcase
    end
    
    
    always @ (posedge clk) begin
        if (rst == `RstEnable) begin
            systick <= `ZeroWord;
            TCON <= 3'b000;            
        end else begin
            
            //计数
            systick <= systick + 1;
            
            //定时器计时
            if (TCON[0] == `Enable) begin
                if (TL==32'hffffffff) begin
                    TL <= TH;
                    if (TCON[1]) 
                        TCON[2] <= `Interrupt;
                    end             
                else TL <= TL + 1;
            end
            
            if (number_show == `ZeroWord) begin
                led <= 8'b11111111;
            end
            
            //写外设寄存器
            if(we ==`WriteEnable) begin
                case (addr)
                    32'h40000000: TH <= wdata;
                    32'h40000004: TL <= wdata;
                    32'h40000008: TCON <= wdata[2:0];
                    32'h4000000C: led <= wdata[7:0];
                    32'h40000010: number_show <= wdata[15:0];
                endcase
            end            
        end
    end    
        
    bcdShow DSP(
        .show(number_show[15:0]),
        .sysclk(clk),
        .dout(digi[11:4]),
        .AN(digi[3:0])
    );
endmodule
