#include"hal.h"
struct SEGMENT_DESCRIPTOR*gdt = (struct SEGMENT_DESCRIPTOR*)0x500;
struct GATE_DESCRIPTOR *idt = (struct GATE_DESCRIPTOR*)0x10500;
void init_gdtidt(void)
{
	
	for (int i = 0; i < 8192;i++)
	{
		set_segmendsec(gdt + i, 0,0,0);
	}
	set_segmendsec(gdt + 1, 0xffffffff, 0x00, DA_CR | DA_32 | DA_LIMIT_4K);
	set_segmendsec(gdt + 2, 0xffffffff, 0x00, DA_DRW | DA_32 | DA_LIMIT_4K);
	set_segmendsec(gdt + 3, 0xffff, 0xb8000, DA_DRW | DA_DPL3);
	load_gdtr(0xffff, 0x500);
	
	for (int i = 0; i < 256;i++)
	{
		set_gatedesc(idt + i, 0, 0, 0);
	}
	load_idtr(0x7ff, 0x66036);

}
void set_segmendsec(struct SEGMENT_DESCRIPTOR*sd, unsigned int limit, unsigned int base, int ar)
{
	if (limit>0xfffff)
	{
		ar | 0x8000;
		limit /=0x1000;
	}
	sd->limt_low = limit & 0xffff;
	sd->base_low = base & 0xffff;
	sd->base_mid = base&((base >> 16 )& 0xff);
	sd->access_right = ar & 0xff;
	sd->access_left = ((ar >> 8) & 0xf0) | ((limit >> 16) & 0x0f);
	sd->base_high = base >> 24;
}
void set_gatedesc(struct GATE_DESCRIPTOR*gd, unsigned int offset, unsigned int selector, unsigned int ar)
{
	gd->offset_low = offset & 0xffff;
	gd->selector = selector ;
	gd->offset_high = (offset >> 16)&0xffff;
	gd->dw_count = ar & 0xff;
	gd->access_right =(ar>> 8)&0xff;
}