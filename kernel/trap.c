#include <trap.h>
#include <uart.h>
#include <bufprint.h>

#define die(str, ...) ({ \
	char a[300]; \
	bufprintf(a, "%s:%d: " str "\n", __FILE__, __LINE__, ##__VA_ARGS__); \
	for (char *c = a; *c; c++) { \
		uart_putc_sync(*c); \
	} \
	asm volatile("1: j 1b"); })


static trap_fn tfn = 0;

void trap_handler(unsigned int** regs, unsigned int* mcause, unsigned int* mepc){
	if (tfn) {
		tfn(regs, mcause, mepc);
	} else {
		die("machine mode: unhandlable trap %d @ %p", mcause, mepc);
	}
}