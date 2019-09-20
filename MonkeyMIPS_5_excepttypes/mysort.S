    .org 0x0        #指示地址从0x0开始    
    #.set noat       #允许自由使用寄存器$1
    .set noreorder  #不要优化
    # .set nomacro
    .global _start  #定义一个全局符号

_start:

    ori $t0,$0,0x60
    jr $t0
    nop

    
Interrupt:
    .org 0x20
    addi $v0,$v0,0x0001     #计数：$2=$2+1，放在v0寄存器
    mfc0 $v1,$11            #读取Compare寄存器的值，放在v1
    addi $v1,$v1,0x40       #Compare寄存器中的设定值增加40，即40周期后再中断
    mtc0 $v1,$11            #写入中断寄存器
    jr $26
    nop


Exception:
    .org 0x40
    addi $s6,$s6,0x0001
    mfc0 $s7,$14            #获取EPC寄存器的内容
    addi $s7,$s7,0x0004     #异常地址+4
    mtc0 $s7,$14            #写入EPC寄存器，即协处理器CP0中的14号寄存器
    jr $26
    nop

Main: 
    .org 0x60
    
ori $v0,$0,0x0              #使用v0寄存器计数，累计中断次数
ori $v1,$0,0x100
mtc0 $v1,$11                #设置Compare寄存器的初始值，取其为0x100

addi $t1,$zero,0x000000000  #数组开始的地址

