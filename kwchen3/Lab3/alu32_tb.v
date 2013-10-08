`include "alu32.v"
module alu32_test;

	reg [31:0] A=32'd5;
	reg [31:0] B=32'd10;


  wire [31:0] out;
  wire overflow, zero, negative;

reg [2:0] control = 3'd0;
   
   initial begin
      $dumpfile("test32.vcd");
      $dumpvars(0,alu32_test);
      
      	# 2 control = 3'd1;
      	# 2 control = 3'd2;
	A=32'h7FFFFFFF; B=32'h7FFFFFFF; //addition overflow
      	# 2 control = 3'd3;	
	A=32'd5;B=32'd10;
	A=32'h7FFFFFFF; B=32'hFFFFFFFF; //subtraction overflow
      	# 2 control = 3'd4;
	A=32'h00000000; B=32'h00000000;
	#2 A=32'hFFFFFFFF;
	#2 A=32'h00000000; B=32'hFFFFFFFF;
	#2 A=32'hFFFFFFFF;
      	# 2 control = 3'd5;
	A=32'h00000000; B=32'h00000000;
	#2 A=32'hFFFFFFFF;
	#2 A=32'h00000000; B=32'hFFFFFFFF;
	#2 A=32'hFFFFFFFF;
      	# 2 control = 3'd6;
	A=32'h00000000; B=32'h00000000;
	#2 A=32'hFFFFFFFF;
	#2 A=32'h00000000; B=32'hFFFFFFFF;
	#2 A=32'hFFFFFFFF;
      	# 2 control = 3'd7;
	A=32'h00000000; B=32'h00000000;
	#2 A=32'hFFFFFFFF;
	#2 A=32'h00000000; B=32'hFFFFFFFF;
	#2 A=32'hFFFFFFFF;
      # 2 $finish;
   end

  alu32 a (out, overflow, zero, negative, A, B, control);	
endmodule // test
