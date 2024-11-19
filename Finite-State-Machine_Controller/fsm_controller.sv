`define WAIT 3'b000
`define DECODE 3'b001
`define WRITE_IMM 3'b010
`define LOAD_A 3'b011
`define LOAD_B 3'b100
`define LOAD_C 3'b101
`define WRITE_OUT 3'b110

module fsm_controller(reset, vsel, write, clk, loada, loadb, asel, bsel, loadc, loads, nsel, opcode, op, s, w);
	input clk, s, reset;
	input [2:0] opcode;
	input [1:0] op;
	output reg [1:0] vsel;
	output reg [2:0] nsel;
	output reg w, loada, loadb, asel, bsel, loadc, loads, write;

	// present state
	reg [2:0] present_state;

	always @(posedge clk) begin
		if (reset) 
			present_state <= `WAIT; 
		else begin
			case (present_state) 
				`WAIT: begin
					if (s)
						present_state <= `DECODE;
					else
						present_state <= `WAIT;
				end
				
				`DECODE: begin
					case(opcode)
						3'b110: begin
							case(op)
								2'b10: present_state <= `WRITE_IMM;
								2'b00: present_state <= `LOAD_B;
								default: present_state <= `WAIT;
							endcase
						end
						3'b101: begin
							case(op)
								2'b11: present_state <= `LOAD_B;
								default: present_state <= `LOAD_A;
							endcase
						end
						default: present_state <= `DECODE;
					endcase
				end

				`WRITE_IMM: begin // write a number to Rn 
					present_state <= `WAIT;
				end
				`LOAD_A: begin
					present_state <= `LOAD_B;
				end
				`LOAD_B: begin
					present_state <= `LOAD_C;
				end
				`LOAD_C: begin
					case(opcode)
						3'b101: begin
							case(op)
								2'b01: begin
									present_state <= `WAIT;
								end
								default: begin
									present_state <= `WRITE_OUT;
								end
							endcase
						end
						default: begin
							present_state <= `WRITE_OUT;
						end
					endcase
				end
				`WRITE_OUT: begin
					present_state <= `WAIT;
				end
				default: present_state <= `WAIT;


			endcase
		end
	end
	always_comb begin
		case(present_state)
			`WAIT: begin
				vsel = 2'b10;
				nsel = 3'b000;
				write = 1'b0;
				loada = 1'b0;
				loadb = 1'b0;
				loadc = 1'b0;
				loads = 1'b0;
				asel = 1'b0;
				bsel = 1'b0;
				w = 1'b1;
			end
			`DECODE: begin
				vsel = 2'b10;
				nsel = 3'b000;
				write = 1'b0;
				loada = 1'b0;
				loadb = 1'b0;
				loadc = 1'b0;
				loads = 1'b0;
				asel = 1'b0;
				bsel = 1'b0;
				w = 1'b1;
			end
			`WRITE_IMM: begin
				vsel = 2'b01;
				nsel = 3'b001;
				write = 1'b1;
				loada = 1'b0;
				loadb = 1'b0;
				loadc = 1'b0;
				loads = 1'b0;
				asel = 1'b0;
				bsel = 1'b0;
				w = 1'b0;
			end
			`LOAD_A: begin
				vsel = 2'b10;
				nsel = 3'b001;
				write = 1'b0;
				loada = 1'b1;
				loadb = 1'b0;
				loadc = 1'b0;
				loads = 1'b0;
				asel = 1'b0;
				bsel = 1'b0;
				w = 1'b0;
			end
			`LOAD_B: begin
				vsel = 2'b10;
				nsel = 3'b100;
				write = 1'b0;
				loada = 1'b0;
				loadb = 1'b1;
				loadc = 1'b0;
				loads = 1'b0;
				asel = 1'b0;
				bsel = 1'b0;
				w = 1'b0;
			end
			`LOAD_C: begin
				vsel = 2'b10;
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
							end
							default: begin
								asel = 1'b0;
							end
						endcase
					end
					3'b101: begin
						case(op)
							2'b11: begin
								asel = 1'b1;
							end
							default: begin
								asel = 1'b0;
							end
						endcase
					end
					default: begin
						asel = 1'b0;
					end
				endcase
				bsel = 1'b0;
				w = 1'b0;
			end
			`WRITE_OUT: begin
				vsel = 2'b11;
				nsel = 3'b010;
				write = 1'b1;
				loada = 1'b0;
				loadb = 1'b0;
				loadc = 1'b0;
				loads = 1'b0;
				asel = 1'b0;
				bsel = 1'b0;
				w = 1'b0;
			end
			default: begin
				vsel = 2'b01;
				nsel = 3'b100;
				write = 1'b0;
				loada = 1'b0;
				loadb = 1'b0;
				loadc = 1'b0;
				loads = 1'b0;
				asel = 1'b0;
				bsel = 1'b0;
				w = 1'b0; 
			end
		endcase
	end

endmodule: fsm_controller