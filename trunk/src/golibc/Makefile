TARGET     = golibc
CC         = gcc
CFLAGS     = -std=gnu99 -c -fno-stack-protector  
OBJS       = abs.o atof.o atoi.o errno.o frexp.o ldexp.o \
	memchr.o memcmp.o memmove.o memset.o qsort.o \
	sprintf.o strcat.o strcmp.o strcpy.o strcspn.o strdup.o \
	strlen.o strncat.o strncmp.o strncpy.o strpbrk.o strrchr.o \
	strspn.o strstr.o strtol.o strtoul.o strtoul0.o vsprintf.o
 	
libmyc.a: $(OBJS)
	ar cr  -o $@ $(OBJS)

atof.o: atof.c
	$(CC) $(CFLAGS)	-o $@ $<

atoi.o: atoi.c
	$(CC) $(CFLAGS)	-o $@ $<

errno.o: errno.c
	$(CC) $(CFLAGS)	-o $@ $<

frexp.o: frexp.c
	$(CC) $(CFLAGS)	-o $@ $<

ldexp.o: ldexp.c
	$(CC) $(CFLAGS)	-o $@ $<
	
memchr.o: memchr.c
	$(CC) $(CFLAGS)	-o $@ $<
	
memcmp.o: memcmp.c
	$(CC) $(CFLAGS)	-o $@ $<
	
memmove.o: memmove.c
	$(CC) $(CFLAGS)	-o $@ $<
	
memset.o: memset.c
	$(CC) $(CFLAGS)	-o $@ $<
	
qsort.o: qsort.c
	$(CC) $(CFLAGS)	-o $@ $<
	
sprintf.o: sprintf.c
	$(CC) $(CFLAGS)	-o $@ $<
	
strcat.o: strcat.c
	$(CC) $(CFLAGS)	-o $@ $<

strcmp.o: strcmp.c
	$(CC) $(CFLAGS)	-o $@ $<

strcpy.o: strcpy.c
	$(CC) $(CFLAGS)	-o $@ $<

strcspn.o: strcspn.c
	$(CC) $(CFLAGS)	-o $@ $<
	
strdup.o: strdup.c
	$(CC) $(CFLAGS)	-o $@ $<
	
strlen.o: strlen.c
	$(CC) $(CFLAGS)	-o $@ $<
	
strncat.o: strncat.c
	$(CC) $(CFLAGS)	-o $@ $<
	
strncmp.o: strncmp.c
	$(CC) $(CFLAGS)	-o $@ $<
	
strncpy.o: strncpy.c
	$(CC) $(CFLAGS)	-o $@ $<
	
strpbrk.o: strpbrk.c
	$(CC) $(CFLAGS)	-o $@ $<

strrchr.o: strrchr.c
	$(CC) $(CFLAGS)	-o $@ $<
	
strspn.o: strspn.c
	$(CC) $(CFLAGS)	-o $@ $<
	
strstr.o: strstr.c
	$(CC) $(CFLAGS)	-o $@ $<
	
strtol.o: strtol.c
	$(CC) $(CFLAGS)	-o $@ $<

strtoul0.o: strtoul0.c
	$(CC) $(CFLAGS)	-o $@ $<
vsprintf.o: vsprintf.c
	$(CC) $(CFLAGS)	-o $@ $<
	
