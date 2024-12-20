`define MNONE 2'b00
`define MREAD 2'b01
`define MWRITE 2'b10 
module cpu(clk,reset,read_data,mem_cmd,mem_addr,write_data,N,V,Z);
	input clk, reset;
	input [15:0] read_data;
	output reg [1:0] mem_cmd;
	output reg [15:0] write_data;
	output reg [8:0] mem_addr;
	output reg N, V, Z;
	reg [15:0] IR;
	reg loada, loadb, loadc, loads, asel, bsel, write;
	reg [2:0] readnum, writenum;
	reg [1:0] ALUop, shift, vsel;
	reg [2:0] opcode, nsel;
	reg [1:0] op;
	reg [15:0] sximm5, sximm8, mdata;
	reg load_ir, load_pc, reset_pc, load_addr, addr_sel;
	reg [8:0] next_pc;
	reg [8:0] PC;

	// Instruction Register
	vDFFE instr_register(clk, load_ir, read_data, IR);

	// next_pc multiplexer
	always_comb begin
		if (reset_pc)
			next_pc = 9'b0;
		else 
			next_pc = PC + 1'b1;
	end

	// Program Counter
	vDFFE program_counter(clk, load_pc, next_pc, PC);

	// Data Address
	reg [8:0] data_address_out;
	vDFFE data_address(clk, load_addr, write_data[8:0], data_address_out);

	// mem_addr multiplexer
	always_comb begin
		if (addr_sel)
			mem_addr = PC;
		else 
			mem_addr = data_address_out;
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
	fsm_controller controller(
		.reset(reset),
		.vsel(vsel), 
		.load_ir(load_ir),
		.mem_cmd(mem_cmd),
		.addr_sel(addr_sel),
		.load_pc(load_pc),
		.reset_pc(reset_pc),
		.load_addr(load_addr),
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
		.op(op)
	);


	// Datapath 
	datapath DP(
        .vsel(vsel),
        .mdata(read_data),
        .sximm8(sximm8), 
        .PC(8'b0), // for lab 7 bonus, this will be changed
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
        .datapath_out(write_data)
  );

endmodule: cpu
