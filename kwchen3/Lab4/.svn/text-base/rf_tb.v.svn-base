`include "rf.v"
module test;
   reg       clk = 0, enable = 0, reset = 1;  // start by reseting the register file

   /* Make a regular pulsing clock with a 10 time unit period. */
   always #5 clk = !clk;

   reg [4:0]    wr_regnum = 0, rd1_regnum = 0, rd2_regnum = 0;
   reg [31:0]   wr_data = 0;
   wire [31:0]  rd1_data, rd2_data;
   
   initial begin
      $dumpfile("rf.vcd");
      $dumpvars(0, test);
	assign wr_data=32'hFFFFFFFF;
      #15  reset = 0;      // stop reseting the RF
	#10 wr_regnum=5'b00100;enable=0;
	#10 rd1_regnum = 5'b00100;
	#10
	#10 enable=1;
	#10
	#10 reset=1;
      # 700 $finish;
   end
   
   initial begin
   end

   mips_regfile rf (rd1_data, rd2_data, rd1_regnum, rd2_regnum, wr_regnum, wr_data, enable, clk, reset);
initial
     $monitor("At time%t, write data= %d, write reg = %d, read reg1 = %d, read reg2= = %d, read data1=%d, read data2=%d, enable=%d, reset=%d",$time, wr_data, wr_regnum, rd1_regnum,rd2_regnum,rd1_data,rd2_data,enable,reset);

   
endmodule // test
