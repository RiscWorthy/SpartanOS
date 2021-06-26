#include <uart.h>
#include <bufprint.h>
#include <memory.h>
#include <trap.h>

#define VERSION "0.1.1\n"

// Prints a simple test message to show the uart is working...
void print_test_message(){
	char a[40];
	bufprintf(a, "\nSpartanOS Version: %s\n\0", VERSION);
	for (char *c = a; *c; c++) {
		uart_putc_sync(*c);
	}
}

// crt0.S yields to start to initialize the system...
void start() {
	
	uart_init(); // Serial communication for debugging.

	print_test_message();

	// ...system should be initialized now...
}
