`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/07 21:24:14
// Design Name: 
// Module Name: mem_wb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//      The registers between stage MEM and WB.
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mem_wb(
    input clk,
    
    input flush,
    
    //����Э���������ӵĽӿ� 
    input mem_cp0_we,                            //�Ƿ�ҪдCP0�еļĴ���
    input [`RegAddrBus] mem_cp0_w_addr,          //Ҫд���CP0�мĴ����ĵ�ַ
    input [`RegBus] mem_cp0_w_data,              //Ҫд��CP0����ֵ
      
    output reg wb_cp0_we,                      //�Ƿ�ҪдCP0�еļĴ���
    output reg [`RegAddrBus] wb_cp0_w_addr,    //Ҫд���CP0�мĴ����ĵ�ַ
    output reg [`RegBus] wb_cp0_w_data,        //Ҫд��CP0����ֵ
    
    //�ӷô�׶δ�������Ϣ
    input mem_w_reg,
    input [`RegAddrBus] mem_w_dest,
    input [`RegBus] mem_data,
    
    //���ݵ���д�׶ε���Ϣ
    output reg wb_w_reg,
    output reg [`RegAddrBus] wb_w_dest,
    output reg [`RegBus] wb_data
    );
    
    always @ (posedge clk)begin
        if(flush == `FLUSH) begin
            wb_w_reg <= `WriteDisable;
            wb_w_dest <= `NOPRegAddr;
            wb_data <= `ZeroWord;
                        
            wb_cp0_we <= `WriteDisable;
            wb_cp0_w_addr <= `NOPRegAddr;
            wb_cp0_w_data <= `ZeroWord;        
                   
        end else begin
            wb_w_reg <= mem_w_reg;
            wb_w_dest <= mem_w_dest;
            wb_data <= mem_data;
            
            wb_cp0_we <= mem_cp0_we;
            wb_cp0_w_addr <= mem_cp0_w_addr;
            wb_cp0_w_data <= mem_cp0_w_data;
        end
    end 
endmodule
