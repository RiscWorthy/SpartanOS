//
// low-level driver routines for SiFive UART.
//

#define TXEN    			(1 << 0)
#define TXDATA_FULL   		(1 << 31)
#define UART0_BAUD_RATE 	115200
#define UART0_CLOCK_FREQ 	32000000
#define UART0_ADDRESS 		0x10013000
#define BASE 				0
#define TXCTRL 				8
#define RXCTRL 				12
#define DIV 				24
#define SET_ADDR(num, val) *(unsigned int *)(UART0_ADDRESS + num) = val;
#define READ_ADDR *(unsigned int *)(UART0_ADDRESS)

// Initialize the uart0 device
void uart_init(void) {
	// Enable read and write transactions
	SET_ADDR(TXCTRL, TXEN);
	SET_ADDR(RXCTRL, TXEN);

	// Set Divisor
	SET_ADDR(DIV, UART0_CLOCK_FREQ / UART0_BAUD_RATE - 1);
}

// Spin waiting for uart0 to print character.
void uart_putc_sync(int c) {
	/* Wait while TX FIFO is full */
	while (READ_ADDR & TXDATA_FULL)
		;

	SET_ADDR(BASE, c);
}