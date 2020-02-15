transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/antho/Desktop/ece385git/lab4/8bit_processor/logic_processor_4bit {C:/Users/antho/Desktop/ece385git/lab4/8bit_processor/logic_processor_4bit/Synchronizers.sv}
vlog -sv -work work +incdir+C:/Users/antho/Desktop/ece385git/lab4/8bit_processor/logic_processor_4bit {C:/Users/antho/Desktop/ece385git/lab4/8bit_processor/logic_processor_4bit/Router.sv}
vlog -sv -work work +incdir+C:/Users/antho/Desktop/ece385git/lab4/8bit_processor/logic_processor_4bit {C:/Users/antho/Desktop/ece385git/lab4/8bit_processor/logic_processor_4bit/Reg_4.sv}
vlog -sv -work work +incdir+C:/Users/antho/Desktop/ece385git/lab4/8bit_processor/logic_processor_4bit {C:/Users/antho/Desktop/ece385git/lab4/8bit_processor/logic_processor_4bit/HexDriver.sv}
vlog -sv -work work +incdir+C:/Users/antho/Desktop/ece385git/lab4/8bit_processor/logic_processor_4bit {C:/Users/antho/Desktop/ece385git/lab4/8bit_processor/logic_processor_4bit/Control.sv}
vlog -sv -work work +incdir+C:/Users/antho/Desktop/ece385git/lab4/8bit_processor/logic_processor_4bit {C:/Users/antho/Desktop/ece385git/lab4/8bit_processor/logic_processor_4bit/compute.sv}
vlog -sv -work work +incdir+C:/Users/antho/Desktop/ece385git/lab4/8bit_processor/logic_processor_4bit {C:/Users/antho/Desktop/ece385git/lab4/8bit_processor/logic_processor_4bit/Register_unit.sv}
vlog -sv -work work +incdir+C:/Users/antho/Desktop/ece385git/lab4/8bit_processor/logic_processor_4bit {C:/Users/antho/Desktop/ece385git/lab4/8bit_processor/logic_processor_4bit/Processor.sv}

vlog -sv -work work +incdir+C:/Users/antho/Desktop/ece385git/lab4/8bit_processor/logic_processor_4bit {C:/Users/antho/Desktop/ece385git/lab4/8bit_processor/logic_processor_4bit/testbench_8.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  testbench8

add wave *
view structure
view signals
run -all
