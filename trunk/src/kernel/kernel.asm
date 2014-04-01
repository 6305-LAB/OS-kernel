
extern	cstart
[SECTION .bss]
StackSpace		resb	2 * 1024
StackTop:		; 栈顶

[section .text]
global _start
_start:
mov	esp, StackTop	; 堆栈在 bss 段中
mov ah,0xf
mov al,'K'
mov [gs:(80*12+8)*2],ax
call cstart


jmp $