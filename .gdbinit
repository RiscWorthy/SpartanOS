
set history save
set verbose off
set print pretty on
set print array off
set print array-indexes on
set python print-stack full
set confirm off
set architecture riscv:rv64
target remote 127.0.0.1:2950
symbol-file kernel/kernel
set disassemble-next-line auto
set riscv use-compressed-breakpoints yes
