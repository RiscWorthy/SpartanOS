#ifndef MEMORY_H
#define MEMORY_H

// entry.S requires a stack
__attribute__ ((aligned (16))) char stackC[4096];

#endif /* MEMORY_H */