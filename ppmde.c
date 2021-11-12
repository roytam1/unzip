#include <stdio.h>

#include "lzma/Types.h"
#include "lzma/CpuArch.h"

union
{
    unsigned int u;
    unsigned char b[ 4];
} ui32;

int main( void)
{

#ifdef __BIG_ENDIAN__
    printf( " __BIG_ENDIAN__\n");
#endif

#ifdef __LITTLE_ENDIAN__
    printf( " __LITTLE_ENDIAN__\n");
#endif

    ui32.u = 0x01020304;

    printf( " %02x %02x %02x %02x \n",
     ui32.b[ 3], ui32.b[ 2], ui32.b[ 1], ui32.b[ 0]);

    printf( " GetUi32() = %08x \n", GetUi32( ui32.b));
}
