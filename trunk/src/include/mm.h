#ifndef __MM_H
#define __MM_H
#define MEMMAN_FREES 4090
struct FREEINFO{ //可用信息
int addr,size;
};
struct MEMMAN{ //内存管理
int frees,maxfrees,lostsize,losts;
struct FREEINFO free[MEMMAN_FREES];
};
#endif
unsigned int memtest( unsigned int start, unsigned int end );
void memman_init(struct MEMMAN* man);
unsigned int memman_total(struct MEMMAN * man);
int memman_free(struct MEMMAN*man,unsigned int addr,unsigned int size);
unsigned int memman_alloc(struct MEMMAN*man,unsigned int size);