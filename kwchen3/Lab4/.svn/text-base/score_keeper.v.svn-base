// dffe: D-type flip-flop with enable
//
// q      (output) - Current value of flip flop
// d      (input)  - Next value of flip flop
// clk    (input)  - Clock (positive edge-sensitive)
// enable (input)  - Load new value? (yes = 1, no = 0)
// reset  (input)  - Asynchronous reset   (reset =  1)
//
module dffe(q, d, clk, enable, reset);
   output q;
   reg    q;
   input  d;
   input  clk, enable, reset;

   always@(reset)
     if (reset == 1'b1)
       q <= 0;

   always@(posedge clk)
     if ((reset == 1'b0) && (enable == 1'b1))
       q <= d;
endmodule // dffe


module score_keeper(winner_x, winner_y, reset, x, y, clk);
	output 	winner_x, winner_y;
	input 	reset, x, y, clk;
	wire A,B,C,D,E;
	wire nextA, nextB, nextC, nextD,nextE;
	assign nextA= (A&(~reset)&(~x)&(~y)) | (reset&(~x)&(~y)) | ( C&(~reset)&x&(~y)) | (B&(~reset)&(~x)&y);
	assign nextB= (B&(~reset)&(~x)&(~y)) | (A&(~reset)&x&~(y));
	assign nextC= (C&(~reset)&(~x)&(~y)) | (A&(~reset)&(~x)&y);
	assign nextD= (D&(~reset)&(~x)&(~y)) | (B&(~reset)&x&(~y)) | (D&(~reset)&x&(~y)) | (D&(~reset)&(~x)&y);
	assign nextE= (E&(~reset)&(~x)&(~y)) | (C&(~reset)&(~x)&y) | (E&(~reset)&x&(~y)) | (E&(~reset)&(~x)&y); 
	dffe d0(A,nextA,clk,1,0); //State A - tied (0,0)
	dffe d1(B,nextB,clk,1,0); //State B	- x winning (1,0)
	dffe d2(C,nextC,clk,1,0); //State C - y winning (0,1)
	dffe d3(D,nextD,clk,1,0); //State D	- x wins (2,0)
	dffe d4(E,nextE,clk,1,0); //State E - y wins (0,2)
	assign winner_x=D;
	assign winner_y=E;
	
endmodule // score_keeper
