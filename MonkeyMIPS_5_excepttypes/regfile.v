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
    
    input we,                           //дʹ��
    input [`RegAddrBus] waddr,          //Ҫд��ļĴ�����ַ
    input [`RegBus] wdata,              //Ҫд��Ĵ���������
        
    input re1,                          //��ʹ��1
    input [`RegAddrBus] raddr1,         //���Ĵ����˿�1 Ҫ��ȡ�ļĴ����ĵ�ַ
    output reg [`RegBus] rdata1,        //���Ĵ����˿�1 ��ȡ����ֵ
    
    input re2,                          //��ʹ��2
    input [`RegAddrBus] raddr2,         //���Ĵ����˿�2 Ҫ��ȡ�ļĴ����ĵ�ַ
    output reg [`RegBus] rdata2         //���Ĵ����˿�2 ��ȡ����ֵ
    );
    
    reg [`RegBus] regs[0:`RegNum-1];    //����32���Ĵ�������ά������
    
    //д����
    always @ (posedge clk) begin
        if(we == `WriteEnable) begin     //дʹ��
            regs[waddr] <= wdata;
        end
    end
    
    //���Ĵ����˿�1
    always @ (*) begin
        if (raddr1 == `RegNumLog2'h0) begin       //�����Ĵ���Ϊ$zero�����
            rdata1 <= `ZeroWord;
        end else
            //��д�ֶ����˴����������2��ָ��ʱ��RAW����ð��
            if((raddr1 == waddr)&&(we == `WriteEnable)&&(re1 == `ReadEnable)) begin
                rdata1 <= wdata;            
            end else begin
                rdata1 <= regs[raddr1];
            end
    end
    
    //���Ĵ����˿�2
    always @ (*) begin
        if (raddr2 == `RegNumLog2'h0) begin       //�����Ĵ���Ϊ$zero�����
            rdata2 <= `ZeroWord;
        end else
            if((raddr2 == waddr)&&(we == `WriteEnable)&&(re2 == `ReadEnable)) begin
                rdata2 <= wdata;            //��д�ֶ�
            end else begin
                rdata2 <= regs[raddr2];
            end
    end
    
endmodule
