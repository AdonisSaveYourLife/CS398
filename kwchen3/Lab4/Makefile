all: keypad score_keeper rf

keypad: kp.vcd

keypad_exe: keypad.v keypad_tb.v
	iverilog -o keypad_exe -Wall keypad.v keypad_tb.v

kp.vcd: keypad_exe
	./keypad_exe

score_keeper: sk.vcd

score_keeper_exe: score_keeper.v score_keeper_tb.v 
	iverilog -o score_keeper_exe -Wall score_keeper.v score_keeper_tb.v 

sk.vcd: score_keeper_exe
	./score_keeper_exe


rf: rf.vcd

rf_exe: rf.v rf_tb.v 
	iverilog -o rf_exe -Wall rf.v rf_tb.v 

rf.vcd: rf_exe
	./rf_exe
