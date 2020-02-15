onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench8/Clk
add wave -noupdate /testbench8/Reset
add wave -noupdate /testbench8/LoadA
add wave -noupdate /testbench8/LoadB
add wave -noupdate /testbench8/Execute
add wave -noupdate /testbench8/Din
add wave -noupdate /testbench8/F
add wave -noupdate /testbench8/R
add wave -noupdate /testbench8/LED
add wave -noupdate /testbench8/Aval
add wave -noupdate /testbench8/Bval
add wave -noupdate /testbench8/AhexL
add wave -noupdate /testbench8/AhexU
add wave -noupdate /testbench8/BhexL
add wave -noupdate /testbench8/BhexU
add wave -noupdate /testbench8/ans_1a
add wave -noupdate /testbench8/ans_2b
add wave -noupdate /testbench8/ErrorCnt
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2687594 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {29392896 ps}
