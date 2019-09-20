`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/07/08 10:08:46
// Design Name: 
// Module Name: inst_rom
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//      Instruction memory
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module inst_rom(
    input [`InstBus] addr,              //要读取的指令地址
    output reg [`InstBus] inst          //读取到的指令
    );
        
    reg [`InstBus] inst_mem[0:`InstMemNum-1];
    
    //initial $readmemh ("E:\\Testfield\\OpenMIPS\\inst_rom_lw.data",inst_mem);
    initial begin
inst_mem[0] <= 32'h08000019;
inst_mem[1] <= 32'h08000003;
inst_mem[2] <= 32'h08000018;
inst_mem[3] <= 32'h3c094000;
inst_mem[4] <= 32'h35290008;
inst_mem[5] <= 32'had200000;
inst_mem[6] <= 32'h20080003;
inst_mem[7] <= 32'h3c094000;
inst_mem[8] <= 32'h35290008;
inst_mem[9] <= 32'had280000;
inst_mem[10] <= 32'h22d60001;
inst_mem[11] <= 32'h8d8b0000;
inst_mem[12] <= 32'h218c0004;
inst_mem[13] <= 32'h3c094000;
inst_mem[14] <= 32'h35290010;
inst_mem[15] <= 32'had2b0000;
inst_mem[16] <= 32'h15600005;
inst_mem[17] <= 32'h8d4b0000;
inst_mem[18] <= 32'h3c094000;
inst_mem[19] <= 32'h35290010;
inst_mem[20] <= 32'had2b0000;
inst_mem[21] <= 32'h08000015;
inst_mem[22] <= 32'h42000018;
inst_mem[23] <= 32'h00000000;
inst_mem[24] <= 32'h08000018;
inst_mem[25] <= 32'h34160000;
inst_mem[26] <= 32'h340c0000;
inst_mem[27] <= 32'h20090000;
inst_mem[28] <= 32'h20081734;
inst_mem[29] <= 32'had280000;
inst_mem[30] <= 32'h20080145;
inst_mem[31] <= 32'had280004;
inst_mem[32] <= 32'h20080056;
inst_mem[33] <= 32'had280008;
inst_mem[34] <= 32'h20081109;
inst_mem[35] <= 32'had28000c;
inst_mem[36] <= 32'h20081746;
inst_mem[37] <= 32'had280010;
inst_mem[38] <= 32'h20082459;
inst_mem[39] <= 32'had280014;
inst_mem[40] <= 32'h20080402;
inst_mem[41] <= 32'had280018;
inst_mem[42] <= 32'h20082293;
inst_mem[43] <= 32'had28001c;
inst_mem[44] <= 32'h20080033;
inst_mem[45] <= 32'had280020;
inst_mem[46] <= 32'h20080475;
inst_mem[47] <= 32'had280024;
inst_mem[48] <= 32'h20082843;
inst_mem[49] <= 32'had280028;
inst_mem[50] <= 32'h20080225;
inst_mem[51] <= 32'had28002c;
inst_mem[52] <= 32'h20080685;
inst_mem[53] <= 32'had280030;
inst_mem[54] <= 32'h20081791;
inst_mem[55] <= 32'had280034;
inst_mem[56] <= 32'h20082975;
inst_mem[57] <= 32'had280038;
inst_mem[58] <= 32'h20080004;
inst_mem[59] <= 32'had28003c;
inst_mem[60] <= 32'h20080832;
inst_mem[61] <= 32'had280040;
inst_mem[62] <= 32'h20080792;
inst_mem[63] <= 32'had280044;
inst_mem[64] <= 32'h20082981;
inst_mem[65] <= 32'had280048;
inst_mem[66] <= 32'h20081674;
inst_mem[67] <= 32'had28004c;
inst_mem[68] <= 32'h20082615;
inst_mem[69] <= 32'had280050;
inst_mem[70] <= 32'h20082778;
inst_mem[71] <= 32'had280054;
inst_mem[72] <= 32'h20080025;
inst_mem[73] <= 32'had280058;
inst_mem[74] <= 32'h20080302;
inst_mem[75] <= 32'had28005c;
inst_mem[76] <= 32'h20081882;
inst_mem[77] <= 32'had280060;
inst_mem[78] <= 32'h20081864;
inst_mem[79] <= 32'had280064;
inst_mem[80] <= 32'h20080570;
inst_mem[81] <= 32'had280068;
inst_mem[82] <= 32'h20081385;
inst_mem[83] <= 32'had28006c;
inst_mem[84] <= 32'h20082204;
inst_mem[85] <= 32'had280070;
inst_mem[86] <= 32'h20082060;
inst_mem[87] <= 32'had280074;
inst_mem[88] <= 32'h20080592;
inst_mem[89] <= 32'had280078;
inst_mem[90] <= 32'h20082431;
inst_mem[91] <= 32'had28007c;
inst_mem[92] <= 32'h20082532;
inst_mem[93] <= 32'had280080;
inst_mem[94] <= 32'h20082149;
inst_mem[95] <= 32'had280084;
inst_mem[96] <= 32'h20082409;
inst_mem[97] <= 32'had280088;
inst_mem[98] <= 32'h20080307;
inst_mem[99] <= 32'had28008c;
inst_mem[100] <= 32'h20081165;
inst_mem[101] <= 32'had280090;
inst_mem[102] <= 32'h20081981;
inst_mem[103] <= 32'had280094;
inst_mem[104] <= 32'h20082218;
inst_mem[105] <= 32'had280098;
inst_mem[106] <= 32'h20082670;
inst_mem[107] <= 32'had28009c;
inst_mem[108] <= 32'h20081159;
inst_mem[109] <= 32'had2800a0;
inst_mem[110] <= 32'h20082525;
inst_mem[111] <= 32'had2800a4;
inst_mem[112] <= 32'h20081848;
inst_mem[113] <= 32'had2800a8;
inst_mem[114] <= 32'h20082718;
inst_mem[115] <= 32'had2800ac;
inst_mem[116] <= 32'h20082365;
inst_mem[117] <= 32'had2800b0;
inst_mem[118] <= 32'h20082712;
inst_mem[119] <= 32'had2800b4;
inst_mem[120] <= 32'h20081608;
inst_mem[121] <= 32'had2800b8;
inst_mem[122] <= 32'h20081318;
inst_mem[123] <= 32'had2800bc;
inst_mem[124] <= 32'h20081776;
inst_mem[125] <= 32'had2800c0;
inst_mem[126] <= 32'h20082392;
inst_mem[127] <= 32'had2800c4;
inst_mem[128] <= 32'h20080564;
inst_mem[129] <= 32'had2800c8;
inst_mem[130] <= 32'h20081621;
inst_mem[131] <= 32'had2800cc;
inst_mem[132] <= 32'h20080642;
inst_mem[133] <= 32'had2800d0;
inst_mem[134] <= 32'h20082249;
inst_mem[135] <= 32'had2800d4;
inst_mem[136] <= 32'h20082739;
inst_mem[137] <= 32'had2800d8;
inst_mem[138] <= 32'h20081119;
inst_mem[139] <= 32'had2800dc;
inst_mem[140] <= 32'h20081600;
inst_mem[141] <= 32'had2800e0;
inst_mem[142] <= 32'h20080555;
inst_mem[143] <= 32'had2800e4;
inst_mem[144] <= 32'h20081807;
inst_mem[145] <= 32'had2800e8;
inst_mem[146] <= 32'h20082188;
inst_mem[147] <= 32'had2800ec;
inst_mem[148] <= 32'h20081452;
inst_mem[149] <= 32'had2800f0;
inst_mem[150] <= 32'h20080750;
inst_mem[151] <= 32'had2800f4;
inst_mem[152] <= 32'h20082541;
inst_mem[153] <= 32'had2800f8;
inst_mem[154] <= 32'h20082948;
inst_mem[155] <= 32'had2800fc;
inst_mem[156] <= 32'h20082076;
inst_mem[157] <= 32'had280100;
inst_mem[158] <= 32'h20082771;
inst_mem[159] <= 32'had280104;
inst_mem[160] <= 32'h20081621;
inst_mem[161] <= 32'had280108;
inst_mem[162] <= 32'h20082757;
inst_mem[163] <= 32'had28010c;
inst_mem[164] <= 32'h20082691;
inst_mem[165] <= 32'had280110;
inst_mem[166] <= 32'h20080637;
inst_mem[167] <= 32'had280114;
inst_mem[168] <= 32'h20082247;
inst_mem[169] <= 32'had280118;
inst_mem[170] <= 32'h20081917;
inst_mem[171] <= 32'had28011c;
inst_mem[172] <= 32'h20080177;
inst_mem[173] <= 32'had280120;
inst_mem[174] <= 32'h20080307;
inst_mem[175] <= 32'had280124;
inst_mem[176] <= 32'h20081986;
inst_mem[177] <= 32'had280128;
inst_mem[178] <= 32'h20081823;
inst_mem[179] <= 32'had28012c;
inst_mem[180] <= 32'h20080809;
inst_mem[181] <= 32'had280130;
inst_mem[182] <= 32'h20080034;
inst_mem[183] <= 32'had280134;
inst_mem[184] <= 32'h20080475;
inst_mem[185] <= 32'had280138;
inst_mem[186] <= 32'h20082920;
inst_mem[187] <= 32'had28013c;
inst_mem[188] <= 32'h20082643;
inst_mem[189] <= 32'had280140;
inst_mem[190] <= 32'h20081599;
inst_mem[191] <= 32'had280144;
inst_mem[192] <= 32'h20081387;
inst_mem[193] <= 32'had280148;
inst_mem[194] <= 32'h20082839;
inst_mem[195] <= 32'had28014c;
inst_mem[196] <= 32'h20081563;
inst_mem[197] <= 32'had280150;
inst_mem[198] <= 32'h20080707;
inst_mem[199] <= 32'had280154;
inst_mem[200] <= 32'h20080201;
inst_mem[201] <= 32'had280158;
inst_mem[202] <= 32'h20082192;
inst_mem[203] <= 32'had28015c;
inst_mem[204] <= 32'h20080447;
inst_mem[205] <= 32'had280160;
inst_mem[206] <= 32'h20082082;
inst_mem[207] <= 32'had280164;
inst_mem[208] <= 32'h20081194;
inst_mem[209] <= 32'had280168;
inst_mem[210] <= 32'h20082513;
inst_mem[211] <= 32'had28016c;
inst_mem[212] <= 32'h20082719;
inst_mem[213] <= 32'had280170;
inst_mem[214] <= 32'h20080352;
inst_mem[215] <= 32'had280174;
inst_mem[216] <= 32'h20082547;
inst_mem[217] <= 32'had280178;
inst_mem[218] <= 32'h20080673;
inst_mem[219] <= 32'had28017c;
inst_mem[220] <= 32'h20082076;
inst_mem[221] <= 32'had280180;
inst_mem[222] <= 32'h20082679;
inst_mem[223] <= 32'had280184;
inst_mem[224] <= 32'h20080665;
inst_mem[225] <= 32'had280188;
inst_mem[226] <= 32'h20081672;
inst_mem[227] <= 32'had28018c;
inst_mem[228] <= 32'h20080000;
inst_mem[229] <= 32'had280190;
inst_mem[230] <= 32'h20080000;
inst_mem[231] <= 32'had280194;
inst_mem[232] <= 32'h21300000;
inst_mem[233] <= 32'h20130000;

inst_mem[234] <= 32'h8e110000;
inst_mem[235] <= 32'h8e120004;

//inst_mem[234] <= 32'h8e120004;
//inst_mem[235] <= 32'h8e110000;

inst_mem[236] <= 32'h12400007;
inst_mem[237] <= 32'h0232a022;
inst_mem[238] <= 32'h1a800003;
inst_mem[239] <= 32'h22730001;
inst_mem[240] <= 32'hae120000;
inst_mem[241] <= 32'hae110004;
inst_mem[242] <= 32'h22100004;
inst_mem[243] <= 32'h080000ea;
inst_mem[244] <= 32'h12600002;
inst_mem[245] <= 32'h080000e8;
inst_mem[246] <= 32'h00000000;
inst_mem[247] <= 32'h3c094000;
inst_mem[248] <= 32'h35290014;
inst_mem[249] <= 32'h8d2a0000;
inst_mem[250] <= 32'h3c094000;
inst_mem[251] <= 32'h35290008;
inst_mem[252] <= 32'had200000;
inst_mem[253] <= 32'h3c08ffff;
inst_mem[254] <= 32'h35088000;
inst_mem[255] <= 32'h3c094000;
inst_mem[256] <= 32'had280000;
inst_mem[257] <= 32'h3c08ffff;
inst_mem[258] <= 32'h3508ffff;
inst_mem[259] <= 32'h3c094000;
inst_mem[260] <= 32'h35290004;
inst_mem[261] <= 32'had280000;
inst_mem[262] <= 32'h20080003;
inst_mem[263] <= 32'h3c094000;
inst_mem[264] <= 32'h35290008;
inst_mem[265] <= 32'had280000;
inst_mem[266] <= 32'h0800010a;
inst_mem[267] <= 32'h00000000;



    end
    
    always @ (*) begin
        inst <= inst_mem[addr[`InstMemNumLog2+1:2]];
    end    
endmodule
