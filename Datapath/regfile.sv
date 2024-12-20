module regfile(data_in, writenum, write, readnum, clk, data_out);
	input [15:0] data_in;
	input [2:0] writenum, readnum;
	input write, clk;
	output [15:0] data_out;
	// fill out the rest

	wire [7:0] dec1_out;
	Dec38 dec1(.a(writenum), .b(dec1_out));

	wire [7:0] load;

	assign load[0] = write & dec1_out[0];
	assign load[1] = write & dec1_out[1];
	assign load[2] = write & dec1_out[2];
	assign load[3] = write & dec1_out[3];
	assign load[4] = write & dec1_out[4];
	assign load[5] = write & dec1_out[5];
	assign load[6] = write & dec1_out[6];
	assign load[7] = write & dec1_out[7];

	reg [15:0] R0, R1, R2, R3, R4, R5, R6, R7;

	vDFFE r0(.clk(clk), .load(load[0]), .in(data_in), .out(R0));
	vDFFE r1(.clk(clk), .load(load[1]), .in(data_in), .out(R1));
	vDFFE r2(.clk(clk), .load(load[2]), .in(data_in), .out(R2));
	vDFFE r3(.clk(clk), .load(load[3]), .in(data_in), .out(R3));
	vDFFE r4(.clk(clk), .load(load[4]), .in(data_in), .out(R4));
	vDFFE r5(.clk(clk), .load(load[5]), .in(data_in), .out(R5));
	vDFFE r6(.clk(clk), .load(load[6]), .in(data_in), .out(R6));
	vDFFE r7(.clk(clk), .load(load[7]), .in(data_in), .out(R7));

	wire [7:0] read;
	Dec38 dec2(.a(readnum), .b(read));
	reg [15:0] data_out;
	always @(*) begin
		case(read)
			8'b00000001: data_out = R0;
			8'b00000010: data_out = R1;
			8'b00000100: data_out = R2;
			8'b00001000: data_out = R3;
			8'b00010000: data_out = R4;
			8'b00100000: data_out = R5;
			8'b01000000: data_out = R6;
			8'b10000000: data_out = R7;
			default: data_out = 16'bx;
		endcase
	end
endmodule

// a - binary input   (n bits wide)
// b - one hot output (m bits wide)
module Dec38(a, b);
  parameter n = 3;
  parameter m = 8;

  input  [n-1:0] a;
  output [m-1:0] b;

  wire [m-1:0] b = 1 << a;
endmodule 