#include <uart.h>
#include <dprintf.h>
#include <memory.h>
#include <trap.h>

#define VERSION "0.1.1\n"

// crt0.S yields to start to initialize the system...
void start() {
	
	uart_init(); // Serial communication for debugging.

	dprintf(30, "\nSpartanOS Version: %s\n\0", VERSION);

	// ...system should be initialized now...
}
