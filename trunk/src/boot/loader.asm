org 0x100


jmp LABEL_START
%include "pm.inc"
%include "fat12hdr.inc"
%include "load.inc"
; GDT ------------------------------------------------------------------------------------------------------------------------------------------------------------
;                                          段基址            段界限     , 属性
LABEL_GDT:				Descriptor                 0,                    0, 0						; 空描述符
LABEL_DESC_CODE32:		Descriptor   			   0,              0fffffh, DA_CR  | DA_32 | DA_LIMIT_4K			; 0 ~ 4G
LABEL_DESC_FLAT_RW:		Descriptor  	           0,              0fffffh, DA_DRW | DA_32 | DA_LIMIT_4K			; 0 ~ 4G
LABEL_DESC_VIDEO:		Descriptor		 	 0B8000h,               0ffffh, DA_DRW                         | DA_DPL3	; 显存首地址
; GDT ------------------------------------------------------------------------------------------------------------------------------------------------------------

GdtLen		equ	$ - LABEL_GDT
GdtPtr		dw	GdtLen - 1				; 段界限
			dd	BaseOfLoaderPhyAddr + LABEL_GDT		; 基地址

; GDT 选择子 ----------------------------------------------------------------------------------
SelectorCode32		equ	LABEL_DESC_CODE32	- LABEL_GDT
SelectorFlatRW		equ	LABEL_DESC_FLAT_RW	- LABEL_GDT
SelectorVideo		equ	LABEL_DESC_VIDEO	- LABEL_GDT + SA_RPL3
; GDT 选择子 ----------------------------------------------------------------------------------
SPValueInRealMode dw 0 
BaseOfStack	equ	0x100
[section .s16]
[bits 16]
LABEL_START:			; <--- 从这里开始 *************
	mov	ax, cs
	mov	ds, ax
	mov	es, ax
	mov	ss, ax
	mov	sp, BaseOfStack
	;进入保护模式之前，先从磁盘里面读取一些数据
	call ClearScreen
	mov dh,0
	call Disstr	
	
	;寻找内核文件
	mov ax,KernelFile
	mov bx,ax
	mov ax,cs
	mov es,ax
	mov ax,BaseofRoot
	mov gs,ax
	mov di,OffsetOfRoot

	mov dx,di
	xor eax,eax
	mov cx,11
Search_Loader:
		call CompareString
		cmp al,1
		je FOUND_lOADER_FILE
		add dx,DES_FILESIZE
		mov di,dx
		cmp dx,OffsetOfRoot+ROORDIR_SIZE
		jnb NOFOUND_lOADER_FILE
		JMP Search_Loader
NOFOUND_lOADER_FILE:
	mov dh,1
	call Disstr
	jmp $
FOUND_lOADER_FILE:
	push dx
	mov dh,2
	call Disstr
	
	pop dx
	;读取文件
	mov di,dx	;将文件项偏移量保存，并计读取第一簇
	add di,0x1a
	mov ax,BaseofRoot
	mov es,ax
	mov ax,[es:di]
	mov dx,BaseofexratFat
	mov gs,dx	;解压后的fat基址
	mov dx,BaseOfKernelFile
	mov es,dx
	mov bx,OffsetOfKernelFile
	mov di,OffsetOfexratFat ;解压后的fat表偏移量
BeginLoader:
	push bx
	push ax
	sub ax,2
	add ax,33
	mov cl,1
	call ReadSector
	pop ax
	mov dl,2
	mul dl
	mov di,OffsetOfexratFat
	add di,ax
	xor eax,eax
	mov cx,[gs:di]
	cmp cx,0xFF8
	jnl LOADEROK
	mov ax,cx
	pop bx
	add bx,512
	jmp BeginLoader	
LOADEROK:	
	mov dh,3
	call Disstr
	
	;mov ax,0x0013
	;int		0x10	
	;调用bios中断，进入vga模式800*600 256色
	
	lgdt [GdtPtr]
	cli 
	
	in al,0x092
	or al,00000010b
	out 0x92,al
	
	mov eax,cr0
	or eax,0x01
	mov cr0,eax
	jmp dword SelectorCode32:(BaseOfLoaderPhyAddr+LABEL_SEG_CODE32)

ClearScreen:
		; 清屏
	mov	ax, 0600h		; AH = 6,  AL = 0h
	mov	bx, 0700h		; 黑底白字(BL = 07h)
	mov	cx, 0			; 左上角: (0, 0)
	mov	dx, 0184fh		; 右下角: (80, 50)
	int	10h			; int 10h
	ret 
	
		;显示字符串，dh位字符串顺序
Disstr:
	mov ax,cs
	mov es,ax
	mov ax,MessageLen
	mul dh
	add ax,BootMessage
	mov bp,ax		;es:bp =串地址
	mov cx,MessageLen		;串的长度
	mov ax,0x1301	;ah=13,al=01
	mov bx,0x0c		;页号为0，黑底红字（bl=0x0c,高亮）
	mov dl,0	
	int 0x10		;中断号
	ret
	
