	FATLEN equ 4608
	BaseofRoot equ 0x9D40	;根目录区段地址
	OffsetOfRoot equ 0x0	;根目录偏移地址
	BaseofFat equ 0X9AC0
	OffsetOfFat equ 0x00
	BaseofexratFat equ 0x9840
	OffsetOfexratFat equ 0x00
	BaseofLoader equ 0x8840
	OffestofLoader equ 0x100
	FILELEN equ 11		;文件名长度
	DES_FILESIZE equ 32 ;文件条目长度
	ROORDIR_SIZE equ 7168
	ClusterTotal equ 2897
	DataBegin equ 1
	BaseOfData equ 0x6000
	DataLen equ 0x1fe00
phyaddrofroot equ BaseofRoot*0x10
phyaddrOfFat equ BaseofFat*0x10
phyaddrOfexratFat equ BaseofexratFat

BaseOfLoaderPhyAddr	equ	BaseofLoader * 10h	; LOADER.BIN 被加载到的位置 ---- 物理地址 (= BaseOfLoader * 10h)
BaseOfKernelFile	equ	 06000h	; KERNEL.BIN 被加载到的位置 ----  段地址
OffsetOfKernelFile	equ	     0h	; KERNEL.BIN 被加载到的位置 ---- 偏移地址

BaseOfKernelFilePhyAddr	equ	BaseOfKernelFile * 10h
KernelEntryPointPhyAddr	equ	0x100000	; 注意：1、必须与 MAKEFILE 中参数 -Ttext 的值相等!!
					;       2、这是个地址而非仅仅是个偏移，如果 -Ttext 的值为 0x400400，则它的值也应该是 0x400400。
