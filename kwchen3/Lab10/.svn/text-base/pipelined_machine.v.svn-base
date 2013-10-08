module pipelined_machine(clk, reset);
   input        clk, reset;

   wire [31:0] 	PC;
   wire [31:2]  next_PC, PC_plus4, PC_target;
   wire [31:0] 	inst;
   
   wire [31:0] 	imm = {{ 16{inst[15]} }, inst[15:0] };  // sign-extended immediate
   wire [4:0] 	rs = inst[25:21];
   wire [4:0] 	rt = inst[20:16];
   wire [4:0] 	rd = inst[15:11];
   wire [5:0] 	opcode = inst[31:26];
   wire [5:0] 	funct = inst[5:0];

   wire [4:0] 	wr_regnum;
   wire [2:0] 	ALUOp;

   wire 	RegWrite, BEQ, ALUSrc, MemRead, MemWrite, MemToReg, RegDst;
   wire         PCSrc, zero;
   wire [31:0] 	rd1_data, rd2_data, B_data, alu_out_data, load_data, wr_data;


   register #(30, 30'h100000) PC_reg(PC[31:2], next_PC[31:2], clk, /* enable */1'b1, reset);

	
   assign PC[1:0] = 2'b0;  // bottom bits hard coded to 00
   adder30 next_PC_adder(PC_plus4, PC[31:2], 30'h1);
   adder30 target_PC_adder(PC_target, PC_plus4_ex, imm_ex[29:0]);
   mux2v #(30) branch_mux(next_PC, PC_plus4, PC_target, PCSrc);
   assign PCSrc = BEQ & zero;
      
   instruction_memory imem (PC[31:2], inst);

   mips_decode decode(ALUOp, RegWrite, BEQ, ALUSrc, MemRead, MemWrite, MemToReg, RegDst, 
		      opcode_ex, funct_ex);
   
   regfile rf (rs, rt, wr_regnum, 
               rd1_data, rd2_data, wr_data, 
               RegWrite, clk, reset);

   mux2v #(32) imm_mux(B_data, rt_select, imm_ex, ALUSrc);
   alu32 alu(alu_out_data, zero, ALUOp, rs_select, B_data);
   
   data_mem data_memory(load_data, alu_out_data, rt_select, MemRead, MemWrite, clk, reset);
   
   mux2v #(32) wb_mux(wr_data, alu_out_data, load_data, MemToReg);
   mux2v #(5) rd_mux(wr_regnum, rt_ex, rd_ex, RegDst);


	wire flush;
	assign flush=PCSrc||reset;
	wire [5:0] opcode_ex,funct_ex;
	wire [31:2] PC_plus4_ex;
	wire [31:0] rd1_data_ex,rd2_data_ex,imm_ex;
	wire [4:0] rt_ex,rd_ex,rs_ex;
	wire forwardA,forwardB;
	wire [31:0] rs_select,rt_select;
	wire RegWrite_ex;
	wire [31:0] wr_data_ex;
	wire [4:0] wr_regnum_ex;

	register #(30) pc4_pipeReg(PC_plus4_ex,PC_plus4,clk,1'b1,flush);
	register #(6) opcode_pipeReg(opcode_ex,inst[31:26],clk,1'b1,flush);
	register #(6) function_pipeReg(funct_ex,inst[5:0],clk,1'b1,flush);
	register #(32) rdata1_pipeReg(rd1_data_ex,rd1_data,clk,1'b1,flush);
	register #(32) rdata2_pipeReg(rd2_data_ex,rd2_data,clk,1'b1,flush);
	register #(32) extended_pipeReg(imm_ex,imm,clk,1'b1,flush);
	register #(5) rt_pipeReg(rt_ex,rt,clk,1'b1,flush);
	register #(5) rd_pipeReg(rd_ex,rd,clk,1'b1,flush);
	register #(5) rs_pipeReg(rs_ex,rs,clk,1'b1,flush);

	register #(1) wr_enable_forward(RegWrite_ex,RegWrite,clk,1'b1,reset);
	register #(32) wr_data_forward(wr_data_ex,wr_data,clk,1'b1,reset);
	register #(5) wr_regnum_forward(wr_regnum_ex,wr_regnum,clk,1'b1,reset);

	mux2v #(32) forwardA_mux(rs_select,rd1_data_ex,wr_data_ex,forwardA);
	mux2v #(32) forwardB_mux(rt_select,rd2_data_ex,wr_data_ex,forwardB);
	
	wire test;

	assign forwardA=(rs_ex==wr_regnum_ex)&&RegWrite_ex;
	assign forwardB=(rt_ex==wr_regnum_ex)&&RegWrite_ex;

endmodule // pipelined_machine


