# Entry point of Orange'S
# It must have the same value with 'KernelEntryPointPhyAddr' in load.inc!
ENTRYPOINT	= 0x100000



# Offset of entry point in kernel file
# It depends on ENTRYPOINT
ENTRYOFFSET	=  0x400
# Programs, flags, etc.
ASM		= nasm
DASM	= ndisasm
CC		= gcc
LD		= ld


ASMBFLAGS	= -I boot/include/
ASMKFLAGS	= -I include/ -f elf
CFLAGS		= -std=gnu99  -I include/  -c -fno-builtin  -static -L libc/ -lmyc
LDFLAGS		=  -s -Ttext $(ENTRYPOINT) 
DASMFLAGS	= -u -o $(ENTRYPOINT) -e $(ENTRYOFFSET)  

# This Program
ORANGESBOOT	= boot/boot.bin boot/loader.bin
ORANGESKERNEL	= kernel.bin
OBJS		= kernel/kernel.o kernel/start.o hal/hal.o kernel/mm.o hal/hallib.o 

DASMOUTPUT	= kernel.bin.asm


# All Phony Targets
.PHONY : everything final image clean realclean disasm all buildimg

# Default starting position
everything : $(ORANGESBOOT) $(ORANGESKERNEL)

all : realclean everything

final : all clean

image : final buildimg

clean :
	rm -f $(OBJS)

realclean:
	rm -f $(OBJS) $(ORANGESBOOT) $(ORANGESKERNEL)

disasm :
	$(DASM) $(DASMFLAGS) $(ORANGESKERNEL) > $(DASMOUTPUT)

# We assume that "a.img" exists in current folder
buildimg :
	dd if=boot/boot.bin of=a.img bs=512 count=1 conv=notrunc
	sudo mount -o loop  a.img /mnt/floppy/
	sudo cp -fv boot/loader.bin /mnt/floppy/
	sudo cp -fv kernel.bin /mnt/floppy
	sudo umount /mnt/floppy/

boot/boot.bin : boot/boot.asm boot/include/load.inc boot/include/fat12hdr.inc
	$(ASM) $(ASMBFLAGS) -o $@ $<

boot/loader.bin : boot/loader.asm boot/include/load.inc \
			boot/include/fat12hdr.inc boot/include/pm.inc
	$(ASM) $(ASMBFLAGS) -o $@ $<

hal/hallib.o: hal/hallib.asm
	$(ASM) $(ASMKFLAGS) -o $@ $<

$(ORANGESKERNEL) : $(OBJS)
	$(LD) $(LDFLAGS) -o $(ORANGESKERNEL) $(OBJS) -static -L libc/ -lmyc  

kernel/kernel.o : kernel/kernel.asm include/global.h
	$(ASM) $(ASMKFLAGS) -o $@ $<

kernel/start.o: kernel/start.c include/global.h
	$(CC) $(CFLAGS) -o $@ $<
	
kernel/mm.o: kernel/mm.c include/global.h
	$(CC) $(CFLAGS) -o $@ $<
	
hal/hal.o: hal/hal.c include/hal.h  include/global.h
	$(CC) $(CFLAGS) -o $@ $<
