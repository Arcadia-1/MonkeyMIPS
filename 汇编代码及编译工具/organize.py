import sys
import binascii

filename = sys.argv[1]
target = sys.argv[2]

print("***target = ",target,"***")
with open(filename,"rb") as f:
    a = f.read()
    hexstr = binascii.b2a_hex(a)

utf = hexstr.decode('utf-8','replace')
#print(hexstr)
number = len(utf)/8 - 12
#print("number = ",number)

data = []
for i in [x*8 for x in range(0, int(number))]:
    now = utf[i:i+8]
    data.append(now)

# with open(target,'w') as t:
#     for i in range(len(data)):
#         t.write(data[i])

with open(target,'w') as t:
    for i in range(len(data)):
        t.write("inst_mem[")
        t.write(str(i))
        t.write("] <= 32'h")
        t.write(data[i])
        t.write(";\n")

print("***Translation of ",len(data)," words has ENDed***")