#ifndef MEMORY_H
#define MEMORY_H

#include <types.h>

// entry.S requires a stack
__attribute__ ((aligned (16))) i8 stackC[4096];

#endif /* MEMORY_H */