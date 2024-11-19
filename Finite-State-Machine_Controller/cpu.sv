`define WAIT 3'b000
`define DECODE 3'b001
`define WRITE_IMM 3'b010
`define LOAD_A 3'b011
`define LOAD_B 3'b100
`define LOAD_C 3'b101
`define WRITE_OUT 3'b110

module cpu(clk,reset,s,load,in,out,N,V,Z,w);
	input clk, reset, s, load;
	input [15:0] in;
	output reg [15:0] out;
	output reg N, V, Z, w;
	reg [15:0] IR;
	reg loada, loadb, loadc, loads, asel, bsel, write;
	reg [2:0] readnum, writenum;
	reg [1:0] ALUop, shift, vsel;
	reg [2:0] opcode, nsel;
	reg [1:0] op;
	reg [15:0] sximm5, sximm8;


	// Instruction Register
	always_ff @(posedge clk) begin
		if (load) begin
			IR <= in;
		end
	end
	
	// Instruction Decoder
	instr_dec instruction_decoder(
		.IR(IR),
		.nsel(nsel),
		.op(op),
		.opcode(opcode),
		.ALUop(ALUop),
		.sximm5(sximm5),
		.sximm8(sximm8),
		.shift(shift),
		.readnum(readnum),
		.writenum(writenum)
	);

	// Finite State Machine Controller
	reg [2:0] present_state;
	fsm_controller controller(
		.reset(reset),
		.vsel(vsel), 
		.write(write), 
		.clk(clk), 
		.loada(loada), 
		.loadb(loadb), 
		.asel(asel), 
		.bsel(bsel), 
		.loadc(loadc), 
		.loads(loads),
		.nsel(nsel),
		.opcode(opcode), 
		.op(op), 
		.s(s),
		.w(w)
	);


	// Datapath 
	datapath DP(
        .vsel(vsel),
        .mdata(16'b0),
        .sximm8(sximm8), 
        .PC(8'b0),
        .writenum(writenum), 
        .write(write),
        .readnum(readnum),
		.clk(clk),
        .loada(loada),
        .loadb(loadb),
        .shift(shift), 
        .sximm5(sximm5), 
        .asel(asel),
        .bsel(bsel),
        .ALUop(ALUop), 
        .loadc(loadc),
        .loads(loads),
        .Z_out(Z),
		.V_out(V),
		.N_out(N),
        .datapath_out(out)
  );

endmodule: cpu