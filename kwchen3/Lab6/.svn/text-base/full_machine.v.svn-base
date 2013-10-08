// mips_decode: a decoder for MIPS arithmetic instructions
//
// alu_op      (output) - control signal to be sent to the ALU
// writeenable (output) - should a new value be captured by the register file
// itype       (output) - should the ALU receive 1 reg. value and 1 immediate (1) or 2 reg values (0)
// except      (output) - set to 1 when we don't recognize an opdcode & funct combination
// control_type[1:0] (output) - 00 = fallthrough, 01 = branch_target, 10 = jump_target, 11 = jump_register 
// mem_read    (output) - the register value written is coming from the memory
// word_we     (output) - we're writing a word's worth of data
// byte_we     (output) - we're only writing a byte's worth of data
// byte_load   (output) - we're doing a byte load
// lui         (output) - the instruction is a lui
// slt         (output) - the instruction is an slt
// opcode       (input) - the opcode field from the instruction
// funct        (input) - the function field from the instruction
// zero         (input) - from the ALU
//

module mips_decode(alu_op, writeenable, itype, except, control_type,
		   mem_read, word_we, byte_we, byte_load, lui, slt, 
		   opcode, funct, zero);
   output [2:0] alu_op;
   output 	writeenable, itype, except;
   output [1:0] control_type;
   output 	mem_read, word_we, byte_we, byte_load, lui, slt;
   input  [5:0] opcode, funct;
   input 	zero;
	wire add, sub, and_, or_, xor_ ,nor_, addi, andi, ori, xori;
	wire beq,bne,j,jr,lw,lbu,sw,sb;

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

	assign beq=(opcode==6'h04);
	assign bne=(opcode==6'h05);
	assign j=(opcode==6'h02);
	assign jr=(opcode==6'h0&funct==6'h08);
	assign lui=(opcode==6'h0f);
	assign slt=(opcode==6'h0&funct==6'h2a);
	assign lw=(opcode==6'h23);
	assign lbu=(opcode==6'h24);
	assign sw=(opcode==6'h2b);
	assign sb=(opcode==6'h28);

	assign writeenable=(add|sub|and_|or_|xor_|nor_|addi|andi|ori|xori|lui|slt|lw|lbu);
	assign control_type[0]=((beq&zero)|(bne&~zero)|jr);
	assign control_type[1]=(j|jr);
	assign mem_read=(lw|lbu);
	assign word_we=sw;
	assign byte_we=sb;
	assign byte_load=lbu;

	assign itype=(addi|andi|ori|xori|lui|lw|lbu|sw|sb);
	assign except = ~(add|sub|and_|or_|xor_|nor_|addi|andi|ori|xori|beq|bne|j|jr|lui|slt|lw|lbu|sw|sb);
	assign alu_op[0] = (sub|or_|xor_|ori|xori|beq|bne|slt);
	assign alu_op[1] = (add|sub|xor_|nor_|addi|xori|beq|bne|slt|lw|lbu|sw|sb);
	assign alu_op[2] = (and_|or_|xor_|nor_|andi|ori|xori);


endmodule // mips_decode


// full_machine: execute a series of MIPS instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.
// clk     (input) - the clock signal
// reset   (input) - set to 1 to set all registers to zero, set to 0 for normal execution.

module full_machine(except, clk, reset);
   output 	except;
   input        clk, reset;

   	wire [31:0] 	inst;  
   	wire [31:0] 	PC, nextPC,branchAdd,branchOffset,jump,PCAdd;  
	wire [31:0] 	rsData,rtData,rdData,luiIn,memRead,byteRead,sltRead,dataOut,dataMux,imm,B,neg;
	wire z,n,of;//uneccesary wires from offset and +4 alus
	wire overflow,zero,negative;
	wire [31:0] zeroBus,out;  
	wire [1:0] control_type;
	wire [2:0] alu_op;
	wire [4:0] Rdest;
	wire writeenable,itype,mem_read,word_we,byte_load,lui,slt,byte_we;

 	
	register #(32) PC_reg( PC,nextPC,clk,1,reset);//pc register
	alu32 add4(PCAdd,of,z,n,PC, 32'h4,010);//pc +4
	alu32 addOffset(branchAdd,of,z,n,PCAdd,branchOffset,010);
	assign jump[31:28]=PC[31:28];
	assign jump[27:2]=inst[25:0];
	assign jump[0]=0;
	assign jump[1]=0;
	assign jumpReg=rsData;
	assign luiIn[31:16]=inst[15:0];
	assign luiIn[15:0]=zeroBus[15:0];

	assign dataMux[31:8]=zeroBus[31:8];

	assign neg[0]=negative;
	assign neg[31:1]=zeroBus[31:1];
	mux2v #(32) lMux(rdData,memRead,luiIn,lui);
	mux2v #(32) mMux(memRead,sltRead,byteRead,mem_read);
	mux2v #(32) bMux(byteRead,dataOut,dataMux,byte_load);
	mux2v #(32) sMux(sltRead,out,neg,slt);
	mux4v #(32) pcselect(nextPC, PCAdd, branchAdd, jump, rsData, control_type);
	mux4v #(8) dMux(dataMux[7:0],dataOut[7:0],dataOut[15:8],dataOut[23:16],dataOut[31:24],out[1:0]);
	
		
	mips_decode decoder(alu_op,writeenable,itype,except,control_type,mem_read,word_we,byte_we,byte_load,lui,slt,inst[31:26], inst[5:0],zero);

   	regfile rf (inst[25:21],inst[20:16],Rdest,rsData,rtData,rdData,writeenable,clk,reset);
	data_mem datamem(dataOut, out, rtData, word_we, byte_we, clk, reset);
	


	instruction_memory instMem(PC[31:2],inst);//instruction memory
	//mips_decode decoder(alu_op,writeenable, itype, except, inst[31:26], inst[5:0]);//mips decoder

	sign_extender sign(imm,inst[15:0]);//sign extender
	shift_left lShift(branchOffset,imm[29:0]);
	mux2v #(5) m0(Rdest, inst[15:11],inst[20:16], itype);// 1st mux
	mux2v #(32) m1(B,rtData,imm,itype); //2nd mux

	alu32 #(32) alu(out,overflow,zero,negative,rsData,B,alu_op);

	assign zeroBus[31]=0;
	assign zeroBus[30]=0;
	assign zeroBus[29]=0;
	assign zeroBus[28]=0;
	assign zeroBus[27]=0;
	assign zeroBus[26]=0;
	assign zeroBus[25]=0;
	assign zeroBus[24]=0;
	assign zeroBus[23]=0;
	assign zeroBus[22]=0;
	assign zeroBus[21]=0;
	assign zeroBus[20]=0;
	assign zeroBus[19]=0;
	assign zeroBus[18]=0;
	assign zeroBus[17]=0;
	assign zeroBus[16]=0;
	assign zeroBus[15]=0;
	assign zeroBus[14]=0;
	assign zeroBus[13]=0;
	assign zeroBus[12]=0;
	assign zeroBus[11]=0;
	assign zeroBus[10]=0;
	assign zeroBus[9]=0;
	assign zeroBus[8]=0;
	assign zeroBus[7]=0;
	assign zeroBus[6]=0;
	assign zeroBus[5]=0;
	assign zeroBus[4]=0;
	assign zeroBus[3]=0;
	assign zeroBus[2]=0;	
	assign zeroBus[1]=0;
	assign zeroBus[0]=0;

   /* add other modules */

endmodule // full_machine

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

module shift_left(out,in);
	output [31:0] out;
	input [29:0] in;
	assign out[31:2]=in[29:0];
	assign out[1]=0;
	assign out[0]=0;	
endmodule
