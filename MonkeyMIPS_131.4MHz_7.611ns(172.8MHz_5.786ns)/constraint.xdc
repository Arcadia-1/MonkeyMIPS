#100MHz ʱ��, W5
set_property -dict {PACKAGE_PIN W5 IOSTANDARD LVCMOS33} [get_ports clk]
#create_clock -period 20.000 -name CLK -waveform {0.000 10.000} -add [get_ports clk]
create_clock -period 10.000 -name CLK -waveform {0.000 5.000} -add [get_ports clk]

#reset
set_property -dict {PACKAGE_PIN W16 IOSTANDARD LVCMOS33} [get_ports rst]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets rst_IBUF]

##BTND��T17
set_property -dict {PACKAGE_PIN T17 IOSTANDARD LVCMOS33} [get_ports BTND]

#��ʾ����ѡ��V16 Ϊ SW1��V17 Ϊ SW0
set_property -dict {PACKAGE_PIN V16 IOSTANDARD LVCMOS33} [get_ports SW1]
set_property -dict {PACKAGE_PIN V17 IOSTANDARD LVCMOS33} [get_ports SW0]

#LED �ƣ��� PC �Ĵ���ֵ����� 8bit����ʾ�� LED7~LED0 ��


#set_property -dict {PACKAGE_PIN L1 IOSTANDARD LVCMOS33} [get_ports {LED[15]}]
#set_property -dict {PACKAGE_PIN P1 IOSTANDARD LVCMOS33} [get_ports {LED[14]}]
#set_property -dict {PACKAGE_PIN N3 IOSTANDARD LVCMOS33} [get_ports {LED[13]}]
#set_property -dict {PACKAGE_PIN P3 IOSTANDARD LVCMOS33} [get_ports {LED[12]}]
#set_property -dict {PACKAGE_PIN U3 IOSTANDARD LVCMOS33} [get_ports {LED[11]}]
#set_property -dict {PACKAGE_PIN W3 IOSTANDARD LVCMOS33} [get_ports {LED[10]}]
#set_property -dict {PACKAGE_PIN V3 IOSTANDARD LVCMOS33} [get_ports {LED[9]}]
#set_property -dict {PACKAGE_PIN V13 IOSTANDARD LVCMOS33} [get_ports {LED[8]}]



set_property -dict {PACKAGE_PIN V14 IOSTANDARD LVCMOS33} [get_ports {LED[7]}]
set_property -dict {PACKAGE_PIN U14 IOSTANDARD LVCMOS33} [get_ports {LED[6]}]
set_property -dict {PACKAGE_PIN U15 IOSTANDARD LVCMOS33} [get_ports {LED[5]}]
set_property -dict {PACKAGE_PIN W18 IOSTANDARD LVCMOS33} [get_ports {LED[4]}]
set_property -dict {PACKAGE_PIN V19 IOSTANDARD LVCMOS33} [get_ports {LED[3]}]
set_property -dict {PACKAGE_PIN U19 IOSTANDARD LVCMOS33} [get_ports {LED[2]}]
set_property -dict {PACKAGE_PIN E19 IOSTANDARD LVCMOS33} [get_ports {LED[1]}]
set_property -dict {PACKAGE_PIN U16 IOSTANDARD LVCMOS33} [get_ports {LED[0]}]

#��$a0��$v0��$sp ��$ra ����� 16bit���� 16 ���Ƶ���ʽ��ʾ�� 7 ���������
#�����7�����룬�͵�ƽ������˳��Ϊ{CA,CB,CC,CD,CE,CF,CG,DP}, ��Ӧԭ��ͼ�е�ABCDEFG
set_property -dict {PACKAGE_PIN U7 IOSTANDARD LVCMOS33} [get_ports {cathodes[0]}]
set_property -dict {PACKAGE_PIN V5 IOSTANDARD LVCMOS33} [get_ports {cathodes[1]}]
set_property -dict {PACKAGE_PIN U5 IOSTANDARD LVCMOS33} [get_ports {cathodes[2]}]
set_property -dict {PACKAGE_PIN V8 IOSTANDARD LVCMOS33} [get_ports {cathodes[3]}]
set_property -dict {PACKAGE_PIN U8 IOSTANDARD LVCMOS33} [get_ports {cathodes[4]}]
set_property -dict {PACKAGE_PIN W6 IOSTANDARD LVCMOS33} [get_ports {cathodes[5]}]
set_property -dict {PACKAGE_PIN W7 IOSTANDARD LVCMOS33} [get_ports {cathodes[6]}]

#ɨ�����룬�͵�ƽ������˳��Ϊ {AN3,AN2,AN1,AN0}
set_property -dict {PACKAGE_PIN W4 IOSTANDARD LVCMOS33} [get_ports {AN[3]}]
set_property -dict {PACKAGE_PIN V4 IOSTANDARD LVCMOS33} [get_ports {AN[2]}]
set_property -dict {PACKAGE_PIN U4 IOSTANDARD LVCMOS33} [get_ports {AN[1]}]
set_property -dict {PACKAGE_PIN U2 IOSTANDARD LVCMOS33} [get_ports {AN[0]}]

