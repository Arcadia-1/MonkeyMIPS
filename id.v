`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/07 15:08:02
// Design Name: 
// Module Name: id
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//      ID stage, instruction decoding
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "defines.v"

module id(    
    input [`InstAddrBus] pc_i,
    input [`InstBus] inst_i,    
    output [`InstBus] inst_o,
    
    //解决Load-use Hazard（Stall）
    input [`RegAddrBus] ex_wd_i,
    input [`AluOpBus] ex_aluop_i,           //ex阶段的指令
    output stall_request,
    
    //由于协处理器增加的接口 
    output [`RegAddrBus] MFC0_r_addr,       //MFC0要读取的地址
    
    //异常处理指令
    output [`RegBus] excepttype_o,          //收集的异常信息
    output [`RegBus] current_pc_o,          //ID阶段指令的地址
    
    //向后传
    output reg [`RegBus] imm,               //32位立即数
    
    //输出到Regfile的值
    output reg reg1_read_o,
    output reg reg2_read_o,
    output reg [`RegAddrBus] reg1_addr_o,
    output reg [`RegAddrBus] reg2_addr_o,
    
    output reg jump_flag_o,                     //跳转
    output reg [`RegBus] jump_target_addr_o,    //跳转的目标地址
        
    //输出到EX阶段的信息    
    output reg [`AluSelBus] alusel_o,   //ALU操作的类型（“操作类型码”）
    output reg [`AluOpBus] aluop_o,     //ALU操作的子类型（“具体操作码”)
    output reg w_reg_o,                 //是否要写入目的寄存器
    output reg [`RegAddrBus] w_dest_o   //要写入的目的寄存器地址
    );
    
    //对指令分段
    wire[5:0] opcode = inst_i[31:26];   //指令码op
    wire[4:0] reg_Rt = inst_i[20:16];   //源寄存器Rt
    wire[4:0] reg_Rs = inst_i[25:21];   //源寄存器Rs
    wire[4:0] reg_Rd = inst_i[15:11];   //目的寄存器Rd
    wire[4:0] shamt = inst_i[10:6];     //偏移量shamt
    wire[5:0] func = inst_i[5:0];       //指令码func
    wire[15:0] imm16 = inst_i[15:0];    //16位立即数
    
    wire [`RegBus] pc_plus_4;  
    assign pc_plus_4 = pc_i + 4;
    
    reg instvalid;
    reg excepttype_is_eret;             //是否是eret异常 
    assign MFC0_r_addr = reg_Rd;
    assign inst_o = inst_i;
    
    assign excepttype_o = {19'b0,excepttype_is_eret,2'b0,instvalid,1'b0,8'b0};
    assign current_pc_o = pc_i;
    
    always @ (*) begin
        aluop_o <= `EXE_NOP_OP;
        alusel_o <= `EXE_RES_NOP;    
        w_reg_o <= `WriteDisable;   
        w_dest_o <= reg_Rd;
        reg1_read_o <= `ReadDisable;
        reg2_read_o <= `ReadDisable;
        reg1_addr_o <= reg_Rs;
        reg2_addr_o <= reg_Rt;
        
        imm <= `ZeroWord;        
        
        instvalid <= `InstInvalid;
        excepttype_is_eret <= `FALSE;
        
        jump_flag_o <= `FALSE;
        jump_target_addr_o <= `ZeroWord;
        
        case (opcode)
            //R型指令
            `EXE_R_TYPE:begin
                case(func)
                    `EXE_AND:begin                  //AND指令
                        w_reg_o <= `WriteEnable;
                        aluop_o <= `EXE_AND_OP;
                        alusel_o <= `EXE_RES_LOGIC;
                        reg1_read_o <= `ReadEnable;                    
                        reg2_read_o <= `ReadEnable; 
                        instvalid <= `InstValid;
                    end
                    
                    `EXE_OR:begin
                        w_reg_o <= `WriteEnable;
                        aluop_o <= `EXE_OR_OP;
                        alusel_o <= `EXE_RES_LOGIC;
                        reg1_read_o <= `ReadEnable;                    
                        reg2_read_o <= `ReadEnable; 
                        instvalid <= `InstValid;
                    end
                    
                    `EXE_XOR:begin
                        w_reg_o <= `WriteEnable;
                        aluop_o <= `EXE_XOR_OP;
                        alusel_o <= `EXE_RES_LOGIC;
                        reg1_read_o <= `ReadEnable;                    
                        reg2_read_o <= `ReadEnable; 
                        instvalid <= `InstValid;
                    end
                    
                    `EXE_NOR:begin
                        w_reg_o <= `WriteEnable;
                        aluop_o <= `EXE_NOR_OP;
                        alusel_o <= `EXE_RES_LOGIC;
                        reg1_read_o <= `ReadEnable;                    
                        reg2_read_o <= `ReadEnable; 
                        instvalid <= `InstValid;
                    end
                    
                    `EXE_SLLV:begin
                        w_reg_o <= `WriteEnable;
                        aluop_o <= `EXE_SLL_OP;
                        alusel_o <= `EXE_RES_SHIFT;
                        reg1_read_o <= `ReadEnable;                    
                        reg2_read_o <= `ReadEnable; 
                        instvalid <= `InstValid;
                    end
                    
                    `EXE_SRLV:begin
                        w_reg_o <= `WriteEnable;
                        aluop_o <= `EXE_SRL_OP;
                        alusel_o <= `EXE_RES_SHIFT;
                        reg1_read_o <= `ReadEnable;                    
                        reg2_read_o <= `ReadEnable; 
                        instvalid <= `InstValid;
                    end
                    
                    `EXE_SRAV:begin
                        w_reg_o <= `WriteEnable;
                        aluop_o <= `EXE_SRA_OP;
                        alusel_o <= `EXE_RES_SHIFT;
                        reg1_read_o <= `ReadEnable;                    
                        reg2_read_o <= `ReadEnable; 
                        instvalid <= `InstValid;
                    end                                                                                                       
               
                    `EXE_ADD:begin
                        w_reg_o <= `WriteEnable;
                        aluop_o <= `EXE_ADD_OP;
                        alusel_o <= `EXE_RES_ARITHMETRIC;
                        reg1_read_o <= `ReadEnable;                    
                        reg2_read_o <= `ReadEnable; 
                        instvalid <= `InstValid;
                    end
                    
                    `EXE_ADDU:begin
                        w_reg_o <= `WriteEnable;
                        aluop_o <= `EXE_ADDU_OP;
                        alusel_o <= `EXE_RES_ARITHMETRIC;
                        reg1_read_o <= `ReadEnable;                    
                        reg2_read_o <= `ReadEnable; 
                        instvalid <= `InstValid;
                    end
                    
                    `EXE_SUB:begin
                        w_reg_o <= `WriteEnable;
                        aluop_o <= `EXE_SUB_OP;
                        alusel_o <= `EXE_RES_ARITHMETRIC;
                        reg1_read_o <= `ReadEnable;                    
                        reg2_read_o <= `ReadEnable; 
                        instvalid <= `InstValid;
                    end
                    
                    `EXE_SUBU:begin
                        w_reg_o <= `WriteEnable;
                        aluop_o <= `EXE_SUBU_OP;
                        alusel_o <= `EXE_RES_ARITHMETRIC;
                        reg1_read_o <= `ReadEnable;                    
                        reg2_read_o <= `ReadEnable; 
                        instvalid <= `InstValid;
                    end
                    
                    `EXE_SLT:begin
                        w_reg_o <= `WriteEnable;
                        aluop_o <= `EXE_SLT_OP;
                        alusel_o <= `EXE_RES_ARITHMETRIC;
                        reg1_read_o <= `ReadEnable;                    
                        reg2_read_o <= `ReadEnable; 
                        instvalid <= `InstValid;
                    end
                    
                    `EXE_SLTU:begin
                        w_reg_o <= `WriteEnable;
                        aluop_o <= `EXE_SLTU_OP;
                        alusel_o <= `EXE_RES_ARITHMETRIC;
                        reg1_read_o <= `ReadEnable;                    
                        reg2_read_o <= `ReadEnable; 
                        instvalid <= `InstValid;
                    end
                                                 
                    `EXE_JR:begin
                        w_reg_o <= `WriteDisable;
                        aluop_o <= `EXE_JR_OP;
                        alusel_o <= `EXE_RES_NOP;   
                        reg1_read_o <= `ReadEnable;                    
                        reg2_read_o <= `ReadDisable;
                        instvalid <= `InstValid;
                    end
                    
                    `EXE_JALR:begin
                        w_reg_o <= `WriteEnable;
                        w_dest_o <= reg_Rd;
                        aluop_o <= `EXE_JALR_OP;
                        alusel_o <= `EXE_RES_JUMP_BRANCH;
                        reg1_read_o <= `ReadEnable;                    
                        reg2_read_o <= `ReadDisable;                        
                        instvalid <= `InstValid;
                    end                                                   
                                                    
                    default:begin
                    end
                endcase
                //end case structure of "func"
                         
                         
            end
            //end the case of "`EXE_R_TYPE"  
            
            `EXE_REGIMM_TYPE: begin
                case(reg_Rt)
                    `EXE_BGEZ: begin
                        w_reg_o <= `WriteDisable;
                        aluop_o <= `EXE_BGEZ_OP;
                        alusel_o <= `EXE_RES_JUMP_BRANCH;
                        reg1_read_o <= `ReadEnable;                    
                        reg2_read_o <= `ReadDisable; 
                        instvalid <= `InstValid;
                    end
                                       
                    `EXE_BLTZ: begin
                        w_reg_o <= `WriteDisable;
                        aluop_o <= `EXE_BLTZ_OP;
                        alusel_o <= `EXE_RES_JUMP_BRANCH;
                        reg1_read_o <= `ReadEnable;                    
                        reg2_read_o <= `ReadDisable;                        
                        instvalid <= `InstValid;                            
                    end
                    
                    `EXE_TEQ: begin
                        w_reg_o <= `WriteDisable;
                        aluop_o <= `EXE_TEQ_OP;
                        alusel_o <= `EXE_RES_NOP;
                        reg1_read_o <= `ReadDisable;                    
                        reg2_read_o <= `ReadDisable;                                                                        
                        instvalid <= `InstValid;
                    end
                    
                    default:begin
                    end
                endcase
                //end case structure of "func"
            end
            //end the case of "`EXE_REGIMM_TYPE"               
            
            `EXE_COP0_TYPE: begin
                case(reg_Rs)        
                    `EXE_MFC0: begin
                        w_reg_o <= `WriteEnable;
                        w_dest_o <= reg_Rt;
                        
                        aluop_o <= `EXE_MFC0_OP;
                        alusel_o <= `EXE_RES_MOVE;
                        
                        reg1_read_o <= `ReadDisable;                    
                        reg2_read_o <= `ReadDisable;
                        
                        instvalid <= `InstValid;
                    end
                    
                    `EXE_MTC0: begin
                        w_reg_o <= `WriteDisable;
                                                    
                        aluop_o <= `EXE_MTC0_OP;
                        alusel_o <= `EXE_RES_MOVE;
                        
                        reg1_read_o <= `ReadEnable;
                        reg1_addr_o <= reg_Rt;
                        reg2_read_o <= `ReadDisable;
                        
                        instvalid <= `InstValid;
                    end
                    
                    `EXE_ERET: begin
                        w_reg_o <= `WriteDisable;
                        aluop_o <= `EXE_ERET_OP;
                        alusel_o <= `EXE_RES_NOP;
                        reg1_read_o <= `ReadDisable;
                        reg2_read_o <= `ReadDisable;
                        instvalid <= `InstValid;
                        
                        excepttype_is_eret <= `TRUE;
                    end
                    
                    default:begin
                    end
                endcase
                //end case structure of "func"
            end
            //end the case of "`EXE_COP0_TYPE"
                            
            
            `EXE_LW: begin
                w_reg_o <= `WriteEnable;
                w_dest_o <= reg_Rt;
                aluop_o <= `EXE_LW_OP;
                alusel_o <= `EXE_RES_LOAD_STORE;
                reg1_read_o <= `ReadEnable;                    
                reg2_read_o <= `ReadDisable;
                instvalid <= `InstValid;
            end
            
            `EXE_SW: begin
                w_reg_o <= `WriteDisable;
                aluop_o <= `EXE_SW_OP;
                alusel_o <= `EXE_RES_LOAD_STORE;
                reg1_read_o <= `ReadEnable;
                reg2_read_o <= `ReadEnable;
                instvalid <= `InstValid;
            end
                 
            `EXE_J: begin
                w_reg_o <= `WriteDisable;
                aluop_o <= `EXE_J_OP;
                alusel_o <= `EXE_RES_JUMP_BRANCH;
                reg1_read_o <= `ReadDisable;                    
                reg2_read_o <= `ReadDisable;
                instvalid <= `InstValid;
                jump_flag_o <= `TRUE;
                jump_target_addr_o <= {pc_plus_4[31:28],inst_i[25:0],2'b00};
            end
            
            `EXE_JAL: begin
                w_reg_o <= `WriteEnable;
                aluop_o <= `EXE_JAL_OP;
                alusel_o <= `EXE_RES_JUMP_BRANCH;
                reg1_read_o <= `ReadDisable;                    
                reg2_read_o <= `ReadDisable;                
                w_dest_o <= 5'b11111;
                instvalid <= `InstValid;
                jump_flag_o <= `TRUE;
                jump_target_addr_o <= {pc_plus_4[31:28],inst_i[25:0],2'b00};
            end
            
            `EXE_BEQ: begin
                w_reg_o <= `WriteEnable;
                aluop_o <= `EXE_BEQ_OP;
                alusel_o <= `EXE_RES_JUMP_BRANCH;
                reg1_read_o <= `ReadEnable;                    
                reg2_read_o <= `ReadEnable;                                                       
                instvalid <= `InstValid;
            end
            
            `EXE_BGTZ: begin
                w_reg_o <= `WriteDisable;
                aluop_o <= `EXE_BGTZ_OP;
                alusel_o <= `EXE_RES_JUMP_BRANCH;
                reg1_read_o <= `ReadEnable;                    
                reg2_read_o <= `ReadDisable;                                                    
                instvalid <= `InstValid;
            end
            
            `EXE_BLEZ: begin
                w_reg_o <= `WriteDisable;
                aluop_o <= `EXE_BLEZ_OP;
                alusel_o <= `EXE_RES_JUMP_BRANCH;
                reg1_read_o <= `ReadEnable;                    
                reg2_read_o <= `ReadDisable;                                                    
                instvalid <= `InstValid;
            end
                  
            `EXE_BNE: begin
                w_reg_o <= `WriteDisable;
                aluop_o <= `EXE_BNE_OP;
                alusel_o <= `EXE_RES_JUMP_BRANCH;
                reg1_read_o <= `ReadEnable;                    
                reg2_read_o <= `ReadEnable;                                                   
                instvalid <= `InstValid;
            end
            
            `EXE_ORI:begin
                w_reg_o <= `WriteEnable;
                aluop_o <= `EXE_OR_OP;
                alusel_o <= `EXE_RES_LOGIC;
                reg1_read_o <= `ReadEnable;                    
                reg2_read_o <= `ReadDisable;
                w_dest_o <= reg_Rt;
                imm <= {16'h0000,imm16};
                instvalid <= `InstValid;
            end       
                
            `EXE_ANDI:begin
                w_reg_o <= `WriteEnable;
                aluop_o <= `EXE_AND_OP;
                alusel_o <= `EXE_RES_LOGIC;
                reg1_read_o <= `ReadEnable;                    
                reg2_read_o <= `ReadDisable; 
                w_dest_o <= reg_Rt;
                imm <= {16'h0000,imm16};
                instvalid <= `InstValid;
            end

            `EXE_XORI:begin
                w_reg_o <= `WriteEnable;
                aluop_o <= `EXE_XOR_OP;
                alusel_o <= `EXE_RES_LOGIC;
                reg1_read_o <= `ReadEnable;                    
                reg2_read_o <= `ReadDisable; 
                w_dest_o <= reg_Rt;
                imm <= {16'h0000,imm16};
                instvalid <= `InstValid;
            end
               
            `EXE_LUI :begin
                w_reg_o <= `WriteEnable;
                aluop_o <= `EXE_OR_OP;
                alusel_o <= `EXE_RES_LOGIC;
                reg1_read_o <= `ReadEnable;                    
                reg2_read_o <= `ReadDisable;
                w_dest_o <= reg_Rt;
                imm <= {imm16,16'h0000};
                instvalid <= `InstValid;
            end   
            
            `EXE_ADDI :begin
                w_reg_o <= `WriteEnable;
                aluop_o <= `EXE_ADD_OP;
                alusel_o <= `EXE_RES_ARITHMETRIC;
                reg1_read_o <= `ReadEnable;
                reg2_read_o <= `ReadDisable;
                w_dest_o <= reg_Rt;
                imm <= {{16{imm16[15]}},imm16};
                instvalid <= `InstValid;
            end
            
            `EXE_ADDIU :begin
                w_reg_o <= `WriteEnable;
                aluop_o <= `EXE_ADDU_OP;
                alusel_o <= `EXE_RES_ARITHMETRIC;
                reg1_read_o <= `ReadEnable;                    
                reg2_read_o <= `ReadDisable;
                w_dest_o <= reg_Rt;
                imm <= {{16{imm16[15]}},imm16};
                instvalid <= `InstValid;
            end  
            
            `EXE_SLTI :begin
                w_reg_o <= `WriteEnable;
                aluop_o <= `EXE_SLT_OP;
                alusel_o <= `EXE_RES_ARITHMETRIC;
                reg1_read_o <= `ReadEnable;                    
                reg2_read_o <= `ReadDisable;
                w_dest_o <= reg_Rt;
                imm <= {{16{imm16[15]}},imm16};
                instvalid <= `InstValid;
            end 
            
            `EXE_SLTIU :begin
                w_reg_o <= `WriteEnable;
                aluop_o <= `EXE_SLTU_OP;
                alusel_o <= `EXE_RES_ARITHMETRIC;
                reg1_read_o <= `ReadEnable;                    
                reg2_read_o <= `ReadDisable;
                w_dest_o <= reg_Rt;
                imm <= {{16{imm16[15]}},imm16};
                instvalid <= `InstValid;
            end  
                            
            default:begin
            end
        endcase
        //end case structure of "opcode"
        
        if((opcode==6'b000000)&&(reg_Rs==5'b00000))begin
            case(func)
                `EXE_SLL:begin
                    w_reg_o <= `WriteEnable;
                    aluop_o <= `EXE_SLL_OP;
                    alusel_o <= `EXE_RES_SHIFT;
                    reg1_read_o <= `ReadDisable;            
                    reg2_read_o <= `ReadEnable;
                    imm[4:0] <= shamt;
                    w_dest_o <= reg_Rd;
                    instvalid <= `InstValid;
                end
                
                `EXE_SRL:begin
                    w_reg_o <= `WriteEnable;
                    aluop_o <= `EXE_SRL_OP;
                    alusel_o <= `EXE_RES_SHIFT;
                    reg1_read_o <= `ReadDisable;                    
                    reg2_read_o <= `ReadEnable;
                    imm[4:0] <= shamt;
                    w_dest_o <= reg_Rd;
                    instvalid <= `InstValid;
                end
                
                `EXE_SRA:begin
                    w_reg_o <= `WriteEnable;
                    aluop_o <= `EXE_SRA_OP;
                    alusel_o <= `EXE_RES_SHIFT;
                    reg1_read_o <= `ReadDisable;                    
                    reg2_read_o <= `ReadEnable;
                    imm[4:0] <= shamt;
                    w_dest_o <= reg_Rd;
                    instvalid <= `InstValid;
                end                    
            
                default:begin
                end
            endcase
            //end case structure of "func"
        end
       //end "if((opcode==6'b000000)&&(reg_Rs==5'b00000))"
       
    end       

    reg stall_request_load_use_1;
    reg stall_request_load_use_2;
    wire pre_inst_is_load;
    
    assign pre_inst_is_load = (ex_aluop_i == `EXE_LW)?`TRUE:`FALSE;
    assign stall_request = stall_request_load_use_1 | stall_request_load_use_2;
    
    always @ (*) begin
        stall_request_load_use_1 <= `NoStall;
        stall_request_load_use_2 <= `NoStall;
        
        //Load-use Hazard Stall
        if ((pre_inst_is_load == `TRUE) && 
            (ex_wd_i == reg1_addr_o)&&(reg1_read_o == `TRUE)) begin
                stall_request_load_use_1 <= `Stall;
            end
            
        if ((pre_inst_is_load == `TRUE) &&                 
            (ex_wd_i == reg2_addr_o)&&(reg2_read_o == `TRUE)) begin
                stall_request_load_use_2 <= `Stall;
            end
    end
    
endmodule
