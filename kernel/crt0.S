.section .init
.global _entry
_entry:
	# set up a 4kb stack for C.
        la sp, stackC
        li a0, 1024*4
        add sp, sp, a0

        # Disable paging until kernel is ready...
        csrw satp, 0

	# jump to start() in kernel/start.c
        call start
spin:
        wfi
        j spin