ifndef CROSS_COMPILE
CROSS_COMPILE = mips-linux-gnu-
endif
CC = $(CROSS_COMPILE)as
LD = $(CROSS_COMPILE)ld
OBJCOPY = $(CROSS_COMPILE)objcopy
OBJDUMP = $(CROSS_COMPILE)objdump


# TARGET = inst_rom_clock
TARGET = mysort20190824
# TARGET = test
# TARGET = test_peripheral

export CROSS_COMPILE

all:$(TARGET).txt

%.o:%.S
	$(CC) -mips32 $< -o $@

$(TARGET).om: ram.ld $(TARGET).o
	$(LD) -T ram.ld $(TARGET).o -o $@

$(TARGET).bin: $(TARGET).om
	$(OBJCOPY) -O binary $< $@

$(TARGET).txt: $(TARGET).bin
	python3 organize.py $(TARGET).bin $(TARGET).txt
	rm -f $(TARGET).o $(TARGET).om $(TARGET).bin

clean:
	rm -f *.o