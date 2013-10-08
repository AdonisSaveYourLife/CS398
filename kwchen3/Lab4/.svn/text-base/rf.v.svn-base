`include "mux_lib.v"
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



module decoder2 (out, in, enable);
   input     in;
   input     enable;
   output [1:0] out;

   and a0(out[0], enable, ~in);
   and a1(out[1], enable, in);
endmodule // decoder2

module decoder4 (out, in, enable);
	input [1:0] in;
	input enable;
	output [3:0] out;
	wire [1:0] w_enable;
	decoder2 d0(w_enable,in[1],enable);
	decoder2 d1(out[1:0],in[0],w_enable[0]);
	decoder2 d2(out[3:2],in[0],w_enable[1]);
   
endmodule // decoder4

module decoder8 (out, in, enable);
	input [2:0] in;
	input enable;
	output [7:0]  out;
	wire [3:0] w_enable;
	decoder4 d4(w_enable, in[2:1],enable);
	decoder2 d20(out[1:0],in[0],w_enable[0]);
	decoder2 d21(out[3:2],in[0],w_enable[1]);
	decoder2 d22(out[5:4],in[0],w_enable[2]);
	decoder2 d23(out[7:6],in[0],w_enable[3]);

   // implement using decoder2's and decoder4's

endmodule // decoder8

module decoder16 (out, in, enable);
	input [3:0] in;
	input enable;
	output [15:0] out;
	wire [7:0] w_enable;
	decoder8 d8(w_enable,in[3:1],enable);
	decoder2 d20(out[1:0],in[0],w_enable[0]);
	decoder2 d21(out[3:2],in[0],w_enable[1]);
	decoder2 d22(out[5:4],in[0],w_enable[2]);
	decoder2 d23(out[7:6],in[0],w_enable[3]);
	decoder2 d24(out[9:8],in[0],w_enable[4]);
	decoder2 d25(out[11:10],in[0],w_enable[5]);
	decoder2 d26(out[13:12],in[0],w_enable[6]);
	decoder2 d27(out[15:14],in[0],w_enable[7]);


   // implement using decoder2's and decoder8's

endmodule // decoder16

module decoder32 (out, in, enable);
	input [4:0] in;
	input enable;
	output [31:0] out;
	wire [15:0] w_enable;
	decoder16 d16(w_enable,in[4:1],enable);
	decoder2 d20(out[1:0],in[0],w_enable[0]);
	decoder2 d21(out[3:2],in[0],w_enable[1]);
	decoder2 d22(out[5:4],in[0],w_enable[2]);
	decoder2 d23(out[7:6],in[0],w_enable[3]);
	decoder2 d24(out[9:8],in[0],w_enable[4]);
	decoder2 d25(out[11:10],in[0],w_enable[5]);
	decoder2 d26(out[13:12],in[0],w_enable[6]);
	decoder2 d27(out[15:14],in[0],w_enable[7]);
	decoder2 d28(out[17:16],in[0],w_enable[8]);
	decoder2 d29(out[19:18],in[0],w_enable[9]);
	decoder2 d210(out[21:20],in[0],w_enable[10]);
	decoder2 d211(out[23:22],in[0],w_enable[11]);
	decoder2 d212(out[25:24],in[0],w_enable[12]);
	decoder2 d213(out[27:26],in[0],w_enable[13]);
	decoder2 d214(out[29:28],in[0],w_enable[14]);
	decoder2 d215(out[31:30],in[0],w_enable[15]);





   // implement using decoder2's and decoder16's

endmodule // decoder32

module mips_regfile (rd1_data, rd2_data, rd1_regnum, rd2_regnum, 
		     wr_regnum, wr_data, writeenable, 
		     clock, reset);

	output [31:0] rd1_data, rd2_data;
	input [4:0] rd1_regnum, rd2_regnum, wr_regnum;
	input [31:0] wr_data;
	input writeenable, clock, reset;
	wire [31:0] reg_select;
	wire [31:0] reg0,reg1,reg2,reg3,reg4,reg5,reg6,reg7,reg8,reg9,reg10,reg11,reg12,reg13,reg14,reg15,reg16,
	reg17,reg18,reg19,reg20,reg21,reg22,reg23,reg24,reg25,reg26,reg27,reg28,reg29,reg30,reg31;


   // build a register file!
	decoder32 d32(reg_select,wr_regnum,writeenable);
	register r0(reg0,wr_data,clock,reg_select[0],1);
	register r1(reg1,wr_data,clock,reg_select[1],reset);
	register r2(reg2,wr_data,clock,reg_select[2],reset);
	register r3(reg3,wr_data,clock,reg_select[3],reset);
	register r4(reg4,wr_data,clock,reg_select[4],reset);
	register r5(reg5,wr_data,clock,reg_select[5],reset);
	register r6(reg6,wr_data,clock,reg_select[6],reset);
	register r7(reg7,wr_data,clock,reg_select[7],reset);
	register r8(reg8,wr_data,clock,reg_select[8],reset);
	register r9(reg9,wr_data,clock,reg_select[9],reset);
	register r10(reg10,wr_data,clock,reg_select[10],reset);
	register r11(reg11,wr_data,clock,reg_select[11],reset);
	register r12(reg12,wr_data,clock,reg_select[12],reset);
	register r13(reg13,wr_data,clock,reg_select[13],reset);
	register r14(reg14,wr_data,clock,reg_select[14],reset);
	register r15(reg15,wr_data,clock,reg_select[15],reset);
	register r16(reg16,wr_data,clock,reg_select[16],reset);
	register r17(reg17,wr_data,clock,reg_select[17],reset);
	register r18(reg18,wr_data,clock,reg_select[18],reset);
	register r19(reg19,wr_data,clock,reg_select[19],reset);
	register r20(reg20,wr_data,clock,reg_select[20],reset);
	register r21(reg21,wr_data,clock,reg_select[21],reset);
	register r22(reg22,wr_data,clock,reg_select[22],reset);
	register r23(reg23,wr_data,clock,reg_select[23],reset);
	register r24(reg24,wr_data,clock,reg_select[24],reset);
	register r25(reg25,wr_data,clock,reg_select[25],reset);
	register r26(reg26,wr_data,clock,reg_select[26],reset);
	register r27(reg27,wr_data,clock,reg_select[27],reset);
	register r28(reg28,wr_data,clock,reg_select[28],reset);
	register r29(reg29,wr_data,clock,reg_select[29],reset);
	register r30(reg30,wr_data,clock,reg_select[30],reset);
	register r31(reg31,wr_data,clock,reg_select[31],reset);
	mux32v m320(rd1_data,reg0,reg1,reg2,reg3,reg4,reg5,reg6,reg7,reg8,reg9,reg10,
		    reg11,reg12,reg13,reg14,reg15,reg16,reg17,reg18,reg19,reg20,reg21,
		    reg22,reg23,reg24,reg25,reg26,reg27,reg28,reg29,reg30,reg31,rd1_regnum);
	mux32v m321(rd2_data,reg0,reg1,reg2,reg3,reg4,reg5,reg6,reg7,reg8,reg9,reg10,
		    reg11,reg12,reg13,reg14,reg15,reg16,reg17,reg18,reg19,reg20,reg21,
		    reg22,reg23,reg24,reg25,reg26,reg27,reg28,reg29,reg30,reg31,rd2_regnum);		

	
	
   
endmodule // mips_regfile
// register: A register which may be reset to an arbirary value
//
// q      (output) - Current value of register
// d      (input)  - Next value of register
// clk    (input)  - Clock (positive edge-sensitive)
// enable (input)  - Load new value? (yes = 1, no = 0)
// reset  (input)  - Asynchronous reset    (reset = 1)
//
module register(q, d, clk, enable, reset);

   parameter
	    width = 32,
	    reset_value = 0;

   output [(width-1):0] q;
   reg [(width-1):0] 	q;
   input [(width-1):0] 	d;
   input 		clk, enable, reset;

   always@(reset)
     if (reset == 1'b1)
       q <= reset_value;

   always@(posedge clk)
     if ((reset == 1'b0) && (enable == 1'b1))
       q <= d;

endmodule // register


