module blackbox_test;
	reg y=0,l=0,d=0;
	initial begin
	$dumpfile("blackbox.vcd");
	$dumpvars(0,blackbox_test);
	#10 d=1;
	#10 l=1;d=0;
	#10 d=1;
	#10 y=1;l=0;d=0;
	#10 d=1;
	#10 l=1; d=0;
	#10 l=1; d=1;
	$finish;
end
wire e;
blackbox bb(e,y,l,d);
initial 
	$monitor("At time %t, y=%d l=%d d=%d e=%d", $time, y,l,d,e);
endmodule
