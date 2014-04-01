#ifndef __HAL_H
#define __HAL_H

#define DA_32 0x40000 //32位段
#define DA_LIMIT_4K	0x8000 //粒度为4k

#define DA_DPL0 0x00 //特权级0-3
#define DA_DPL1 0x20
#define DA_DPL2 0x40
#define DA_DPL3 0x60

#define DA_DR			0x90
//; 存在的只读数据段类型值
#define DA_DRW			0x92	
//; 存在的可读写数据段属性值
#define DA_DRWA			0x93	
//; 存在的已访问可读写数据段类型值
#define DA_C			0x98	
//; 存在的只执行代码段属性值
#define DA_CR			0x9A
//; 存在的可执行可读代码段属性值
#define DA_CCO			0x9C	
//; 存在的只执行一致代码段属性值
#define DA_CCOR			0x9E	
//; 存在的可执行可读一致代码段属性值

#define DA_LDT			 0x82	
//; 局部描述符表段类型值
#define DA_TaskGate		  0x85
//; 任务门类型值
#define DA_386TSS		  0x89	
//; 可用 386 任务状态段类型值
#define DA_386CGate		  0x8C
//; 386 调用门类型值
#define DA_386IGate		  0x8E
//; 386 中断门类型值
#define DA_386TGate		  0x8F	
//; 386 陷阱门类型值


#define SA_RPL0			0
//; ┓
#define SA_RPL1			1
//; ┣ RPL
#define SA_RPL2			2
//; ┃
#define SA_RPL3			3
//; ┛

#define SA_TIG			0
//; ┓TI
#define SA_TIL			4
//; ┛

struct SEGMENT_DESCRIPTOR{
	short limt_low, base_low;
	char base_mid, access_right;
	char access_left,base_high;

};
struct GATE_DESCRIPTOR
{
	short offset_low, selector;
	char dw_count, access_right;
	short offset_high;
};
extern struct SEGMENT_DESCRIPTOR*gdt;//段描述符
extern struct GATE_DESCRIPTOR *idt; //门描述符
#endif
//全局段表和门描述符初始化


//段描述符 sd 段数据地址 limit 段上限  base 段基址 ar 段属性
void set_segmendsec(struct SEGMENT_DESCRIPTOR*sd, unsigned int limit, unsigned int base, int ar);
//门描述符 gd 描述符指针 offset 偏移量 selector 对应的选择子 ar 属性
void set_gatedesc(struct GATE_DESCRIPTOR*gd, unsigned int offset, unsigned int selector, unsigned int ar);
//limit 上限 base 基址
void load_gdtr(int limit, int base);//加载段描述符
void load_idtr(int limit, int base);//加载idt描述符
void init_gdtidt(void);

//8、16、32位端口in out
void io_outb(int port,int data);
int io_inb(int port);
void io_outw(int port,int data);
int io_inw(int port);
void io_outw(int port,int data);
int io_indw(int port);

 //中断开关
 void io_sti(void);
 void io_cli(void);

 //标志位读取与设置
 int io_load_eflags(void);
 void io_store_eflags(int eflags);

 //修改cr0
 int load_cr0(void);
 void store_cr0(int cr0);

 //内存测试
 unsigned int memtest_sub(unsigned int start,unsigned int end);
 