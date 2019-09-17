`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/09/10 15:31:34
// Design Name: 
// Module Name: ApeMIPS_SOPC
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


module MonkeyMIPS_SOPC(

    input rst,
    input clk,
    
    //利用 SW1 和 SW0 选择将     的最低 16bit，
    //以 16 进制的形式显示在 7 段数码管上
    input wire SW1,SW0,
    output wire [6:0] cathodes,    
    output wire [3:0] AN,
    
    //将 PC 寄存器值的最低 16bit，显示在 LED7~LED0 上
    output wire [7:0] LED
    );
    
    wire [`InstAddrBus] inst_addr;
    wire [`InstBus] inst;
    
    //数据存储器data_ram和外设peripheral共有的交互  
    wire [`DataAddrBus] addr_from_mem;
    wire [`RegBus] data_from_mem;
    
    //与数据存储器data_ram的交互
    wire we_to_dataram; 
    wire [`RegBus] data_from_dataram;
    
    //与外设peripheral的交互
    wire we_to_peripheral;
    wire [`RegBus] data_from_peripheral;  
    
    
    wire [5:0] int;
    wire timer_int;
    
    assign int = {5'b00000,timer_int};
    
    
    //OpenMIPS处理器例化
    MonkeyMIPS MonkeyMIPS0(
        .clk(clk),
        .rst(rst),
        .rom_addr_o(inst_addr),
        .rom_data_i(inst),
        .int_i(int),
//        .timer_int_o(timer_int),
                
        .data_from_mem(data_from_mem),
        .addr_from_mem(addr_from_mem),
        
        .we_to_dataram(we_to_dataram),
        .we_to_peripheral(we_to_peripheral),
        
        .data_from_dataram(data_from_dataram),
        .data_from_peripheral(data_from_peripheral)        
    );
    
    //数据存储器例化
    data_ram data_ram0(
        .clk(clk),
        .we(we_to_dataram),
        .addr(addr_from_mem),
        .data_i(data_from_mem),
        .data_o(data_from_dataram)
    );
            
    peripheral peripheral0(
        .clk(clk),
        .rst(rst),
        .we(we_to_peripheral),
        .SW0(SW0),
        .wdata(data_from_mem),
        .addr(addr_from_mem),
        .rdata(data_from_peripheral),
        .timer_interrupt(timer_int),
        .led(LED),                          //外部LED
        .digi({cathodes,AN})                //七段数码管
    );
    
    //指令存储器例化
    inst_rom inst_rom0(
        .addr(inst_addr),
        .inst(inst)
    );
    
endmodule
