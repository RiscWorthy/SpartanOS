#include <uart.h>
#include <dprintf.h>
#include <memory.h>
#include <shell.h>
#include <trap.h>
#include <timer.h>
#include <types.h>
#include <cpu.h>

#define VERSION "0.1.3\n"

// crt0.S yields to start to initialize the system...
void start() {
	save_hart_id(); // Hart id stored into thread pointer aka x4
	uart_init(); // Serial communication for debugging.
	timer_init(); // CLINT clock timer enable

	dprintf(30, "\nSpartanOS Version: %s\n\0", VERSION);

	dprintf(43, "\nTIMER: Waiting for atleast 2 ticks...\n\0");
	tick_stall(2);
	dprintf(35, "\nTIMER: Fired atleast 2 times\n\0");

	while(1) {
		shell();
	}

	// ...system should be initialized now...
}
