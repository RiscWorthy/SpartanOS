#ifndef UART_H
#define UART_H

#include <types.h>

void uart_init(void);

void uart_putc_sync(i32 c);

u32 uart_getc_sync(void);

#endif /* UART_H */