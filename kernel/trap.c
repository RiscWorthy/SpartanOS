#include <trap.h>
#include <uart.h>
#include <dprintf.h>

#define die(str, ...) ({ \
	dprintf(300, "%s:%d: " str "\n", __FILE__, __LINE__, ##__VA_ARGS__); \
	asm volatile("1: j 1b"); })


static trap_fn tfn = 0;

void trap_handler(unsigned int** regs, unsigned int* mcause, unsigned int* mepc){
	if (tfn) {
		tfn(regs, mcause, mepc);
	} else {
		die("machine mode: unhandlable trap %d @ %p", mcause, mepc);
	}
}