ReadSector: ;从第ax个Sector开始读取，将cl个Sector读入es:bx中
	push bp
	sub esp,2
	mov [esp+2],cl
	push bx
	mov bl,[BPB_SecPerTrk]
	div bl
	inc ah
	mov cl,ah	;起始扇区号
	
	mov dh,al
	shr al,1
	mov ch,al 	;柱面号
	
	and dh,1 	;磁头号
	
	pop bx	
	
	mov dl,[BS_DrvNum]
.GoOnReading:
	mov al,[esp+2]
	mov ah,2
	int 0x13
	jc .GoOnReading
	
	add esp,2
	pop bp
	ret	
	
CompareString:
;es:bx 目标String
;gs di 待比较的String
;cx 目标字符串长度
	push dx
	push bx
	push di
	xor eax,eax
.loop:
	mov ah,[es:bx]
	mov dh,[gs:di]
	cmp ah,dh
	jne NotFound
	inc bx
	inc di
	loop .loop
	jmp Found_File
NotFound:
		mov al,0
		jmp BACK
Found_File:
	mov al,1
BACK:
	pop di
	pop bx
	pop dx
	ret	
[section .data1]
[bits 32]
	;显示字符串，dh位字符串顺序
BootMessage:
MessageLen equ 14		;显示的消息长度
			db 'Search  Kernel'
			db 'NO 	    kernel'
			db 'Loading Kernel'			
			db 'jmp to  32code'
KernelFile: db 'KERNEL  BIN' ;内核文件，11字节
[section .s32]
[bits 32]
LABEL_SEG_CODE32:
	mov ax,SelectorVideo
	mov gs,ax
	mov	ax, SelectorFlatRW
	mov	ds, ax
	mov	es, ax
	mov	fs, ax
	mov	ss, ax
	mov esp,TopOfStack
;显示一个字符，证明到这了  
    mov ah,0x0c
	mov al,'P'
	mov [gs:((80 * 0 + 39) * 2)],ax

	call InitKernel
	jmp	SelectorCode32:KernelEntryPointPhyAddr	; 正式进入内核 *
	
MemCpy:
	push	ebp
	mov	ebp, esp

	push	esi
	push	edi
	push	ecx

	mov	edi, [ebp + 8]	;  
	mov	esi, [ebp + 12]	; Source
	mov	ecx, [ebp + 16]	; Counter
.1:
	cmp	ecx, 0		; 判断计数器
	jz	.2		; 计数器为零时跳出

	mov	al, [ds:esi]		; ┓
	inc	esi					; ┃
							; ┣ 逐字节移动
	mov	byte [es:edi], al	; ┃
	inc	edi					; ┛

	dec	ecx		; 计数器减一
	jmp	.1		; 循环
.2:
	mov	eax, [ebp + 8]	; 返回值

	pop	ecx
	pop	edi
	pop	esi
	mov	esp, ebp
	pop	ebp

	ret			; 函数结束，返回
; MemCpy 结束-------------------------------------------------------------

	
; InitKernel ---------------------------------------------------------------------------------
; 将 KERNEL.BIN 的内容经过整理对齐后放到新的位置
; --------------------------------------------------------------------------------------------
InitKernel:	; 遍历每一个 Program Header，根据 Program Header 中的信息来确定把什么放进内存，放到什么位置，以及放多少。
	xor	esi, esi
	mov	cx, word [BaseOfKernelFilePhyAddr + 2Ch]; ┓ ecx <- pELFHdr->e_phnum
	movzx	ecx, cx				   				; ┛
	mov	esi, [BaseOfKernelFilePhyAddr + 1Ch]	; esi <- pELFHdr->e_phoff
	add	esi, BaseOfKernelFilePhyAddr		; esi <- OffsetOfKernel + pELFHdr->e_phoff
.Begin:
	mov	eax, [esi + 0]
	cmp	eax, 0				; PT_NULL
	jz	.NoAction
	push	dword [esi + 010h]		; size	┓
	mov	eax, [esi + 04h]				;	┃
	add	eax, BaseOfKernelFilePhyAddr	;	┣ ::memcpy(	(void*)(pPHdr->p_vaddr),
	push	eax						; src	┃		uchCode + pPHdr->p_offset,
	push	dword [esi + 08h]		; dst	┃		pPHdr->p_filesz;
	call	MemCpy						;	┃
	add	esp, 12							;	┛
.NoAction:
	add	esi, 020h			; esi += pELFHdr->e_phentsize
	dec	ecx
	jnz	.Begin

	ret
; InitKernel ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


StackSpace:	times	1000h	db	0
TopOfStack	equ	BaseOfLoaderPhyAddr + $	; 栈顶
