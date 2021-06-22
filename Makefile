# This build script is currently designed for RISC-V64...
# I will need to revisit this if I want to build for additional architectures

# Additional configuration
GDBPORT = 2950
MACHINE = virt
# MACHINE = sifive_e
BITS = 64
# BITS = 32 NOTE: BITS = 32 IS CURRENTLY NOT TESTED OR SUPPORTED AT THE MOMENT
K = kernel
D = drivers
L = library

# Dynamically generate object file lists
KERNEL_FILES = $(shell ls kernel/*.[S,c] | sed -e "s/\.[S,c]/.o/g")
DRIVER_FILES = $(shell ls $(D)/*$(MACHINE).[S,c] | sed -e "s/\.[S,c]/.o/g")
LIBRARY_FILES = $(shell ls $(L)/*.[S,c] | sed -e "s/\.[S,c]/.o/g")
OBJECT_FILES = $(KERNEL_FILES) $(LIBRARY_FILES) $(DRIVER_FILES)

# Executables
QEMU = qemu-system-riscv$(BITS)
CC = riscv$(BITS)-unknown-linux-gnu-gcc
AS = riscv$(BITS)-unknown-linux-gnu-gas
LD = riscv$(BITS)-unknown-linux-gnu-ld
OBJCOPY = riscv$(BITS)-unknown-linux-gnu-objcopy
OBJDUMP = riscv$(BITS)-unknown-linux-gnu-objdump

# Flags
CFLAGS = -Wall -Werror -O -fno-omit-frame-pointer -ggdb -I./kernel/includes
CFLAGS += -mcmodel=medany -ffreestanding -fno-common -nostdlib -mno-relax

LDFLAGS = -z max-page-size=4096

QEMUFLAGS = -machine $(MACHINE) -bios none -kernel kernel/kernel -m 128M -nographic


.PHONY: debug

kernel/kernel: $(OBJECT_FILES) $(K)/linker.ld
	$(LD) $(LDFLAGS) -T $(K)/linker.ld -o $(K)/kernel $(OBJECT_FILES)
	mkdir -p debug
	$(OBJDUMP) -S $(K)/kernel > debug/kernel.asm
	$(OBJDUMP) -t $(K)/kernel | sed '1,/SYMBOL TABLE/d; s/ .* / /; /^$$/d' > debug/kernel.sym

emulate: kernel/kernel
	$(QEMU) $(QEMUFLAGS)

debug: kernel/kernel
	@echo "*** Ready for GDB to connect @ tcp:$(GDBPORT)." 1>&2
	$(QEMU) $(QEMUFLAGS) -S -gdb tcp::$(GDBPORT)

clean:
	rm -rf debug/*
	rm -rf kernel/*.o
	rm -rf library/*.o
	rm -rf drivers/*.o
	rm -rf kernel/kernel