;%define _boot_debug
%ifdef _boot_debug 
org 0x100
%else
org 0x7c00
%endif
%include "load.inc"

	jmp short Label_Start		; Start to boot.
	nop				; 这个 nop 不可少
%include "fat12hdr.inc" 
Label_Start:
	mov ax,cs	;初始化寄存器
	mov ds,ax
	mov es,ax
	mov ax,0xB800
	mov gs,ax
	mov sp,0x100
	call ClearScreen
	
	mov dh,0
	call Disstr		;显示启动信息
	xor ah,ah
	xor dl,dl
	int 0x13
	mov dh,1
	call Disstr
	mov ax,19
	mov cl,14
	mov ax,BaseofRoot	;从0x8840:0开始保存根目录区
	mov es,ax
	mov bx,OffsetOfRoot
	
	mov ax,19
	mov cl,14
	call ReadSector	;将根目录区一次全部读完
	mov ax,LOADER_FILE
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
	mov dh,3
	call Disstr
	jmp $
FOUND_lOADER_FILE:
	push dx
	mov dh,2
	call Disstr
			;找到启动文件之后
	;读fat表
	mov ax,BaseofFat
	mov es,ax
	mov bx,OffsetOfFat
	mov ax,1
	mov cl,9
	call ReadSector
	;解压fat表
	
	mov bx,OffsetOfFat
	mov ax,BaseofFat
	mov es,ax
	
	mov ax,BaseofexratFat
	mov gs,ax
	mov di,OffsetOfexratFat
	mov cx,1536
	
BeginExat:
	xor ax,ax
	xor dx,dx
	mov al,[es:bx]
	mov dl,[es:bx+1]
	mov dh,dl
	and dl,0x0f
	or ah,dl
	mov [gs:di],ax
	xor ax,ax
	mov al,[es:bx+2];两个字节保存一个fat项
	shl ax,4
	shr dh,4
	or al,dh
	mov [gs:di+2],ax
	add bx,3	;每次解压两个fat
	add di,4	;偏移为4字节
	loop BeginExat
	pop dx

		
	;读取文件
	mov di,dx
	add di,0x1a
	mov ax,BaseofRoot
	mov es,ax
	mov ax,[es:di]
	mov dx,BaseofLoader
	mov es,dx
	mov bx,OffestofLoader
	mov di,OffsetOfexratFat
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
	xor ecx,ecx
	mov cx,[gs:di]
	cmp cx,0xFF8
	jnl LOADEROK
	mov ax,cx
	pop bx
	add bx,512
	jmp BeginLoader	
LOADEROK:	
	jmp BaseofLoader:OffestofLoader
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
	
ClearScreen:
		; 清屏
	mov	ax, 0600h		; AH = 6,  AL = 0h
	mov	bx, 0700h		; 黑底白字(BL = 07h)
	mov	cx, 0			; 左上角: (0, 0)
	mov	dx, 0184fh		; 右下角: (80, 50)
	int	10h			; int 10h
	ret 
BootMessage:
MessageLen equ 9		;显示的消息长度
			db 'boot...  '
			db 'reading  '
			db 'ready    '
			db 'Noloader '

LOADER_FILE:			db 'LOADER  BIN'	
times 510-($-$$) db 0
dw 0xaa55
