`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/17 01:50:14
// Design Name: 
// Module Name: ctrl
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

module ctrl(    
    //由于异常处理增加的接口
    input [`RegBus] excepttype_i,
    input [`RegBus] cp0_epc_i,    
    output reg [`RegBus] new_pc,
    output reg flush,
    
    input stall_request_from_ex,        //EX阶段的指令是否请求流水线暂停
    
    output reg [5:0] stall              //暂停流水线控制信号，宽度为6位
                                        //stall[0] = 1，PC不变
                                        //stall[1] = 1，IF阶段暂停
                                        //stall[2] = 1，ID阶段暂停
                                        //stall[3] = 1，EX阶段暂停
                                        //stall[4] = 1，MEM阶段暂停
                                        //stall[5] = 1，WB阶段暂停

    );
    
    always @ (*) begin
        if (excepttype_i != `ZeroWord) begin
            flush <= `FLUSH;
            
            case (excepttype_i)
                32'h00000001: begin         //中断
                    new_pc <= 32'h80000004;
                end         
                       
                32'h0000000a: begin         //异常：无效指令
                    new_pc <= 32'h80000004;
                end
                                
                32'h0000000e: begin         //异常返回
                    new_pc <= cp0_epc_i;
                end
                            
            endcase
            
        end
        else if (stall_request_from_ex == `Stall) begin
            stall <= 6'b000111;
            flush <= `NOFLUSH;
        end else begin
            stall <= 6'b000000;
            flush <= `NOFLUSH;
        end
    end
    
endmodule
