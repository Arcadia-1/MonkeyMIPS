`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/07 12:16:45
// Design Name: 
// Module Name: defines
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//      Macros, for better understanding in other scripts
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`ifndef defines_v
`define defines_v

module defines;
    //ȫ�ֺ궨��
    `define RstEnable           1'b1            //��λ�ź���Ч
    `define RstDisable          1'b0            //��λ�ź���Ч
    `define WriteEnable         1'b1            //дʹ��
    `define WriteDisable        1'b0            //д��ֹ
    `define ReadEnable          1'b1            //��ʹ��
    `define ReadDisable         1'b0            //����ֹ
    `define AluOpBus            7:0             //ALU����Ŀ��
    `define AluSelBus           2:0             //ALUѡ���źŵĿ��
    `define InstValid           1'b0            //ָ����Ч
    `define InstInvalid         1'b1            //ָ����Ч
    `define ChipEnable          1'b1            //оƬ��Ч
    `define ChipDisable         1'b0            //оƬ��ֹ
    `define NoStall             1'b0            //��������ˮ��
    `define Stall               1'b1            //������ˮ��
    `define ZeroWord            32'h00000000    //32λ��ֵ0
    
    //�����ָ���йصĺ궨��
    `define EXE_J               6'b000010       //ָ�j
    `define EXE_JAL             6'b000011       //ָ�jal
    `define EXE_BEQ             6'b000100       //ָ�beq
    `define EXE_BNE             6'b000101       //ָ�bne
    `define EXE_BLEZ            6'b000110       //ָ�blez
    `define EXE_BGTZ            6'b000111       //ָ�bgtz
    
    `define EXE_ADDI            6'b001000       //ָ�addi
    `define EXE_ADDIU           6'b001001       //ָ�addiu
    `define EXE_SLTI            6'b001010       //ָ�slti
    `define EXE_SLTIU           6'b001011       //ָ�sltiu
    
    `define EXE_ANDI            6'b001100       //ָ�andi
    `define EXE_ORI             6'b001101       //ָ�ori
    `define EXE_XORI            6'b001110       //ָ�xori
    `define EXE_LUI             6'b001111       //ָ�lui
    
    `define EXE_LW              6'b100011       //ָ�lw
    `define EXE_SW              6'b101011       //ָ�sw
    
    `define EXE_NOP             6'b000000       //ָ�nop
      
    `define EXE_R_TYPE          6'b000000       //ָ�����ͣ�R��ָ��
    `define EXE_REGIMM_TYPE     6'b000001       //ָ�����ͣ�REGIMM��ָ��
    `define EXE_COP0_TYPE       6'b010000       //ָ�����ͣ�COP0��ָ��
    
    //���¼���ΪEXE_R_TYPE
    `define EXE_AND             6'b100100       //func=and
    `define EXE_OR              6'b100101       //func=or
    `define EXE_XOR             6'b100110       //func=xor
    `define EXE_NOR             6'b100111       //func=nor
    
    `define EXE_SLL             6'b000000       //func��sll
    `define EXE_SRL             6'b000010       //func��srl
    `define EXE_SRA             6'b000011       //func��sra
    `define EXE_SLLV            6'b000100       //func��sllv
    `define EXE_SRLV            6'b000110       //func��srlv
    `define EXE_SRAV            6'b000111       //func��srav
                
    `define EXE_ADD             6'b100000       //func��add
    `define EXE_ADDU            6'b100001       //func��addu
    `define EXE_SUB             6'b100010       //func��sub
    `define EXE_SUBU            6'b100011       //func��subu
    `define EXE_SLT             6'b101010       //func��slt
    `define EXE_SLTU            6'b101011       //func��sltu
    
    `define EXE_MULT            6'b011000       //func��mult
    `define EXE_MULTU           6'b011001       //func��multu
    
    `define EXE_DIV             6'b011010       //func��div
    `define EXE_DIVU            6'b011011       //func��divu

    `define EXE_JR              6'b001000       //func��jr
    `define EXE_JALR            6'b001001       //func��jalr
    
    `define EXE_TEQ             6'b110100       //func��teq
    `define EXE_TGE             6'b110000       //func��tge
    `define EXE_TGEU            6'b110001       //func��tgeu
    `define EXE_TLT             6'b110010       //func��tlt
    `define EXE_TLTU            6'b110011       //func��tltu    
    `define EXE_TNE             6'b110110       //func��tne
    
    `define EXE_SYSCALL         6'b001100       //func��syscall
    `define EXE_SYSCALL_OP      8'b00001100
    
    //���¼���ΪEXE_R2_TYPE
    `define EXE_CLZ             6'b100000       //func��clz, counting leading zeros
    `define EXE_CLO             6'b100001       //func��clo, counting leading ones
    `define EXE_MUL             6'b000010       //func��mul
    `define EXE_MADD            6'b000000       //func��madd
    `define EXE_MADDU           6'b000001       //func��maddu
    `define EXE_MSUB            6'b000100       //func��msub
    `define EXE_MSUBU           6'b000101       //func��msubu
        
    //���¼���ΪEXE_REGIMM_TYPE
    `define EXE_BLTZ            5'b00000        //func��bltz
    `define EXE_BGEZ            5'b00001        //func��bgez
    
    `define EXE_BLTZAL          5'b10000        //func��bltzal
    `define EXE_BGEZAL          5'b10001        //func��bgezal
    
    `define EXE_TEQI            5'b01100        //func��teqi
    `define EXE_TGEI            5'b01000        //func��tgei
    `define EXE_TGEIU           5'b01001        //func��tgeiu 
    `define EXE_TLTI            5'b01010        //func��tlti
    `define EXE_TLTIU           5'b01011        //func��tltiu    
    `define EXE_TNEI            5'b01110        //func��tnei

        
    //���¼���ΪEXE_COP0_TYPE
    `define EXE_MTC0            5'b00100        //func��mtc0
    `define EXE_MFC0            5'b00000        //func��mfc0
    `define EXE_ERET            6'b10000        //func��eret
    
    //AluOp
    //��֧��תָ��
    `define EXE_BEQ_OP          8'b11000100       //ָ�beq
    `define EXE_BNE_OP          8'b11000101       //ָ�bne
    `define EXE_BLEZ_OP         8'b11000110       //ָ�blez
    `define EXE_BGTZ_OP         8'b11000111       //ָ�bgtz
    `define EXE_BLTZ_OP         8'b11100000       //func��bltz
    `define EXE_BGEZ_OP         8'b11100001       //func��bgez    

    `define EXE_JR_OP           8'b11001000       //func��jr
    `define EXE_JALR_OP         8'b11001001       //func��jalr
    `define EXE_J_OP            8'b11000010       //ָ�j
    `define EXE_JAL_OP          8'b11000011       //ָ�jal
    
    //�߼�����ָ��
    `define EXE_AND_OP          8'b00100100
    `define EXE_OR_OP           8'b00100101
    `define EXE_XOR_OP          8'b00100110
    `define EXE_NOR_OP          8'b00100111
    
    `define EXE_SLL_OP          8'b00000000
    `define EXE_SRL_OP          8'b00000010
    `define EXE_SRA_OP          8'b00000011
            
    `define EXE_ADD_OP          8'b00100000
    `define EXE_ADDU_OP         8'b00100001
    `define EXE_SUB_OP          8'b00100010
    `define EXE_SUBU_OP         8'b00100011
    `define EXE_SLT_OP          8'b00101010
    `define EXE_SLTU_OP         8'b00101011
    
    `define EXE_MULT_OP         8'b00011000
    `define EXE_MULTU_OP        8'b00011001
    `define EXE_DIV_OP          8'b00011010
    `define EXE_DIVU_OP         8'b00011011
        
    `define EXE_LW_OP           8'b00100011
    `define EXE_SW_OP           8'b00101011
    
    `define EXE_TEQ_OP          8'b00110100
    `define EXE_TGE_OP          8'b00110000
    `define EXE_TGEU_OP         8'b00110001 
    `define EXE_TLT_OP          8'b00110010
    `define EXE_TLTU_OP         8'b00110011     
    `define EXE_TNE_OP          8'b00110110
    
    `define EXE_NOP_OP          8'b00000000
    
    //���¼���ΪEXE_R2_TYPE
    `define EXE_CLZ_OP          8'b01100000
    `define EXE_CLO_OP          8'b01100001
    `define EXE_MUL_OP          8'b01000010
    `define EXE_MADD_OP         8'b01000000
    `define EXE_MADDU_OP        8'b01000001
    `define EXE_MSUB_OP         8'b01000100
    `define EXE_MSUBU_OP        8'b01000101
    
    //���¼���ΪEXE_COP0_TYPE
    `define EXE_MTC0_OP         8'b10000100
    `define EXE_MFC0_OP         8'b10000000
    `define EXE_ERET_OP         8'b10010000
    
    //AluSel
    `define EXE_RES_LOGIC       3'b001
    `define EXE_RES_SHIFT       3'b010
    `define EXE_RES_MOVE        3'b100
    `define EXE_RES_ARITHMETRIC 3'b101
    `define EXE_RES_JUMP_BRANCH 3'b111
    `define EXE_RES_LOAD_STORE  3'b011
    `define EXE_RES_NOP         3'b000    
    
    //��ָ��洢���йصĺ궨��
    `define InstAddrBus         31:0            //ROM�ĵ�ַ���߿��
    `define InstBus             31:0            //ROM���������߿��
    `define InstMemNum          512             //ROM��ʵ�ʴ�СΪ128B=512��
    `define InstMemNumLog2      9               //ROMʵ��ʹ�õĵ�ַ�߿��
    
    //�����ݴ洢���йصĺ궨��
    `define DataAddrBus         31:0            //RAM�ĵ�ַ���߿��
    `define DataBus             31:0            //RAM���������߿��
    `define ByteWidth           7:0             //һ���ֽڵĿ�ȣ�1 Byte = 8 bit
    `define DataMemNum          110             //ROM��ʵ�ʴ�СΪ64B
    `define DataMemNumLog2      8               //ROMʵ��ʹ�õĵ�ַ�߿��
    
    //��Ĵ�������صĺ궨��
    `define RegAddrBus          4:0             //�Ĵ�����ַ���
    `define RegBus              31:0            //�Ĵ������ݿ��
    `define DoubleRegBus        63:0            //˫���Ĵ������ݿ�ȣ����ڴ�ų˷����
    `define RegWidth            32              //ͨ�üĴ����Ŀ��
    `define RegNum              32              //ͨ�üĴ����ĸ���
    `define RegNumLog2          5               //�Ĵ�����ַλ��
    `define NOPRegAddr          5'b00000        //NOPָ��ļĴ�����ַ
                
    //������йصĺ궨��
    `define DivFree             2'b00
    `define DivByZero           2'b01
    `define DivOn               2'b10
    `define DivEnd              2'b11
    `define DivResultReady      1'b1
    `define DivResultNotReady   1'b0
    `define DivStart            1'b1 
    `define DivStop             1'b0
    
    //��ת���йصĺ궨��
    `define Branch              1'b1            //ת��
    `define NoBranch            1'b0            //��ת��
    `define InDelaySlot         1'b1            //���ӳٲ���
    `define NotInDelaySlot      1'b0            //�����ӳٲ���
    
    //��Э�������йصĺ궨��
    `define Interrupt           1'b1            //������ʱ�ж�
    `define NoInterrupt         1'b0            //��������ʱ�ж�
    
    `define CP0_REG_COUNT       5'b01001        //Count�Ĵ���
    `define CP0_REG_COMPARE     5'b01011        //Compare�Ĵ���
    `define CP0_REG_STATUS      5'b01100        //Status�Ĵ���
    `define CP0_REG_CAUSE       5'b01101        //Cause�Ĵ���
    `define CP0_REG_EPC         5'b01110        //EPC�Ĵ���
    `define CP0_REG_PRID        5'b01111        //PRId�Ĵ���
    `define CP0_REG_CONFIG      5'b10000        //Config�Ĵ���
    
    //���쳣�����йصĺ궨��
    `define FLUSH               1'b1            //��ˮ��Flush
    `define NOFLUSH             1'b0            //��ˮ�߲�Flus
    `define TRAP                1'b1            //��ˮ��Trap
    `define NOTRAP              1'b0            //��ˮ�߲�Trap
    
    `define FALSE               1'b0            //False
    `define TRUE                1'b1            //True
    
    `define Enable              1'b1            //Enable
    `define Disable             1'b0            //Disable
    
    `define Core                1'b1            //�ں�̬
    `define Normal              1'b0            //��̬ͨ              
endmodule

`endif