`define RST 4'b0000
`define IF1 4'b0001
`define IF2 4'b0010
`define UpdatePC 4'b0011
`define DECODE 4'b0100
`define WRITE_IMM 4'b0101
`define LOAD_A 4'b0110
`define LOAD_B 4'b0111
`define LOAD_C 4'b1000
`define WRITE_OUT 4'b1001
`define LOAD_ADR 4'b1010
`define LOAD_A2 4'b1011
`define LOAD_C2 4'b1100
`define HALT 4'b1101
`define MNONE 2'b00 // no operation
`define MREAD 2'b01 // read operation 
`define MWRITE 2'b10 // write operation
module fsm_controller(reset, load_ir, mem_cmd, addr_sel, load_pc, reset_pc, load_addr, vsel, write, clk, loada, loadb, asel, bsel, loadc, loads, nsel, opcode, op);
	input clk, reset;
	input [2:0] opcode;
	input [1:0] op;
	output reg [1:0] vsel;
	output reg [2:0] nsel;
	output reg loada, loadb, asel, bsel, loadc, loads, write;
	output reg load_ir, addr_sel, load_pc, reset_pc, load_addr;
	output reg [1:0] mem_cmd;
	// present state
	reg [3:0] present_state;

	always @(posedge clk) begin
		if (reset) 
			present_state <= `RST; 
		else begin
			case (present_state) 
				`RST: present_state <= `IF1;
				`IF1: begin
					case(opcode)
						3'b111: present_state <= `HALT;
						default: present_state <= `IF2;
					endcase
				end
				`HALT: present_state <= `HALT;
				`IF2: present_state <= `UpdatePC;
				`UpdatePC: present_state <= `DECODE;
				`DECODE: begin
					case(opcode)
						3'b110: begin
							case(op)
								2'b10: present_state <= `WRITE_IMM;
								2'b00: present_state <= `LOAD_B;
								default: present_state <= `RST;
							endcase
						end
						3'b101: begin
							case(op)
								2'b11: present_state <= `LOAD_B;
								default: present_state <= `LOAD_A;
							endcase
						end
						3'b011: present_state <= `LOAD_A;
						3'b100: present_state <= `LOAD_A;
						default: present_state <= `DECODE;
					endcase
				end
				`WRITE_IMM: begin
					present_state <= `IF1;
				end
				`LOAD_A: begin	
					case(opcode)
						3'b100: present_state <= `LOAD_C;
						3'b011: present_state <= `LOAD_C;
						default: present_state <= `LOAD_B;
					endcase
				end
				`LOAD_B: present_state <= `LOAD_C;
				`LOAD_C: begin
					case(opcode)
						3'b101: begin
							case(op)
								2'b01: present_state <= `IF1;
								default: present_state <= `WRITE_OUT;
							endcase
						end
						3'b011: present_state <= `LOAD_ADR;
						3'b100: present_state <= `LOAD_ADR;
						default: present_state <= `WRITE_OUT;
					endcase
				end
				`LOAD_ADR: begin
					case(opcode)
						3'b011: present_state <= `WRITE_IMM;
						default: present_state <= `LOAD_A2;
					endcase
				end
				`LOAD_A2: present_state <= `LOAD_C2;
				`LOAD_C2: present_state <= `WRITE_OUT;
				`WRITE_OUT: present_state <= `IF1;
				default: present_state <= `IF1;


			endcase
		end
	end
	always_comb begin
		case(present_state)
			`RST: begin
				reset_pc = 1'b1; // Memory signals
				load_pc = 1'b1;
				addr_sel = 1'b0;
				load_addr = 1'b0;
				load_ir = 1'b0;
				mem_cmd = `MNONE;
				vsel = 2'b10; // Datapath signals
				nsel = 3'b000;
				write = 1'b0;
				loada = 1'b0;
				loadb = 1'b0;
				loadc = 1'b0;
				loads = 1'b0;
				asel = 1'b0;
				bsel = 1'b0;
			end
			`IF1: begin
				reset_pc = 1'b0;
				load_pc = 1'b0;
				addr_sel = 1'b1; // Memory signals
				load_addr = 1'b0;
				load_ir = 1'b0;
				mem_cmd = `MREAD;
				vsel = 2'b10; // Datapath signals
				nsel = 3'b000;
				write = 1'b0;
				loada = 1'b0;
				loadb = 1'b0;
				loadc = 1'b0;
				loads = 1'b0;
				asel = 1'b0;
				bsel = 1'b0;
			end
			`IF2: begin
				reset_pc = 1'b0;
				load_pc = 1'b0;
				addr_sel = 1'b1; // Memory signals
				load_addr = 1'b0;
				load_ir = 1'b1;
				mem_cmd = `MREAD;
				vsel = 2'b10; // Datapath signals
				nsel = 3'b000;
				write = 1'b0;
				loada = 1'b0;
				loadb = 1'b0;
				loadc = 1'b0;
				loads = 1'b0;
				asel = 1'b0;
				bsel = 1'b0;
			end
			`UpdatePC: begin
				reset_pc = 1'b0;
				addr_sel = 1'b0;
				load_addr = 1'b0;
				load_pc = 1'b1; // Memory signals
				load_ir = 1'b0;
				mem_cmd = `MNONE;
				vsel = 2'b10; // Datapath signals
				nsel = 3'b000;
				write = 1'b0;
				loada = 1'b0;
				loadb = 1'b0;
				loadc = 1'b0;
				loads = 1'b0;
				asel = 1'b0;
				bsel = 1'b0;
			end
			`DECODE: begin
				reset_pc = 1'b0;
				load_pc = 1'b0;
				addr_sel = 1'b0;
				load_addr = 1'b0;
				load_ir = 1'b0;
				mem_cmd = `MNONE;
				vsel = 2'b10; // Datapath signals
				nsel = 3'b000;
				write = 1'b0;
				loada = 1'b0;
				loadb = 1'b0;
				loadc = 1'b0;
				loads = 1'b0;
				asel = 1'b0;
				bsel = 1'b0;
			end
			`WRITE_IMM: begin
				reset_pc = 1'b0;
				load_pc = 1'b0;
				addr_sel = 1'b0;
				load_addr = 1'b0;
				load_ir = 1'b0;
				case(opcode)
					3'b011: begin mem_cmd = `MREAD; vsel = 2'b00; nsel = 3'b010; end
					default: begin mem_cmd = `MNONE; vsel = 2'b01; nsel = 3'b001; end
				endcase
				write = 1'b1;
				loada = 1'b0;
				loadb = 1'b0;
				loadc = 1'b0;
				loads = 1'b0;
				asel = 1'b0;
				bsel = 1'b0;
			end
			`LOAD_A: begin
				reset_pc = 1'b0;
				load_pc = 1'b0;
				addr_sel = 1'b0;
				load_addr = 1'b0;
				load_ir = 1'b0;
				mem_cmd = `MNONE;
				vsel = 2'b10; // Datapath signals
				if((opcode == 3'b100) ^ (opcode == 3'b011)) nsel = 3'b010;
				else nsel = 3'b001;
				write = 1'b0;
				loada = 1'b1;
				loadb = 1'b0;
				loadc = 1'b0;
				loads = 1'b0;
				asel = 1'b0;
				bsel = 1'b0;
			end
			`LOAD_B: begin
				reset_pc = 1'b0;
				load_pc = 1'b0;
				addr_sel = 1'b0;
				load_addr = 1'b0;
				load_ir = 1'b0;
				mem_cmd = `MNONE;
				vsel = 2'b10; // Datapath signals
				if((opcode == 3'b100) ^ (opcode == 3'b011)) nsel = 3'b010;
				else nsel = 3'b100;
				write = 1'b0;
				loada = 1'b0;
				loadb = 1'b1;
				loadc = 1'b0;
				loads = 1'b0;
				asel = 1'b0;
				bsel = 1'b0;
			end
			`LOAD_C: begin
				reset_pc = 1'b0;
				load_pc = 1'b0;
				addr_sel = 1'b0;
				load_addr = 1'b0;
				load_ir = 1'b0;
				mem_cmd = `MNONE;
				vsel = 2'b10; // Datapath signals
				nsel = 3'b000;
				write = 1'b0;
				loada = 1'b0;
				loadb = 1'b0;
				loadc = 1'b1;
				loads = 1'b1;
				case(opcode)
					3'b110: begin
						case(op)
							2'b00: begin
								asel = 1'b1;
								bsel = 1'b0;
							end
							default: begin
								asel = 1'b0;
								bsel = 1'b0;
							end
						endcase
					end
					3'b101: begin
						case(op)
							2'b11: begin
								asel = 1'b1;
								bsel = 1'b0;
							end
							default: begin
								asel = 1'b0;
								bsel = 1'b0;
							end
						endcase
					end
					3'b011: begin
					asel = 1'b0;
					bsel = 1'b1;
					end
					3'b100: begin
					asel = 1'b0;
					bsel = 1'b1;
					end
					default: begin
						asel = 1'b0;
						bsel = 1'b0;
					end
				endcase
			end
			`LOAD_A2: begin
				reset_pc = 1'b0;
				load_pc = 1'b0;
				addr_sel = 1'b0;
				load_addr = 1'b0;
				load_ir = 1'b0;
				mem_cmd = `MNONE;
				vsel = 2'b10; // Datapath signals
				nsel = 3'b001;
				write = 1'b0;
				loada = 1'b1;
				loadb = 1'b0;
				loadc = 1'b0;
				loads = 1'b0;
				asel = 1'b0;
				bsel = 1'b0;
			end
			`LOAD_C2: begin
				reset_pc = 1'b0;
				load_pc = 1'b0;
				addr_sel = 1'b0;
				load_addr = 1'b0;
				load_ir = 1'b0;
				mem_cmd = `MNONE;
				vsel = 2'b10; 
				nsel = 3'b100;
				write = 1'b0;
				loada = 1'b0;
				loadb = 1'b0;
				loadc = 1'b1;
				loads = 1'b1;
				asel = 1'b1;
				bsel = 1'b0;
			end
			`LOAD_ADR: begin
				reset_pc = 1'b0;
				load_pc = 1'b0;
				addr_sel = 1'b0;
				load_addr = 1'b1;
				load_ir = 1'b0;
				mem_cmd = `MNONE;
				vsel = 2'b10;
				nsel = 3'b100;
				write = 1'b0;
				loada = 1'b0;
				loadb = 1'b0;
				loadc = 1'b0;
				loads = 1'b0;
				asel = 1'b0;
				bsel = 1'b0;
			end
			`WRITE_OUT: begin
				reset_pc = 1'b0;
				load_pc = 1'b0;
				addr_sel = 1'b0;
				load_addr = 1'b0;
				load_ir = 1'b0;
				case(opcode)
					3'b100: begin
						mem_cmd = `MWRITE;
						write = 1'b0;
					end
					default:  begin 
						mem_cmd = `MNONE;
						write = 1'b1;
					end
				endcase
				vsel = 2'b11; // Datapath signals
				nsel = 3'b010;
				loada = 1'b0;
				loadb = 1'b0;
				loadc = 1'b0;
				loads = 1'b0;
				asel = 1'b0;
				bsel = 1'b0;
			end
			`HALT: begin
				reset_pc = 1'b0;
				load_pc = 1'b0;
				addr_sel = 1'b0;
				load_addr = 1'b0;
				load_ir = 1'b0;
				mem_cmd = `MNONE;
				vsel = 2'b01; // Datapath signals
				nsel = 3'b100;
				write = 1'b0;
				loada = 1'b0;
				loadb = 1'b0;
				loadc = 1'b0;
				loads = 1'b0;
				asel = 1'b0;
				bsel = 1'b0;
			end
			default: begin
				reset_pc = 1'b0;
				load_pc = 1'b0;
				addr_sel = 1'b0;
				load_addr = 1'b0;
				load_ir = 1'b0;
				mem_cmd = `MNONE;
				vsel = 2'b01; // Datapath signals
				nsel = 3'b100;
				write = 1'b0;
				loada = 1'b0;
				loadb = 1'b0;
				loadc = 1'b0;
				loads = 1'b0;
				asel = 1'b0;
				bsel = 1'b0;
			end
		endcase
	end

endmodule: fsm_controller