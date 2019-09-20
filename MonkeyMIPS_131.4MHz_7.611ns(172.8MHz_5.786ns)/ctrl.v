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
    //�����쳣�������ӵĽӿ�
    input [`RegBus] excepttype_i,
    input [`RegBus] cp0_epc_i,    
    output reg [`RegBus] new_pc,
    output reg flush,
    
    input stall_request_from_ex,        //EX�׶ε�ָ���Ƿ�������ˮ����ͣ
    
    output reg [5:0] stall              //��ͣ��ˮ�߿����źţ����Ϊ6λ
                                        //stall[0] = 1��PC����
                                        //stall[1] = 1��IF�׶���ͣ
                                        //stall[2] = 1��ID�׶���ͣ
                                        //stall[3] = 1��EX�׶���ͣ
                                        //stall[4] = 1��MEM�׶���ͣ
                                        //stall[5] = 1��WB�׶���ͣ

    );
    
    always @ (*) begin
        if (excepttype_i != `ZeroWord) begin
            flush <= `FLUSH;
            
            case (excepttype_i)
                32'h00000001: begin         //�ж�
                    new_pc <= 32'h80000004;
                end         
                       
                32'h0000000a: begin         //�쳣����Чָ��
                    new_pc <= 32'h80000004;
                end
                                
                32'h0000000e: begin         //�쳣����
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
