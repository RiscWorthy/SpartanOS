# This build script is currently designed for RISC-V

# Input params 
#  - TARGET
#	 - Default: virt
# 	 - Acceptable values: sifive_e, virt
# 	 - Purpose: To configure kernel and set correct machine platform for emulation

#  - TBITS
#	 - Default: 64
# 	 - Acceptable values: 32, 64
# 	 - Purpose: To configure target bits of output

# Additional configuration
ifdef TARGET
	MACHINE = $(TARGET)
else
	MACHINE = virt
endif

ifdef TBITS
 	BITS = 32
 	MABI = -mabi=ilp32
 	32OPTIN = -m elf32lriscv
else
	BITS = 64
	MABI = -mabi=lp64
endif

GDBPORT = 2950
K = kernel
D = drivers
L = library
_D = _debug
PLATFORM = riscv64-unknown-elf

# Dynamically generate object file lists
KERNEL_FILES = $(shell ls $(K)/*.[S,c] | sed -e "s/\.[S,c]/.o/g")
DRIVER_FILES = $(shell ls $(D)/*$(MACHINE).[S,c] | sed -e "s/\.[S,c]/.o/g")
LIBRARY_FILES = $(shell ls $(L)/*$(BITS).[S,c] | sed -e "s/\.[S,c]/.o/g")
OBJECT_FILES = $(KERNEL_FILES) $(LIBRARY_FILES) $(DRIVER_FILES)

# Executables
QEMU = qemu-system-riscv$(BITS)
CC = $(PLATFORM)-gcc
AS = $(PLATFORM)-gas
LD = $(PLATFORM)-ld
OBJCOPY = $(PLATFORM)-objcopy
OBJDUMP = $(PLATFORM)-objdump

# Flags
CFLAGS = -Wall -Werror -O -fno-omit-frame-pointer -ggdb -I./$(K)/includes
CFLAGS += -march=rv$(BITS)imac $(MABI) -mcmodel=medany  -ffreestanding -fno-common -nostdlib -mno-relax
ASFLAGS = -march=rv$(BITS)imac $(MABI) -mcmodel=medany -I./$(K)/includes/asm/riscv$(BITS)
LDFLAGS = $(32OPTIN) -z max-page-size=4096

QEMUFLAGS = -machine $(MACHINE) -bios none -kernel $(K)/$(K) -m 128M -nographic


.PHONY: debug

kernel/kernel: $(OBJECT_FILES) $(K)/linker-$(MACHINE).ld
	$(LD) $(LDFLAGS) -T $(K)/linker-$(MACHINE).ld -o $(K)/$(K) $(OBJECT_FILES)
	mkdir -p $(_D)
	$(OBJDUMP) -S $(K)/$(K) > $(_D)/$(K).asm
	$(OBJDUMP) -t $(K)/$(K) | sed '1,/SYMBOL TABLE/d; s/ .* / /; /^$$/d' > $(_D)/$(K).sym
	@echo "\n\n\t$(MACHINE)\n\t\tbuild finished...\n"

emulate: clean $(K)/$(K)
	$(QEMU) $(QEMUFLAGS)

debug: clean $(K)/$(K)
	@echo "*** Ready for GDB to connect @ tcp:$(GDBPORT)." 1>&2
	$(QEMU) $(QEMUFLAGS) -S -gdb tcp::$(GDBPORT)

walkthrough: clean $(K)/$(K)
	$(QEMU) $(QEMUFLAGS) -S -gdb tcp::$(GDBPORT) &
	$(PLATFORM)-gdb --batch -e kernel/kernel -q -x _debug/walkthrough.gdb > _debug/walkthrough.txt
	pkill qemu

clean:
	rm -rf $(K)/*.o
	rm -rf $(L)/*.o
	rm -rf $(D)/*.o
	rm -rf $(K)/$(K)
