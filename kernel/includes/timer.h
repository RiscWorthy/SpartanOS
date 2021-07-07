#ifndef TIMER_H
#define TIMER_H

#include <types.h>

#define CYCLE_INTERVAL 2000000
#define CLINT_MTIMECMP 0x2004000L
#define CLINT_MTIME 0x200BFF8L
#define MSTATUS_ENABLE_INTERRUPT (1L << 3)
#define MIE_ENABLE_TIMER (1L << 7) 

void timer_init();
u64 get_clock_ticks();
void tick_stall(int);

#endif /* TIMER_H */