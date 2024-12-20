module datapath (
	input [1:0] vsel,
	input [15:0] mdata,
	input [15:0] sximm8,
	input [8:0] PC,
	input [2:0] writenum,
	input write,
	input [2:0] readnum,
	input clk,
	input loada, loadb,
	input [1:0] shift,
	input [15:0] sximm5,
	input asel, bsel,
	input [1:0] ALUop,
	input loadc, loads,
	output Z_out,
	output N_out,
	output V_out,
	output [15:0] datapath_out
	);

	// internal signals
	reg [15:0] data_in, data_out, A, in, sout, Ain, Bin, out, C;
	wire Z, V, N;

	// multiplexer Input to Register File
	always_comb begin
		case(vsel)
			4'b00: data_in = mdata;
			4'b01: data_in = sximm8;
			4'b10: data_in = {8'b0, PC};
			4'b11: data_in = C;
			default: data_in = 16'bx;
		endcase
	end

	// instantiate the register file
	regfile REGFILE(
			.data_in(data_in),
			.writenum(writenum),
			.write(write),
			.readnum(readnum),
			.clk(clk),
			.data_out(data_out)
	);

	// register A 
	vDFFE rA(.clk(clk), .load(loada), .in(data_out), .out(A));

	// register B 
	vDFFE rB(.clk(clk), .load(loadb), .in(data_out), .out(in));

	// Ain multiplexer
	always_comb begin
        if (asel) 
            Ain = 16'b0; // if asel is high, output is 16'b0
        else
            Ain = A; // if asel is low, output is the value of A
	end
	
	// instantiate the shifter
	shifter sft(
		.in(in), 
		.shift(shift), 
		.sout(sout)
	);

	// Bin multiplexer
	always_comb begin
		if (bsel)
			Bin = sximm5;
		else 
			Bin = sout;
	end
	
	// instantiate the ALU
	ALU alu(
		.Ain(Ain),
		.Bin(Bin),
		.ALUop(ALUop),
		.out(out),
		.Z(Z),
		.V(V),
		.N(N)
	);

	// register C 
	vDFFE rC(.clk(clk), .load(loadc), .in(out), .out(C));

	// status flag for Z, V, N
	reg [2:0] status;
	assign Z_out = status[2];
	assign V_out = status[1];
	assign N_out = status[0];
	always_ff @(posedge clk) begin
		if (loads)
			status <= {Z,V,N};
	end
	
	// datapath output
	assign datapath_out = C;

endmodule: datapath