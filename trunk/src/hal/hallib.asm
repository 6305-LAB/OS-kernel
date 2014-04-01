
;导出全局函数
global load_gdtr
global load_idtr

global io_outb
global io_inb
global io_outw
global io_inw
global io_outdw
global io_indw
global io_sti
global io_cli
global io_load_eflags
global io_store_eflags
global mentest_sub
global load_cr0
global store_cr0
global memtest_sub

bits 32
[section .text]
load_gdtr:		; void load_gdtr(int limit, int addr);
		MOV		AX,[ESP+4]		; limit
		MOV		[ESP+6],AX
		LGDT	[ESP+6]
		RET

load_idtr:		; void load_idtr(int limit, int addr);
		MOV		AX,[ESP+4]		; limit
		MOV		[ESP+6],AX
		LIDT	[ESP+6]
		RET
		
io_outb:	;byte io指令 void io_outb(int port,int data)
		mov edx,[esp+4]
		mov eax,[esp+8]
		out dx,al
		ret

io_inb: ;byte io指令 int io_inb(int port);
		mov edx,[esp+4]
		mov eax,0
		in al,dx		
		ret
io_inw: ;16位in指令 int io_inw(int port);
	mov edx,[esp+4]
	mov eax,0
	in ax,dx
	ret
io_outw: ;void io_outw(int port,int data)
	mov edx,[esp+4]
	mov eax,[esp+8]
	out dx,ax
	ret
	
io_indw: ;int io_indw(int port);
	mov edx,[esp+4]
	mov eax,0
	in eax,dx
	ret
	
io_outdw: 			;void io_outdw(int port,int data)
	mov edx,[esp+4]
	mov eax,[esp+8]
	out dx,eax
	ret
	
io_sti:	;开中断 void io_sti(void);
	sti
	ret
	
io_cli: ;关中断 void io_cli(void);
	cli
	ret
io_load_eflags:	;将eflags值返回 int io_load_eflags(void);
	pushfd
	pop eax
	ret
io_store_eflags: ;回复eflags void io_store_eflags(int eflags);
	mov eax,[esp+4]
	push eax
	popfd
	ret
load_cr0:
	mov eax,cr0
	ret
store_cr0:
	mov eax,[esp+4]
	mov eax,cr0
	ret
memtest_sub: ;unsigned int memtest_sub(unsigned int start,unsigned int end)

	push edi
	push esi
	push ebx
	
	mov esi,0xaa55aa55
	mov edi,0x55aa55aa
mts_loop:
	mov ebx,eax
	add ebx,0xffc
	mov edx,[ebx]
	mov [ebx],esi
	xor dword [ebx],0xffffffff
	cmp edi,[ebx]
	jne mts_fin
	xor dword[ebx],0xffffffff
	cmp esi,[ebx]
	jne mts_fin
	add eax,0x1000
	cmp eax,[esp+12+8]
	jbe mts_loop
	pop ebx
	pop esi
	pop edi
	ret
	
mts_fin:
	mov [ebx],edx
	pop ebx
	pop esi
	pop edi
	ret