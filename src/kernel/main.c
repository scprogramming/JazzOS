#include "stdint.h"
#include "stdio.h"

void _cdecl cstart_(){
    puts("Hello World from C!\r\n");
    printf("Formatted: %% %c %s\r\n", 'f',"Hello");
    printf("%d,%i, %x, %p, %ld", 1234, -2134, 0x1a, 0x3a, -1000000000l);
}
