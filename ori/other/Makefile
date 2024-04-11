ifndef CROSS_COMPILE
CROSS_COMPILE = mips-sde-elf-
endif
CC = $(CROSS_COMPILE)as # GNU Assembler
LD = $(CROSS_COMPILE)ld # Link
OBJCOPY = $(CROSS_COMPILE)objcopy
OBJDUMP = $(CROSS_COMPILE)objdump

OBJECTS = inst_rom.o

export	CROSS_COMPILE

# Rules of Compilation

all: inst_rom.om inst_rom.bin inst_rom.asm inst_rom.data

# "assembler": mips-sde-elf-as -mips32 inst_rom.S -o inst_rom.o 
# "link": mips-sde-elf-ld -T ram.ld inst_rom.o -o inst_rom.om
# "get bin": mips-sde-elf-objcopy -o binary inst_rom.om inst_rom.bin
# "format invert": ./Bin2Mem.exe -f inst_rom.bin -o inst_rom.data

# "inverse assembler": mips-sde-elf-objdump -D inst_rom.om > inst_rom.asm

%.o: %.S
	$(CC) -mips32 $< -o $@
inst_rom.om: ram.ld $(OBJECTS)
	$(LD) -T ram.ld $(OBJECTS) -o $@
inst_rom.bin: inst_rom.om
	$(OBJCOPY) -O binary $<  $@
inst_rom.asm: inst_rom.om
	$(OBJDUMP) -D $< > $@
inst_rom.data: inst_rom.bin
	./Bin2Mem.exe -f $< -o $@
clean:
	rm -f *.o *.om *.bin *.data *.mif *.asm

