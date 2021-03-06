# This script checks the four major supported environments...
# virt (32 and 64) and sifive_e (32 and 64)
# ... to see if they support uart correctly
# Call this script via "make test-uart"

# Since SpartanOS begins with a print statement, "SpartanOS Version:..."
# This makes for a feasible integration test. This text should be present in the
# output files coming from the serial device tee when emulating.

report_result() {
	if [[ $1 -eq 0 ]]
	then
		echo $2 platform did not pass UART test
	fi
}

search_out() {
	cat tests/_out/$1 | grep "SpartanOS Version:" | wc -l
}

t1=$(search_out 64_virt)
t2=$(search_out 32_virt)
t3=$(search_out 64_sifive_e)
t4=$(search_out 32_sifive_e)
result=$((t1 + t2 + t3 + t4))
if [[ $result -gt 3 ]]
then
	echo UART is working correctly
else
	report_result t1 64_virt
	report_result t2 32_virt
	report_result t3 64_sifive_e
	report_result t4 32_sifive_e
fi
