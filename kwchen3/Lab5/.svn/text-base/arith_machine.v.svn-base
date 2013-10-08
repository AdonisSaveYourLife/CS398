
// mips_decode: a decoder for MIPS arithmetic instructions
//
// alu_op      (output) - control signal to be sent to the ALU
// writeenable (output) - should a new value be captured by the register file
// itype       (output) - should the ALU receive 1 reg. value and 1 immediate (1) or 2 reg values (0)
// except      (output) - set to 1 when 
// opcode       (input) - the opcode field from the instruction
// funct        (input) - the function field from the instruction
//

module mips_decode(alu_op, writeenable, itype, except, opcode, funct);
   output [2:0] alu_op;
   output 	writeenable, itype, except;
   input  [5:0] opcode, funct;
	wire add, sub, and_, or_, xor_, nor_, addi, andi, ori, xori; 
	assign writeenable=1;

	assign add=((opcode==6'h0)&(funct==6'h20));
	assign sub=((opcode==6'h0)&(funct==6'h22));
	assign and_=((opcode==6'h0)&(funct==6'h24));
	assign or_=((opcode==6'h0)&(funct==6'h25));
	assign xor_=((opcode==6'h0)&(funct==6'h26));
	assign nor_=((opcode==6'h0)&(funct==6'h27));
	assign addi=(opcode==6'h08);
	assign andi=(opcode==6'h0c);
	assign ori=(opcode==6'h0d);
	assign xori=(opcode==6'h0e);
	assign itype=(addi|andi|ori|xori);
	assign except = ~(add|sub|and_|or_|xor_|nor_|addi|andi|ori|xori);
	assign alu_op[0] = (sub|or_|xor_|ori|xori);
	assign alu_op[1] = (add|sub|xor_|nor_|addi|xori);
	assign alu_op[2] = (and_|or_|xor_|nor_|andi|ori|xori);

	

endmodule // mips_decode

// arith_machine: execute a series of arithmetic instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.`
// clk     (input) - the clock signal
// reset   (input) - set to 1 to set all registers to zero, set to 0 for normal execution.

module arith_machine(except, clk, reset);
   output 	except;
   input        clk, reset;

   wire [31:0] 	inst;  
   wire [31:0] 	PC,nextPC,rdData;  
	wire of,z,n,overflow,zero,negative;
	wire  writeenable, itype;
	wire [2:0] alu_op;
	wire [31:0] rsData,rtData,imm,B;
	wire[4:0] Rdest;


   register #(32) PC_reg( PC,nextPC,clk,1,reset);//pc register
	alu32 add4(nextPC,of,z,n,PC, 32'h4,010);//pc +4
	instruction_memory instMem(PC[31:2],inst);//instruction memory
	mips_decode decoder(alu_op,writeenable, itype, except, inst[31:26], inst[5:0]);//mips decoder
	sign_extender sign(imm,inst[15:0]);//sign extender
	mux2v #(5) m0(Rdest, inst[15:11],inst[20:16], itype);// 1st mux
	mux2v #(32) m1(B,rtData,imm,itype); //2nd mux


   regfile rf (inst[25:21],inst[20:16],Rdest,rsData,rtData,rdData,writeenable,clk,reset );

	alu32 #(32) alu(rdData,overflow,zero,negative,rsData,B,alu_op);

   /* add other modules */
   
endmodule // arith_machine

module sign_extender(out, in);
	output [31:0] out;
	input [15:0] in;
	assign out[15:0]=in[15:0];
	assign out[16]=in[15];
	assign out[17]=in[15];
	assign out[18]=in[15];
	assign out[19]=in[15];
	assign out[20]=in[15];
	assign out[21]=in[15];
	assign out[22]=in[15];
	assign out[23]=in[15];
	assign out[24]=in[15];
	assign out[25]=in[15];
	assign out[26]=in[15];
	assign out[27]=in[15];
	assign out[28]=in[15];
	assign out[29]=in[15];
	assign out[30]=in[15];
	assign out[31]=in[15];


endmodule
