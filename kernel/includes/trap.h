#ifndef TRAP_H
#define TRAP_H

#include <types.h>

typedef void (*trap_fn)(u32** regs, u32* mcause, u32* mepc);
void trap_handler(u32** regs, u32* mcause, u32* mepc);

#define die(str, ...) ({ \
	dprintf(300, "%s:%d: " str "\n", __FILE__, __LINE__, ##__VA_ARGS__); \
	asm volatile("1: j 1b"); })

#endif /* TRAP_H */