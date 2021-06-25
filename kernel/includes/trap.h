typedef void (*trap_fn)(unsigned int** regs, unsigned int* mcause, unsigned int* mepc);
void trap_handler(unsigned int** regs, unsigned int* mcause, unsigned int* mepc);