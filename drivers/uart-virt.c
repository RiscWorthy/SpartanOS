//
// low-level driver routines for 16550a UART.
//

// the UART control registers.
// some have different meanings for
// read vs write.
// see http://byterunner.com/16550.html
#include <types.h>

#define RHR 0                 // receive holding register (for input bytes)
#define THR 0                 // transmit holding register (for output bytes)
#define IER 1                 // interrupt enable register
#define IER_RX_ENABLE (1<<0)
#define IER_TX_ENABLE (1<<1)
#define FCR 2                 // FIFO control register
#define FCR_FIFO_ENABLE (1<<0)
#define FCR_FIFO_CLEAR (3<<1) // clear the content of the two FIFOs
#define ISR 2                 // interrupt status register
#define LCR 3                 // line control register
#define LCR_EIGHT_BITS (3<<0)
#define LCR_BAUD_LATCH (1<<7) // special mode to set baud rate
#define LSR 5                 // line status register
#define LSR_TX_IDLE (1<<5)    // THR can accept another character to send

#define UART0 0x10000000L
#define Reg(reg) ((volatile u8 *)(UART0 + reg))
#define ReadReg(reg) (*(Reg(reg)))
#define WriteReg(reg, v) (*(Reg(reg)) = (v))

// Initialize the uart0 device
void uart_init(void) {
	// disable interrupts.
	WriteReg(IER, 0x00);

	// special mode to set baud rate.
	WriteReg(LCR, LCR_BAUD_LATCH);

	// LSB for baud rate of 38.4K.
	WriteReg(0, 0x03);

	// MSB for baud rate of 38.4K.
	WriteReg(1, 0x00);

	// leave set-baud mode,
	// and set word length to 8 bits, no parity.
	WriteReg(LCR, LCR_EIGHT_BITS);

	// reset and enable FIFOs.
	WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
}

// Spin waiting for uart0 to print character.
void uart_putc_sync(u32 c) {
	// wait for Transmit Holding Empty to be set in LSR.
	while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
		;
	WriteReg(THR, c);
}

// Spin until uart0 returns a valid character value.
u32 uart_getc_sync(void) {
	while(1) {
		if(ReadReg(LSR) & 0x01){
			// input data is ready.
			return ReadReg(RHR);
		}
	}
}