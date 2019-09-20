`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/07 20:24:49
// Design Name: 
// Module Name: id_ex
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//      The registers between stage ID and EX.
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module id_ex(
    input clk,
    input stall,
    input [`InstBus] id_inst,    
    output reg [`InstBus] ex_inst,
    
    //�ж�������Դ
    input [`RegBus] id_imm,                   //32λ������
    input id_reg1_read_o,
    input id_reg2_read_o,
    input [`RegAddrBus] id_reg1_addr_o,
    input [`RegAddrBus] id_reg2_addr_o,
    
    //��ȡ��Regfile��ֵ
    input [`RegBus] RF_reg1_data_i,
    input [`RegBus] RF_reg2_data_i,
        
    //EX�׶ε�ָ�����������Forwarding��
    input ex_w_reg_o,                    //�Ƿ�Ҫд��Ŀ�ļĴ���
    input [`RegAddrBus] ex_w_dest_o,     //Ҫд���Ŀ�ļĴ�����ַ
    input [`RegBus] ex_w_data_o,         //Ҫд��Ŀ�ļĴ���������   
     
    //MEM�׶ε�ָ����������Forwarding��
    input mem_w_reg_o,                   //�Ƿ�Ҫд��Ŀ�ļĴ��� 
    input [`RegAddrBus] mem_w_dest_o,    //Ҫд���Ŀ�ļĴ�����ַ
    input [`RegBus] mem_w_data_o,        //Ҫд��Ŀ�ļĴ���������
        
    //�����쳣�������ӵĽӿ�
    input flush,
    input [`RegBus] id_excepttype,
    input [`RegBus] id_current_inst_addr,
    output reg [`RegBus] ex_excepttype,
    output reg [`RegBus] ex_current_inst_addr,
    
    //����Э���������ӵĽӿ�
    input [`RegAddrBus] id_MFC0_r_addr,
    output reg [`RegAddrBus] ex_MFC0_r_addr,
    
    //������׶δ�������Ϣ
    input [`AluSelBus] id_alusel,
    input [`AluOpBus] id_aluop,
    input [`RegBus] id_reg1,
    input [`RegBus] id_reg2,
    input [`RegAddrBus] id_wd,
    input id_w_reg,
    
    //���ݵ�ִ�н׶ε���Ϣ
    output reg [`AluSelBus] ex_alusel,
    output reg [`AluOpBus] ex_aluop,
    output reg [`RegBus] ex_reg1,
    output reg [`RegBus] ex_reg2,
    output reg [`RegAddrBus] ex_w_dest,
    output reg ex_w_reg
    );
   
    
    always @ (posedge clk) begin        
        if((flush == `FLUSH)||(stall==`Stall)) begin
            ex_aluop <= `EXE_NOP_OP;
            ex_alusel <= `EXE_RES_NOP;            
            ex_reg1 <= `ZeroWord;
            ex_reg2 <= `ZeroWord;
            ex_w_dest <= `NOPRegAddr;
            ex_w_reg <= `WriteDisable;                
            ex_MFC0_r_addr <= `NOPRegAddr;            
            ex_excepttype <= `ZeroWord;
            ex_current_inst_addr <= `ZeroWord;            
            ex_inst <= `ZeroWord;
            
        end else begin
            ex_alusel <= id_alusel;
            ex_aluop <= id_aluop;
            ex_w_dest <= id_wd;
            ex_w_reg <= id_w_reg;                        
            ex_MFC0_r_addr <= id_MFC0_r_addr;            
            ex_excepttype <= id_excepttype;
            ex_current_inst_addr <= id_current_inst_addr;            
            ex_inst <= id_inst;
                         
            //         EX/MEM hazard:
            //         if(EX/MEM.RegWrite 
            //         and (EX/MEM.RegisterRd != 0) 
            //         and (EX/MEM.RegisterRd == ID/EX.RegisterRs)
            if((ex_w_dest_o == id_reg1_addr_o)
                &&(ex_w_dest_o != `RegNumLog2'h0)
                &&(ex_w_reg_o == `WriteEnable)
                &&(id_reg1_read_o == `ReadEnable)  
                )begin
                ex_reg1 <= ex_w_data_o;
            end 
        
            //         MEM/WB hazard:
            //         if(MEM/WB.RegWrite 
            //         and (MEM/WB.RegisterRd != 0) 
            //         and (MEM/WB.RegisterRd == ID/EX.RegisterRs) 
            //         and (EX/MEM.RegisterRd != ID/EX.RegisterRs || ~ EX/MEM.RegWrite))        
            else if((mem_w_dest_o == id_reg1_addr_o)            
                &&(mem_w_dest_o != `RegNumLog2'h0)
                &&(mem_w_reg_o == `WriteEnable)
                &&(id_reg1_read_o == `ReadEnable)
                &&((ex_w_dest_o != id_reg1_addr_o)||(ex_w_reg_o == `WriteDisable))
                ) begin
                ex_reg1 <= mem_w_data_o;
            end
        
            else begin
                if(id_reg1_read_o == `ReadEnable)
                    ex_reg1 <= RF_reg1_data_i;      //ȡ ���Ĵ����˿�1 �����ֵ
                else
                    ex_reg1 <= id_imm;              //ȡ ������
            end
    
                  
            //         EX/MEM hazard:
            //         if(EX/MEM.RegWrite 
            //         and (EX/MEM.RegisterRd != 0) 
            //         and (EX/MEM.RegisterRd == ID/EX.RegisterRt)
            if((ex_w_dest_o == id_reg2_addr_o)
                &&(ex_w_dest_o != `RegNumLog2'h0)
                &&(ex_w_reg_o == `WriteEnable)
                &&(id_reg2_read_o == `ReadEnable)          
                )begin
                ex_reg2 <= ex_w_data_o;
            end 
        
            //         MEM/WB hazard:
            //         if(MEM/WB.RegWrite 
            //         and (MEM/WB.RegisterRd != 0) 
            //         and (MEM/WB.RegisterRd == ID/EX.RegisterRs) 
            //         and (EX/MEM.RegisterRd != ID/EX.RegisterRs || ~ EX/MEM.RegWrite))        
            else if((mem_w_dest_o == id_reg2_addr_o)            
                &&(mem_w_dest_o != `RegNumLog2'h0)
                &&(mem_w_reg_o == `WriteEnable)
                &&(id_reg2_read_o == `ReadEnable)
                &&((ex_w_dest_o != id_reg2_addr_o)||(ex_w_reg_o == `WriteDisable))
                ) begin
                ex_reg2 <= mem_w_data_o;
            end
        
            else begin
                if(id_reg2_read_o == `ReadEnable)
                    ex_reg2 <= RF_reg2_data_i;      //ȡ ���Ĵ����˿�2 �����ֵ
                else
                    ex_reg2 <= id_imm;              //ȡ ������
            end
            
        end
    end 
    
endmodule
