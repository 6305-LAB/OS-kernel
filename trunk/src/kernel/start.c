#include<stdio.h>
#include<string.h>
#include "global.h"
#include "mm.h"
#define Textbuf 0xb8000

void myprintf(int, char *, int );
//int strlen(const char* str);

char *vedobuff = ((char*)0xa0000);
void cleanScreen();
//void atoi(char*,int);





//调色板色号
#define COL8_000000		0
#define COL8_FF0000		1
#define COL8_00FF00		2
#define COL8_FFFF00		3
#define COL8_0000FF		4
#define COL8_FF00FF		5
#define COL8_00FFFF		6
#define COL8_FFFFFF		7
#define COL8_C6C6C6		8
#define COL8_840000		9
#define COL8_008400		10
#define COL8_848400		11
#define COL8_000084		12
#define COL8_840084		13
#define COL8_008484		14
#define COL8_848484		15
#define	MEMMAN_ADDR     0x10cff
void cstart()
{
	struct MEMMAN *memman=(struct MEMMAN*) MEMMAN_ADDR;
	int memtotal=0;
	char *str="init_gdtidt";
	char tmp[256];

	cleanScreen();
	memtotal = memtest(0x200000,0xffffffff);
	
	memman_init(memman);
	memman_free(memman,0x18cff,0x77701);
	memman_free(memman,0x200000,memtotal-0x200000);
	
	io_cli();
	init_gdtidt();
	myprintf(Textbuf+(80*0+0)*2,str,strlen(str));

	
	sprintf(tmp,"total:%dM,frees:%d",memtotal/(1024*1024),memman_total(memman));
	myprintf(Textbuf+(80*1+0)*2, tmp, strlen(tmp));
	myprintf(Textbuf+(80*2+0)*2, str, strlen(str));
	for (;;);
}
void cleanScreen()
{
	int p=Textbuf;
	for(int i=0;i<80*25*2;i+=2)
	{
		*((short*)(p+i)) = (short)((' ') | 0x0c00);
	}

}
/*int strlen(const char* str)
{
	int i=0;
	for(; str[i]!=0; i++);
	return i;
}*/
void myprintf(int p,char*str, int len)
{
	for (int i = 0; i < len; str++, p +=2, i++)
	{
		*((short*)p) = ((short)*str) | 0x0c00;
	}
}
void atoi(char* str, int num)
{
	int max = 1000000000, i = 0;
	int t = 10;
	if (num == 0)
	{
		*str = 0;
		*(str + 1) = '\0';
		return;
	}
	for (; num < max; max /= 10);
	for (i = 0; max != 0; i++){
		*(str + i) = num / max + '0';
		num %= max;
		max /= 10;
		

	}
	*(str + i) = '\0';
}
void inthandler21(int *esp)
{

}
void init_pic(void)
{


}

//void init_palette(void)
//{
//	static unsigned char table_rgb[16 * 3] = {
//		0x00, 0x00, 0x00,	/*  0:黒 */
//		0xff, 0x00, 0x00,	/*  1:亮红*/
//		0x00, 0xff, 0x00,	/*  2:亮緑 */
//		0xff, 0xff, 0x00,	/*  3:亮黄色 */
//		0x00, 0x00, 0xff,	/*  4:亮蓝*/
//		0xff, 0x00, 0xff,	/*  5:亮紫 */
//		0x00, 0xff, 0xff,	/*  6:浅亮蓝 */
//		0xff, 0xff, 0xff,	/*  7:白 */
//		0xc6, 0xc6, 0xc6,	/*  8:亮色 */
//		0x84, 0x00, 0x00,	/*  9:暗赤 */
//		0x00, 0x84, 0x00,	/* 10:暗緑 */
//		0x84, 0x84, 0x00,	/* 11:暗黄色 */
//		0x00, 0x00, 0x84,	/* 12:暗青 */
//		0x84, 0x00, 0x84,	/* 13:暗紫 */
//		0x00, 0x84, 0x84,	/* 14:浅暗蓝 */
//		0x84, 0x84, 0x84	/* 15:暗色 */
//	};
//	set_palette(0, 15, table_rgb);
//	return;
//
//	/* static char 命令は、データにしか使えないけどDB命令相当 */
//}
//
//void set_palette(int start, int end, unsigned char *rgb)
//{
//	int i, eflags;
//	eflags = io_load_eflags();	/* 记录eflags信息*/
//	io_cli(); 					/* 关中断 */
//	io_out8(0x03c8, start);
//	for (i = start; i <= end; i++) {
//		io_out8(0x03c9, rgb[0] / 4);
//		io_out8(0x03c9, rgb[1] / 4);
//		io_out8(0x03c9, rgb[2] / 4);
//		rgb += 3;
//	}
//	io_store_eflags(eflags);	/* 割り込み許可フラグを元に戻す */
//	return;
//}
