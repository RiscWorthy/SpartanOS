# Purge last results
rm -rf tests/_out/*

run_test() {
	echo "Emulating $1..."
	make emulate LOGFILE=tests/_out/$1 &>/dev/null &
	sleep 2
	pkill qemu
}

# Emulate to get output
run_test 64_virt
run_test 32_virt
run_test 64_sifive_e
run_test 32_sifive_e