addi $t0,$zero,0x1734
sw $t0,0($t1)
addi $t0,$zero,0x145
sw $t0,4($t1)
addi $t0,$zero,0x56
sw $t0,8($t1)
addi $t0,$zero,0x1109
sw $t0,12($t1)
addi $t0,$zero,0x1746
sw $t0,16($t1)
addi $t0,$zero,0x2459
sw $t0,20($t1)
addi $t0,$zero,0x402
sw $t0,24($t1)
addi $t0,$zero,0x2293
sw $t0,28($t1)
addi $t0,$zero,0x33
sw $t0,32($t1)
addi $t0,$zero,0x475
sw $t0,36($t1)
addi $t0,$zero,0x2843
sw $t0,40($t1)
addi $t0,$zero,0x225
sw $t0,44($t1)
addi $t0,$zero,0x685
sw $t0,48($t1)
addi $t0,$zero,0x1791
sw $t0,52($t1)
addi $t0,$zero,0x2975
sw $t0,56($t1)
addi $t0,$zero,0x4
sw $t0,60($t1)
addi $t0,$zero,0x832
sw $t0,64($t1)
addi $t0,$zero,0x792
sw $t0,68($t1)
addi $t0,$zero,0x2981
sw $t0,72($t1)
addi $t0,$zero,0x1674
sw $t0,76($t1)
addi $t0,$zero,0x2615
sw $t0,80($t1)
addi $t0,$zero,0x2778
sw $t0,84($t1)
addi $t0,$zero,0x25
sw $t0,88($t1)
addi $t0,$zero,0x302
sw $t0,92($t1)
addi $t0,$zero,0x1882
sw $t0,96($t1)
addi $t0,$zero,0x1864
sw $t0,100($t1)
addi $t0,$zero,0x570
sw $t0,104($t1)
addi $t0,$zero,0x1385
sw $t0,108($t1)
addi $t0,$zero,0x2204
sw $t0,112($t1)
addi $t0,$zero,0x2060
sw $t0,116($t1)
addi $t0,$zero,0x592
sw $t0,120($t1)
addi $t0,$zero,0x2431
sw $t0,124($t1)
addi $t0,$zero,0x2532
sw $t0,128($t1)
addi $t0,$zero,0x2149
sw $t0,132($t1)
addi $t0,$zero,0x2409
sw $t0,136($t1)
addi $t0,$zero,0x307
sw $t0,140($t1)
addi $t0,$zero,0x1165
sw $t0,144($t1)
addi $t0,$zero,0x1981
sw $t0,148($t1)
addi $t0,$zero,0x2218
sw $t0,152($t1)
addi $t0,$zero,0x2670
sw $t0,156($t1)
addi $t0,$zero,0x1159
sw $t0,160($t1)
addi $t0,$zero,0x2525
sw $t0,164($t1)
addi $t0,$zero,0x1848
sw $t0,168($t1)
addi $t0,$zero,0x2718
sw $t0,172($t1)
addi $t0,$zero,0x2365
sw $t0,176($t1)
addi $t0,$zero,0x2712
sw $t0,180($t1)
addi $t0,$zero,0x1608
sw $t0,184($t1)
addi $t0,$zero,0x1318
sw $t0,188($t1)
addi $t0,$zero,0x1776
sw $t0,192($t1)
addi $t0,$zero,0x2392
sw $t0,196($t1)
addi $t0,$zero,0x564
sw $t0,200($t1)
addi $t0,$zero,0x1621
sw $t0,204($t1)
addi $t0,$zero,0x642
sw $t0,208($t1)
addi $t0,$zero,0x2249
sw $t0,212($t1)
addi $t0,$zero,0x2739
sw $t0,216($t1)
addi $t0,$zero,0x1119
sw $t0,220($t1)
addi $t0,$zero,0x1600
sw $t0,224($t1)
addi $t0,$zero,0x555
sw $t0,228($t1)
addi $t0,$zero,0x1807
sw $t0,232($t1)
addi $t0,$zero,0x2188
sw $t0,236($t1)
addi $t0,$zero,0x1452
sw $t0,240($t1)
addi $t0,$zero,0x750
sw $t0,244($t1)
addi $t0,$zero,0x2541
sw $t0,248($t1)
addi $t0,$zero,0x2948
sw $t0,252($t1)
addi $t0,$zero,0x2076
sw $t0,256($t1)
addi $t0,$zero,0x2771
sw $t0,260($t1)
addi $t0,$zero,0x1621
sw $t0,264($t1)
addi $t0,$zero,0x2757
sw $t0,268($t1)
addi $t0,$zero,0x2691
sw $t0,272($t1)
addi $t0,$zero,0x637
sw $t0,276($t1)
addi $t0,$zero,0x2247
sw $t0,280($t1)
addi $t0,$zero,0x1917
sw $t0,284($t1)
addi $t0,$zero,0x177
sw $t0,288($t1)
addi $t0,$zero,0x307
sw $t0,292($t1)
addi $t0,$zero,0x1986
sw $t0,296($t1)
addi $t0,$zero,0x1823
sw $t0,300($t1)
addi $t0,$zero,0x809
sw $t0,304($t1)
addi $t0,$zero,0x34
sw $t0,308($t1)
addi $t0,$zero,0x475
sw $t0,312($t1)
addi $t0,$zero,0x2920
sw $t0,316($t1)
addi $t0,$zero,0x2643
sw $t0,320($t1)
addi $t0,$zero,0x1599
sw $t0,324($t1)
addi $t0,$zero,0x1387
sw $t0,328($t1)
addi $t0,$zero,0x2839
sw $t0,332($t1)
addi $t0,$zero,0x1563
sw $t0,336($t1)
addi $t0,$zero,0x707
sw $t0,340($t1)
addi $t0,$zero,0x201
sw $t0,344($t1)
addi $t0,$zero,0x2192
sw $t0,348($t1)
addi $t0,$zero,0x447
sw $t0,352($t1)
addi $t0,$zero,0x2082
sw $t0,356($t1)
addi $t0,$zero,0x1194
sw $t0,360($t1)
addi $t0,$zero,0x2513
sw $t0,364($t1)
addi $t0,$zero,0x2719
sw $t0,368($t1)
addi $t0,$zero,0x352
sw $t0,372($t1)
addi $t0,$zero,0x2547
sw $t0,376($t1)
addi $t0,$zero,0x673
sw $t0,380($t1)
addi $t0,$zero,0x2076
sw $t0,384($t1)
addi $t0,$zero,0x2679
sw $t0,388($t1)
addi $t0,$zero,0x665
sw $t0,392($t1)
addi $t0,$zero,0x1672
sw $t0,396($t1)
addi $t0,$zero,0
sw $t0,400($t1)


addi $t0,$zero,0
sw $t0,404($t1)
	
LOOP:	
	addi $s0,$t1,0
	addi $s3,$zero,0	#set a flag
loop:	
	lw $s2,4($s0)       #8e120004
    lw $s1,0($s0)       #8e110000
	beqz $s2,exit	    #12400007   #end of the array, go to the exit
    sub $s4,$s1,$s2     #0232a022
	blez $s4,NOswap     #1a800003
swap:
	addi $s3,$s3,1      #22730001
	sw $s2,0($s0)       #ae120000
	sw $s1,4($s0)       #ae110004
NOswap:	
	addi $s0,$s0,4	    #22100004	
	j loop              #080000d2
exit:
	beqz $s3,EXIT       #12600001
	j LOOP              #080000d0
    nop
EXIT:

_loop:
    j _loop             #080000de
    nop

