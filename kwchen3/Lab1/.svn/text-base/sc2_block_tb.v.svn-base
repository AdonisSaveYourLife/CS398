module test;
	reg a=0, b=0, cin=0;
	initial begin
	
		$dumpfile("sc2.vcd");
		$dumpvars(0,test);
		
		#10 cin=1;
		#10 cin=0;b=1;
		#10 cin=1;
		#10 a=1;b=0;cin=0;
		#10 cin=1;
		#10 cin=0; b=1;
		#10 cin=1;
		#10
		$finish;
	end
	wire s,cout;
	sc2_block sc2 (s,cout,a,b,cin);
	initial 
		$monitor("At time %t, a=%d b=%d cin=%d s=%d cout=%d", $time, a,b,cin,s,cout);
	


endmodule // test
