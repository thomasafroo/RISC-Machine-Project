module ALU(Ain, Bin, ALUop, out, Z);
	input [15:0] Ain, Bin;
	input [1:0] ALUop;
	output [15:0] out;
	output Z;
	// fill out the rest
	
	// Z flag is 1 if out is zero
	assign Z = (out == 16'b0);

	reg [15:0] out;
	always_comb begin
		case (ALUop) 
			2'b00: out = Ain + Bin;
			2'b01: out = Ain - Bin;
			2'b10: out = Ain & Bin;
			2'b11: out = ~Bin;
			default: out = 16'b0;
		endcase
	end 
endmodule