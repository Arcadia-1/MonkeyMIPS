//`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////
//// Company: 
//// Engineer: 
//// 
//// Create Date: 2019/07/07 21:13:01
//// Design Name: 
//// Module Name: ex_mem
//// Project Name: 
//// Target Devices: 
//// Tool Versions: 
//// Description: 
////      The registers between stage EX and MEM.
//// Dependencies: 
//// 
//// Revision:
//// Revision 0.01 - File Created
//// Additional Comments:
//// 
////////////////////////////////////////////////////////////////////////////////////


module ex_mem(
    input clk,
    input stall,
        
    //����lw��sw���ӵĽӿ�  
    input [`AluOpBus] ex_aluop,
    input [`RegBus] ex_mem_addr,
    input [`RegBus] ex_reg2,
    
    output reg [`AluOpBus] mem_aluop,
    output reg [`RegBus] mem_mem_addr,
    output reg [`RegBus] mem_reg2,
    
    //�����쳣�������ӵĽӿ�
    input flush,
    input [`RegBus] ex_excepttype,
    input [`RegBus] ex_current_inst_addr,
    
    output reg [`RegBus] mem_excepttype,
    output reg [`RegBus] mem_current_inst_addr,
    
    //����Э���������ӵĽӿ� 
    input ex_cp0_we,                            //�Ƿ�ҪдCP0�еļĴ���
    input [`RegAddrBus] ex_cp0_w_addr,          //Ҫд���CP0�мĴ����ĵ�ַ
    input [`RegBus] ex_cp0_w_data,              //Ҫд��CP0����ֵ
      
    output reg mem_cp0_we,                      //�Ƿ�ҪдCP0�еļĴ���
    output reg [`RegAddrBus] mem_cp0_w_addr,    //Ҫд���CP0�мĴ����ĵ�ַ
    output reg [`RegBus] mem_cp0_w_data,        //Ҫд��CP0����ֵ
    
    //��ִ�н׶δ�������Ϣ
    input ex_w_reg,
    input [`RegAddrBus] ex_w_dest,
    input [`RegBus] ex_data,
    
    //���ݵ��ô�׶ε���Ϣ
    output reg mem_w_reg,
    output reg [`RegAddrBus] mem_w_dest,
    output reg [`RegBus] mem_w_data
    );
    
    always @ (posedge clk)begin
        if (flush == `FLUSH) begin
            mem_w_reg <= `WriteDisable;
            mem_w_dest <= `NOPRegAddr;
            mem_w_data <= `ZeroWord;
            
            mem_cp0_we <= `WriteDisable;
            mem_cp0_w_addr <= `NOPRegAddr;
            mem_cp0_w_data <= `ZeroWord;
            
            mem_excepttype <= `ZeroWord;
            mem_current_inst_addr <= `ZeroWord;
            
            mem_aluop <= `EXE_NOP_OP;
            mem_mem_addr <= `ZeroWord;
            mem_reg2 <=  `ZeroWord;
           
        end else begin
            mem_w_reg <= ex_w_reg;
            mem_w_dest <= ex_w_dest;
            mem_w_data <= ex_data;           
            
            mem_cp0_we <= ex_cp0_we;
            mem_cp0_w_addr <= ex_cp0_w_addr;
            mem_cp0_w_data <= ex_cp0_w_data;
            
            mem_excepttype <= ex_excepttype;
            mem_current_inst_addr <=ex_current_inst_addr;
            
            mem_aluop <= ex_aluop;
            
            mem_mem_addr <= ex_mem_addr;
            
            mem_reg2 <= ex_reg2;
                  
        end
    end 
    
endmodule