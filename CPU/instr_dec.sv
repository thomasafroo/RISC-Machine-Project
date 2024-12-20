module instr_dec(IR, nsel, op, opcode, ALUop, sximm5, sximm8, shift, readnum, writenum);
	input [15:0] IR;
	input [2:0] nsel;
	output [2:0] writenum, readnum, opcode;
	output [1:0] ALUop, shift, op;
	output [15:0] sximm5, sximm8;
	reg [1:0] ALUop, shift;

	// To FSM Controller
	assign opcode = IR[15:13];
	assign op = IR[12:11];

	// To Datapath
	always_comb begin
		case(opcode)
			3'b110: begin
				ALUop = 00;
				case(op)
					2'b10: begin
					shift = 00;
				end
				default: begin
					shift = IR [4:3];
				end
			endcase
		end
		3'b101: begin
			shift = IR [4:3];
			ALUop = op;
		end
		default: begin
				shift = 00;
				ALUop = 00;
			end
	endcase
	end
	assign sximm5 = {{11{IR[4]}}, IR[4:0]};
	assign sximm8 = {{8{IR[7]}}, IR[7:0]};
	// Three registers
	wire [2:0] Rn, Rd, Rm;
	assign Rn = IR[10:8];
	assign Rd = IR[7:5];
	assign Rm = IR[2:0];

	reg [2:0] readnum, writenum;
	// Multiplexer for reading/writing
	always_comb begin
		case (nsel) // From FSM Controller
			3'b001: readnum = IR[10:8]; // Rn
			3'b010: readnum = IR[7:5]; // Rd 
			3'b100: readnum = IR[2:0]; // Rm
			default: readnum = 3'bx; 
		endcase
		writenum = readnum;
	end 
endmodule: instr_dec