module datapath (
	input clk,
	input [2:0] readnum,
	input vsel, loada, loadb,
	input [1:0] shift,
	input asel, bsel,
	input [1:0] ALUop,
	input loadc, loads,
	input [2:0] writenum,
	input write,
	input [15:0] datapath_in,
	output Z_out,
	output [15:0] datapath_out
	);

	// Internal signals
	reg [15:0] data_in, data_out, A, in, sout, Ain, Bin, out, C;
	

	// Multiplexer for datapath_in
	always_comb begin
		if (vsel) 
			data_in = datapath_in;
		else 
			data_in = datapath_out;
	end

	// Instantiate the register file
	regfile REGFILE(
			.data_in(data_in),
			.writenum(writenum),
			.write(write),
			.readnum(readnum),
			.clk(clk),
			.data_out(data_out)
	);

	// register A with load enable
	vDFFE rA(.clk(clk), .load(loada), .in(data_out), .out(A));

	// register B with load enable
	vDFFE rB(.clk(clk), .load(loadb), .in(data_out), .out(in));

	// Multiplexer for Ain
	always_comb begin
		case (asel)
			1'b1: Ain = 16'b0;
			default: Ain = A;
		endcase
	end
	
	// Instantiate the shifter
	shifter sft(
		.in(in), 
		.shift(shift), 
		.sout(sout)
	);

	// Multiplexer for Bin
	always_comb begin
		case (bsel)
			1'b1: Bin = {11'b0, datapath_in[4:0]};
			default: Bin = sout;
		endcase
	end
	
	// Instantiate the ALU
	ALU alu(
		.Ain(Ain),
		.Bin(Bin),
		.ALUop(ALUop),
		.out(out),
		.Z(Z)
	);

	// register C with load enable
	vDFFE rC(.clk(clk), .load(loadc), .in(out), .out(C));

	// 
	vDFFE status(.clk(clk), .load(loads), .in(Z), .out(Z_out));
	
	// datapath output
	assign datapath_out = C;

endmodule 