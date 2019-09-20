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
    input stall,                      //是否阻塞
    input flush,                            //流水线清除信号
    input [`RegBus] new_pc,                 //异常处理例程入口
    
    input branch_flag_i,                     //是否发生转移
    input [`RegBus] branch_target_addr_i,    //转移的目标地址
    input jump_flag_i,
    input [`RegBus] jump_target_addr_i,
    
    output reg[`InstAddrBus] pc              //要读取的指令地址
    );
    
    wire [4:0] PC_Source;
    assign PC_Source = {rst,flush,jump_flag_i,branch_flag_i,stall};
    
    //判断PC的来源
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
