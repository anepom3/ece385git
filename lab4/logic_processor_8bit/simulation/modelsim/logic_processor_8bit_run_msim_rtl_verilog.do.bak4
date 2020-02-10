transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/antho/Desktop/ece385git/lab4/logic_processor_8bit {C:/Users/antho/Desktop/ece385git/lab4/logic_processor_8bit/full_adder.sv}
vlog -sv -work work +incdir+C:/Users/antho/Desktop/ece385git/lab4/logic_processor_8bit {C:/Users/antho/Desktop/ece385git/lab4/logic_processor_8bit/adder2.sv}

vlog -sv -work work +incdir+C:/Users/antho/Desktop/ece385git/lab4/logic_processor_8bit {C:/Users/antho/Desktop/ece385git/lab4/logic_processor_8bit/testbench_adder2.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run 1000 ns
