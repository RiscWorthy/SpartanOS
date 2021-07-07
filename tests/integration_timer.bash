# This script checks the four major supported environments...
# virt (32 and 64) and sifive_e (32 and 64)
# ... to see if they support timer interrupts correctly
# Call this script via "make test-timer"

# SpartanOS initializes timers and then waits for 2 timer tick interrupts.
# If timer ticks are working correctly the following will be printed to the 
# assumed working UART:
# TIMER: Fired atleast 2 times
# Therefore this test only works if the UART AND Timer are working correctly.

report_result() {
	if [[ $1 -eq 0 ]]
	then
		echo $2 platform did not pass Timer test
	fi
}

search_out() {
	cat tests/_out/$1 | grep "TIMER: Fired atleast 2 times" | wc -l
}

t1=$(search_out 64_virt)
t2=$(search_out 32_virt)
t3=$(search_out 64_sifive_e)
t4=$(search_out 32_sifive_e)
result=$((t1 + t2 + t3 + t4))
if [[ $result -gt 3 ]]
then
	echo Timer is working correctly
else
	report_result t1 64_virt
	report_result t2 32_virt
	report_result t3 64_sifive_e
	report_result t4 32_sifive_e
fi
