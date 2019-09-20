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
    //全局宏定义
    `define RstEnable           1'b1            //复位信号有效
    `define RstDisable          1'b0            //复位信号无效
    `define WriteEnable         1'b1            //写使能
    `define WriteDisable        1'b0            //写禁止
    `define ReadEnable          1'b1            //读使能
    `define ReadDisable         1'b0            //读禁止
    `define AluOpBus            7:0             //ALU输出的宽度
    `define AluSelBus           2:0             //ALU选择信号的宽度
    `define InstValid           1'b0            //指令有效
    `define InstInvalid         1'b1            //指令无效
    `define ChipEnable          1'b1            //芯片有效
    `define ChipDisable         1'b0            //芯片禁止
    `define NoStall             1'b0            //不阻塞流水线
    `define Stall               1'b1            //阻塞流水线
    `define ZeroWord            32'h00000000    //32位数值0
    
    //与具体指令有关的宏定义
    `define EXE_J               6'b000010       //指令：j
    `define EXE_JAL             6'b000011       //指令：jal
    `define EXE_BEQ             6'b000100       //指令：beq
    `define EXE_BNE             6'b000101       //指令：bne
    `define EXE_BLEZ            6'b000110       //指令：blez
    `define EXE_BGTZ            6'b000111       //指令：bgtz
    
    `define EXE_ADDI            6'b001000       //指令：addi
    `define EXE_ADDIU           6'b001001       //指令：addiu
    `define EXE_SLTI            6'b001010       //指令：slti
    `define EXE_SLTIU           6'b001011       //指令：sltiu
    
    `define EXE_ANDI            6'b001100       //指令：andi
    `define EXE_ORI             6'b001101       //指令：ori
    `define EXE_XORI            6'b001110       //指令：xori
    `define EXE_LUI             6'b001111       //指令：lui
    
    `define EXE_LW              6'b100011       //指令：lw
    `define EXE_SW              6'b101011       //指令：sw
    
    `define EXE_NOP             6'b000000       //指令：nop
      
    `define EXE_R_TYPE          6'b000000       //指令类型：R型指令
    `define EXE_REGIMM_TYPE     6'b000001       //指令类型：REGIMM型指令
    `define EXE_COP0_TYPE       6'b010000       //指令类型：COP0型指令
    
    //以下几条为EXE_R_TYPE
    `define EXE_AND             6'b100100       //func=and
    `define EXE_OR              6'b100101       //func=or
    `define EXE_XOR             6'b100110       //func=xor
    `define EXE_NOR             6'b100111       //func=nor
    
    `define EXE_SLL             6'b000000       //func：sll
    `define EXE_SRL             6'b000010       //func：srl
    `define EXE_SRA             6'b000011       //func：sra
    `define EXE_SLLV            6'b000100       //func：sllv
    `define EXE_SRLV            6'b000110       //func：srlv
    `define EXE_SRAV            6'b000111       //func：srav
                
    `define EXE_ADD             6'b100000       //func：add
    `define EXE_ADDU            6'b100001       //func：addu
    `define EXE_SUB             6'b100010       //func：sub
    `define EXE_SUBU            6'b100011       //func：subu
    `define EXE_SLT             6'b101010       //func：slt
    `define EXE_SLTU            6'b101011       //func：sltu
    
    `define EXE_MULT            6'b011000       //func：mult
    `define EXE_MULTU           6'b011001       //func：multu
    
    `define EXE_DIV             6'b011010       //func：div
    `define EXE_DIVU            6'b011011       //func：divu

    `define EXE_JR              6'b001000       //func：jr
    `define EXE_JALR            6'b001001       //func：jalr
    
    `define EXE_TEQ             6'b110100       //func：teq
    `define EXE_TGE             6'b110000       //func：tge
    `define EXE_TGEU            6'b110001       //func：tgeu
    `define EXE_TLT             6'b110010       //func：tlt
    `define EXE_TLTU            6'b110011       //func：tltu    
    `define EXE_TNE             6'b110110       //func：tne
    
    `define EXE_SYSCALL         6'b001100       //func：syscall
    `define EXE_SYSCALL_OP      8'b00001100
    
    //以下几条为EXE_R2_TYPE
    `define EXE_CLZ             6'b100000       //func：clz, counting leading zeros
    `define EXE_CLO             6'b100001       //func：clo, counting leading ones
    `define EXE_MUL             6'b000010       //func：mul
    `define EXE_MADD            6'b000000       //func：madd
    `define EXE_MADDU           6'b000001       //func：maddu
    `define EXE_MSUB            6'b000100       //func：msub
    `define EXE_MSUBU           6'b000101       //func：msubu
        
    //以下几条为EXE_REGIMM_TYPE
    `define EXE_BLTZ            5'b00000        //func：bltz
    `define EXE_BGEZ            5'b00001        //func：bgez
    
    `define EXE_BLTZAL          5'b10000        //func：bltzal
    `define EXE_BGEZAL          5'b10001        //func：bgezal
    
    `define EXE_TEQI            5'b01100        //func：teqi
    `define EXE_TGEI            5'b01000        //func：tgei
    `define EXE_TGEIU           5'b01001        //func：tgeiu 
    `define EXE_TLTI            5'b01010        //func：tlti
    `define EXE_TLTIU           5'b01011        //func：tltiu    
    `define EXE_TNEI            5'b01110        //func：tnei

        
    //以下几条为EXE_COP0_TYPE
    `define EXE_MTC0            5'b00100        //func：mtc0
    `define EXE_MFC0            5'b00000        //func：mfc0
    `define EXE_ERET            6'b10000        //func：eret
    
    //AluOp
    //分支跳转指令
    `define EXE_BEQ_OP          8'b11000100       //指令：beq
    `define EXE_BNE_OP          8'b11000101       //指令：bne
    `define EXE_BLEZ_OP         8'b11000110       //指令：blez
    `define EXE_BGTZ_OP         8'b11000111       //指令：bgtz
    `define EXE_BLTZ_OP         8'b11100000       //func：bltz
    `define EXE_BGEZ_OP         8'b11100001       //func：bgez    

    `define EXE_JR_OP           8'b11001000       //func：jr
    `define EXE_JALR_OP         8'b11001001       //func：jalr
    `define EXE_J_OP            8'b11000010       //指令：j
    `define EXE_JAL_OP          8'b11000011       //指令：jal
    
    //逻辑运算指令
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
    
    //以下几条为EXE_R2_TYPE
    `define EXE_CLZ_OP          8'b01100000
    `define EXE_CLO_OP          8'b01100001
    `define EXE_MUL_OP          8'b01000010
    `define EXE_MADD_OP         8'b01000000
    `define EXE_MADDU_OP        8'b01000001
    `define EXE_MSUB_OP         8'b01000100
    `define EXE_MSUBU_OP        8'b01000101
    
    //以下几条为EXE_COP0_TYPE
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
    
    //与指令存储器有关的宏定义
    `define InstAddrBus         31:0            //ROM的地址总线宽度
    `define InstBus             31:0            //ROM的数据总线宽度
    `define InstMemNum          512             //ROM的实际大小为128B=512条
    `define InstMemNumLog2      9               //ROM实际使用的地址线宽度
    
    //与数据存储器有关的宏定义
    `define DataAddrBus         31:0            //RAM的地址总线宽度
    `define DataBus             31:0            //RAM的数据总线宽度
    `define ByteWidth           7:0             //一个字节的宽度：1 Byte = 8 bit
    `define DataMemNum          110             //ROM的实际大小为64B
    `define DataMemNumLog2      8               //ROM实际使用的地址线宽度
    
    //与寄存器堆相关的宏定义
    `define RegAddrBus          4:0             //寄存器地址宽度
    `define RegBus              31:0            //寄存器数据宽度
    `define DoubleRegBus        63:0            //双倍寄存器数据宽度，用于存放乘法结果
    `define RegWidth            32              //通用寄存器的宽度
    `define RegNum              32              //通用寄存器的个数
    `define RegNumLog2          5               //寄存器地址位数
    `define NOPRegAddr          5'b00000        //NOP指令的寄存器地址
                
    //与除法有关的宏定义
    `define DivFree             2'b00
    `define DivByZero           2'b01
    `define DivOn               2'b10
    `define DivEnd              2'b11
    `define DivResultReady      1'b1
    `define DivResultNotReady   1'b0
    `define DivStart            1'b1 
    `define DivStop             1'b0
    
    //与转移有关的宏定义
    `define Branch              1'b1            //转移
    `define NoBranch            1'b0            //不转移
    `define InDelaySlot         1'b1            //在延迟槽中
    `define NotInDelaySlot      1'b0            //不在延迟槽中
    
    //与协处理器有关的宏定义
    `define Interrupt           1'b1            //发生定时中断
    `define NoInterrupt         1'b0            //不发生定时中断
    
    `define CP0_REG_COUNT       5'b01001        //Count寄存器
    `define CP0_REG_COMPARE     5'b01011        //Compare寄存器
    `define CP0_REG_STATUS      5'b01100        //Status寄存器
    `define CP0_REG_CAUSE       5'b01101        //Cause寄存器
    `define CP0_REG_EPC         5'b01110        //EPC寄存器
    `define CP0_REG_PRID        5'b01111        //PRId寄存器
    `define CP0_REG_CONFIG      5'b10000        //Config寄存器
    
    //与异常处理有关的宏定义
    `define FLUSH               1'b1            //流水线Flush
    `define NOFLUSH             1'b0            //流水线不Flus
    `define TRAP                1'b1            //流水线Trap
    `define NOTRAP              1'b0            //流水线不Trap
    
    `define FALSE               1'b0            //False
    `define TRUE                1'b1            //True
    
    `define Enable              1'b1            //Enable
    `define Disable             1'b0            //Disable
    
    `define Core                1'b1            //内核态
    `define Normal              1'b0            //普通态              
endmodule

`endif