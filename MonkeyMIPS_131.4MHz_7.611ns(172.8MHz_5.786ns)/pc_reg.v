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
    
    output reg[`InstAddrBus] pc              //要读取的指令地址
    );
    
    
    //判断取值令的来源，共有4次判断
    always @ (posedge clk) begin        
        if (rst == `RstEnable) begin                    //复位，监督位设置为1
            pc <=  32'h00000000;
        end else if (flush == `FLUSH) begin             //工作，但发生异常/中断
            pc <= new_pc;
        end else if (branch_flag_i == `Branch) begin    //没有异常，但跳转/分支
            pc <= branch_target_addr_i; 
        end else if (stall != `Stall) begin                                  //正常情况（PC+4）
            pc[31:0] <= pc[31:0] + 4'h4;
        end
    end
    
endmodule
