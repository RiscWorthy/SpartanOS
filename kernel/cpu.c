void save_hart_id() {
	asm volatile("csrr tp, mhartid");
}