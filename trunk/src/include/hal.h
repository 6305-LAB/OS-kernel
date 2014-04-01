#ifndef __HAL_H
#define __HAL_H

#define DA_32 0x40000 //32λ��
#define DA_LIMIT_4K	0x8000 //����Ϊ4k

#define DA_DPL0 0x00 //��Ȩ��0-3
#define DA_DPL1 0x20
#define DA_DPL2 0x40
#define DA_DPL3 0x60

#define DA_DR			0x90
//; ���ڵ�ֻ�����ݶ�����ֵ
#define DA_DRW			0x92	
//; ���ڵĿɶ�д���ݶ�����ֵ
#define DA_DRWA			0x93	
//; ���ڵ��ѷ��ʿɶ�д���ݶ�����ֵ
#define DA_C			0x98	
//; ���ڵ�ִֻ�д��������ֵ
#define DA_CR			0x9A
//; ���ڵĿ�ִ�пɶ����������ֵ
#define DA_CCO			0x9C	
//; ���ڵ�ִֻ��һ�´��������ֵ
#define DA_CCOR			0x9E	
//; ���ڵĿ�ִ�пɶ�һ�´��������ֵ

#define DA_LDT			 0x82	
//; �ֲ��������������ֵ
#define DA_TaskGate		  0x85
//; ����������ֵ
#define DA_386TSS		  0x89	
//; ���� 386 ����״̬������ֵ
#define DA_386CGate		  0x8C
//; 386 ����������ֵ
#define DA_386IGate		  0x8E
//; 386 �ж�������ֵ
#define DA_386TGate		  0x8F	
//; 386 ����������ֵ


#define SA_RPL0			0
//; ��
#define SA_RPL1			1
//; �� RPL
#define SA_RPL2			2
//; ��
#define SA_RPL3			3
//; ��

#define SA_TIG			0
//; ��TI
#define SA_TIL			4
//; ��

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
extern struct SEGMENT_DESCRIPTOR*gdt;//��������
extern struct GATE_DESCRIPTOR *idt; //��������
#endif
//ȫ�ֶα������������ʼ��


//�������� sd �����ݵ�ַ limit ������  base �λ�ַ ar ������
void set_segmendsec(struct SEGMENT_DESCRIPTOR*sd, unsigned int limit, unsigned int base, int ar);
//�������� gd ������ָ�� offset ƫ���� selector ��Ӧ��ѡ���� ar ����
void set_gatedesc(struct GATE_DESCRIPTOR*gd, unsigned int offset, unsigned int selector, unsigned int ar);
//limit ���� base ��ַ
void load_gdtr(int limit, int base);//���ض�������
void load_idtr(int limit, int base);//����idt������
void init_gdtidt(void);

//8��16��32λ�˿�in out
void io_outb(int port,int data);
int io_inb(int port);
void io_outw(int port,int data);
int io_inw(int port);
void io_outw(int port,int data);
int io_indw(int port);

 //�жϿ���
 void io_sti(void);
 void io_cli(void);

 //��־λ��ȡ������
 int io_load_eflags(void);
 void io_store_eflags(int eflags);

 //�޸�cr0
 int load_cr0(void);
 void store_cr0(int cr0);

 //�ڴ����
 unsigned int memtest_sub(unsigned int start,unsigned int end);
 