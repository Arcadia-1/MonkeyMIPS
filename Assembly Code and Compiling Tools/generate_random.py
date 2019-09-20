import random

target = "random_for_mysort.txt"

with open(target,'w') as t:
    num = 100
    for i in range(0,num):
        line1 = "addi $t0,$zero,0x"+str(random.randint(1,3000))+"\n"
        line2 = "sw $t0,"+str(4*i)+"($t1)\n"

        t.write(line1)
        t.write(line2)
    line1 = "addi $t0,$zero,0"+"\n"
    line2 = "sw $t0,"+str(4*num)+"($t1)\n"

    t.write(line1)
    t.write(line2)

print("***Generation has ENDed***")
