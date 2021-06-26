#ifndef TRAP_H
#define TRAP_H

typedef void (*trap_fn)(unsigned int** regs, unsigned int* mcause, unsigned int* mepc);
void trap_handler(unsigned int** regs, unsigned int* mcause, unsigned int* mepc);


#endif /* TRAP_H */