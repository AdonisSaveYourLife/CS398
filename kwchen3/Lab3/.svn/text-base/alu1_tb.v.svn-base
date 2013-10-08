// this command means that you don't have to put alu32.v on the command line.
`include "alu32.v"

module alu1_test;

   // if you consider the [c, b, a] to be a 3 bit number, the following code
   // repeatedly counts from 0 to 7, changing every time unit.  This is useful
   // because you can quickly see how the output varies for each combination
   // of data inputs for each control input.
   reg A = 0;
   always #1 A = !A;
   reg B = 0;
   always #2 B = !B;
   reg C = 0;
   always #4 C = !C;
   
   reg [2:0] control = 3'd0;
   
   initial begin
      $dumpfile("test.vcd");
      $dumpvars(0,alu1_test);
      
      # 8 control = 3'd1;
      # 8 control = 3'd2;
      # 8 control = 3'd3;
      # 8 control = 3'd4;
      # 8 control = 3'd5;
      # 8 control = 3'd6;
      # 8 control = 3'd7;
      # 8 $finish;
   end
   
   wire out, carryout;
   alu1 a (out, carryout, A, B, C, control);	
   
endmodule // alu1_test
