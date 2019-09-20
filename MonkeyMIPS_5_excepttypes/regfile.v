`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/07 13:42:16
// Design Name: 
// Module Name: regfile
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


module regfile(
    input clk,
    
    input we,                           //写使能
    input [`RegAddrBus] waddr,          //要写入的寄存器地址
    input [`RegBus] wdata,              //要写入寄存器的数据
        
    input re1,                          //读使能1
    input [`RegAddrBus] raddr1,         //读寄存器端口1 要读取的寄存器的地址
    output reg [`RegBus] rdata1,        //读寄存器端口1 读取到的值
    
    input re2,                          //读使能2
    input [`RegAddrBus] raddr2,         //读寄存器端口2 要读取的寄存器的地址
    output reg [`RegBus] rdata2         //读寄存器端口2 读取到的值
    );
    
    reg [`RegBus] regs[0:`RegNum-1];    //定义32个寄存器（二维向量）
    
    //写操作
    always @ (posedge clk) begin
        if(we == `WriteEnable) begin     //写使能
            regs[waddr] <= wdata;
        end
    end
    
    //读寄存器端口1
    always @ (*) begin
        if (raddr1 == `RegNumLog2'h0) begin       //所读寄存器为$zero的情况
            rdata1 <= `ZeroWord;
        end else
            //既写又读，此处解决了相邻2条指令时的RAW数据冒险
            if((raddr1 == waddr)&&(we == `WriteEnable)&&(re1 == `ReadEnable)) begin
                rdata1 <= wdata;            
            end else begin
                rdata1 <= regs[raddr1];
            end
    end
    
    //读寄存器端口2
    always @ (*) begin
        if (raddr2 == `RegNumLog2'h0) begin       //所读寄存器为$zero的情况
            rdata2 <= `ZeroWord;
        end else
            if((raddr2 == waddr)&&(we == `WriteEnable)&&(re2 == `ReadEnable)) begin
                rdata2 <= wdata;            //既写又读
            end else begin
                rdata2 <= regs[raddr2];
            end
    end
    
endmodule
