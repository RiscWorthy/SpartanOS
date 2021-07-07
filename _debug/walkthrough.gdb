# This script, called via "make walkthrough", instruments all functions in remote
# and then non-interactively prints helpful info as each function is entered
# until spin is entered and then the script quits
# Script output is logged to _debug/walkthrough.txt


file kernel/kernel
set style enabled on

b spin
commands 1
	quit
end

rbreak .
commands
	echo \n\033[01;31mNext Instruction\033[0m:\n
	x/i $pc
	# Problems printing stack frame currently on 64bit sifive_e, and 32bit virt and sifive_e
	# echo \n\033[01;31mFrame\033[01;0m:\n
	# i fr
	# Problems printing stack currently on 32bit sifive_e, pc not saved...
	# echo \n\033[01;31mStack\033[01;0m:\n
	# i stack
	if $sp != 0
		echo \n\033[01;31mStack Print\033[01;0m:\n
		x/20xg $sp
	end
	echo \n\033[01;31mDisassemble\033[01;0m:\n
	disas

	echo \033[01;32m\n\n
	continue
end

echo \033[01;32m

continue
