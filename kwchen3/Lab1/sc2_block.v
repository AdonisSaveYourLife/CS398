// Complete the sc2_block module in this file
// Don't put any code in this file besides the sc2_block

module sc2_block(s, cout, a, b, cin);
	output s,cout;
	input a,b,cin;
	wire w1,w2;
	sc_block block1(w1,w2,a,b);
	wire w4;
	sc_block block2(s,w4,w1,cin);
	or o1(cout,w4,w2);
endmodule
