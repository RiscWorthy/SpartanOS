#include <timer.h>
#include <types.h>

volatile u64 timer_scratch[4];
u64 clock_ticks = 0;
extern void timer_interrupt();

u64 get_clock_ticks(){
#if __riscv_xlen == 32
	// NOTE: This is a bit of a hack for 32 bit mode to get the correct index...
	// Using timer_scratch[3], the compiler tries to access &timer_scratch + 0xc (12)..
	// ...but we want &timer_scratch + 0x18 (24). In other words 6 * 4 == 3 * 8...

	// The compiler is probably doing the correct thing and there is likely a better workaround 
	// or approach for this but this is fine for now IMO as long as the above is understood.
	return timer_scratch[3 * 2];	
#else
	return timer_scratch[3];	
#endif
}

void timer_init() {
	// We are guaranteed to be on hart 0 at this point in time.
	// Therefore we only need to address the CLINT at id 0.
	*(u64*)CLINT_MTIMECMP = *(u64*)CLINT_MTIME + CYCLE_INTERVAL;
	// Setup scratch area
	volatile u64 *scratch = &timer_scratch[0];
	asm volatile("csrw mscratch, %0" : : "r" (scratch));
	asm volatile("csrw mtvec, %0" : : "r" (timer_interrupt));
	// Enable machine mode interrupts
	u64 mstatus;
	asm volatile("csrr %0, mstatus" : "=r" (mstatus) );
	asm volatile("csrw mstatus, %0" : : "r" (mstatus | MSTATUS_ENABLE_INTERRUPT));
	// Enable machine mode timer
	u64 mie;
	asm volatile("csrr %0, mie" : "=r" (mie) );
	asm volatile("csrw mie, %0" : : "r" (mie | MIE_ENABLE_TIMER));
}

void tick_stall(int ticks){
	int endpoint = get_clock_ticks() + ticks;
	while(get_clock_ticks() < endpoint){
		// do nothing...
	}
}
