`include "score_keeper.v"
module score_keeper_test;

   reg x = 0, y = 0, reset = 1;
   reg clk = 0;
   always #5 clk = !clk;
   
   initial begin

      $dumpfile("sk.vcd");  
      $dumpvars(0, score_keeper_test);
      
	# 12
	reset = 0;
	# 10
	x=1;y=0;//(1,0)
	#10
	x=0;y=0;//(1,0)
	#10
	y=1;x=0;//(1,1)->(0,0)
	#10
	y=0;x=0;//(0,0)
	#10
	x=1;y=0;//(1,0)
	#10
	x=1;y=0;//(2,0)
	#10
	x=1;y=0;//(2,0);
	#10
	x=0;y=1;//(2,0);
	#10
	reset=1;x=0;y=0;//(0,0)
	#10
	reset=0;y=1;x=0;//(0,1)
	#10
	x=1;y=0;//(1,1)->(0,0)
	#10
	y=1;x=0;//(0,1)
	#10
	y=1;x=0;//(0,2)
	#10
	x=1;y=0;//(0,2)
	#10
	y=1;x=0;//(0,2)
	#10
	reset=1;y=0;x=0;//(0,0)
	#10
	
	

	// put your tests here!!
      
      $finish;              // end the simulation
   end                      
   
   wire winner_x, winner_y;
   score_keeper sk(winner_x, winner_y, reset, x, y, clk);

   wire [1:0] winner = {{winner_x, winner_y}};  // concatenate signals into a bus
   
   initial
     $monitor("At time %t, winner = %x, x = %d, y = %d, reset = %x",
              $time, winner, x, y, reset);
endmodule // keypad_test
