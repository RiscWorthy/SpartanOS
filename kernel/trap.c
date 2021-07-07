#include <trap.h>
#include <types.h>
#include <uart.h>
#include <dprintf.h>

static trap_fn tfn = 0;

void trap_handler(u32** regs, u32* mcause, u32* mepc){
	if (tfn) {
		tfn(regs, mcause, mepc);
	} else {
		die("machine mode: unhandlable trap %d @ %p", mcause, mepc);
	}
}