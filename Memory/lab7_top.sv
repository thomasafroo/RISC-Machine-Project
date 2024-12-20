`define MNONE 2'b00
`define MREAD 2'b01
`define MWRITE 2'b10 
module lab7_top(KEY,SW,LEDR,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5);
	input [3:0] KEY;
	input [9:0] SW;
	output [9:0] LEDR;
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	wire [8:0] mem_addr;
	wire [1:0] mem_cmd;
	wire [15:0] read_data;
	wire [15:0] write_data;
	wire write;
	wire [15:0] dout;
	wire msel;
	wire enable;

	// instantiating RAM
	RAM MEM(~KEY[0], mem_addr[7:0], mem_addr[7:0], write, write_data, dout);
	
	// dout tri-state driver
	assign read_data = enable ? dout : {16{1'bz}};

	// equality comparators
	assign msel = (1'b0 == mem_addr[8]);
	assign write = (`MWRITE == mem_cmd) && msel;

	// output of AND gate is the enable for the tri-state driver
	assign enable = (`MREAD == mem_cmd) && msel;

	wire Z, N, V;
	// cpu instantiation
	cpu CPU(.clk(~KEY[0]),
		  .reset(~KEY[1]),
		  .read_data(read_data),
		  .mem_cmd(mem_cmd),
		  .mem_addr(mem_addr),
		  .write_data(write_data),
		  .N(N),
		  .V(V),
		  .Z(Z)
		);
	
	// Stage 3: Memory I/O Mapping
	wire READ_enable, WRITE_enable;
	// LDR operation 
	// enable for tri-state drivers when reading switch input
	assign READ_enable = (mem_cmd == `MREAD) && (mem_addr == 9'h140);
	// tri-state driver for read_data[15:8]
	assign read_data[15:8] = READ_enable ? 8'h00 : {16{1'bz}};
	// tri-state driver for read_data[7:0]
	assign read_data[7:0] = READ_enable ? SW[7:0] : {16{1'bz}};

	// STR operation
	// LEDR output
	// enable for tri-state drivers when reading switch input
	assign WRITE_enable = (mem_cmd == `MWRITE) && (mem_addr == 9'h100);
	// Register with load enable
	vDFFE LEDR_out(~KEY[0], WRITE_enable, write_data[7:0], LEDR[7:0]);


	// HEX display output
	// status flags
  	assign HEX5[0] = ~Z;
  	assign HEX5[6] = ~N;
  	assign HEX5[3] = ~V;

  	// fill in sseg to display 4-bits in hexidecimal 0,1,2...9,A,B,C,D,E,F
 	sseg H0(write_data[3:0],   HEX0);
 	sseg H1(write_data[7:4],   HEX1);
 	sseg H2(write_data[11:8],  HEX2);
 	sseg H3(write_data[15:12], HEX3);
 	assign HEX4 = 7'b1111111;
 	assign {HEX5[2:1],HEX5[5:4]} = 4'b1111; // disabled
 	assign LEDR[8] = 1'b0;

endmodule: lab7_top



// To ensure Quartus uses the embedded MLAB memory blocks inside the Cyclone
// V on your DE1-SoC we follow the coding style from in Altera's Quartus II
// Handbook (QII5V1 2015.05.04) in Chapter 12, ?Recommended HDL Coding Style?
//
// 1. "Example 12-11: Verilog Single Clock Simple Dual-Port Synchronous RAM 
//     with Old Data Read-During-Write Behavior" 
// 2. "Example 12-29: Verilog HDL RAM Initialized with the readmemb Command"

module RAM(clk,read_address,write_address,write,din,dout);
 	parameter data_width = 16; 	
 	parameter addr_width = 8;
 	parameter filename = "data.txt";

 	input clk;
 	input [addr_width-1:0] read_address, write_address;
 	input write;
 	input [data_width-1:0] din;
 	output [data_width-1:0] dout;
 	reg [data_width-1:0] dout;

 	reg [data_width-1:0] mem [2**addr_width-1:0];

 	initial $readmemb(filename, mem);

 	always @ (posedge clk) begin
    	if (write)
      		mem[write_address] <= din;
    	dout <= mem[read_address]; // dout doesn't get din in this clock cycle 
                               // (this is due to Verilog non-blocking assignment "<=")
	end 
endmodule: RAM

module vDFF(clk,D,Q);
 	parameter n=1;
 	input clk;
 	input [n-1:0] D;
 	output [n-1:0] Q;
 	reg [n-1:0] Q;
 	always @(posedge clk)
   		Q <= D;
endmodule


module sseg(in,segs);
 	input [3:0] in;
 	output reg [6:0] segs;
 	always @ (in) begin
 		case (in)
      		4'b0000: segs = 7'b1000000; // "0"
      		4'b0001: segs = 7'b1111001; // "1"
      		4'b0010: segs = 7'b0100100; // "2"
      		4'b0011: segs = 7'b0110000; // "3"
      		4'b0100: segs = 7'b0011001; // "4"
			4'b0101: segs = 7'b0010010; // "5"
     		4'b0110: segs = 7'b0000010; // "6"
     		4'b0111: segs = 7'b1111000; // "7"
    		4'b1000: segs = 7'b0000000; // "8"
			4'b1001: segs = 7'b0010000; // "9"
			4'b1010: segs = 7'b0001000; // "A"
     		4'b1011: segs = 7'b0000011; // "b"
			4'b1100: segs = 7'b1000110; // "C"
			4'b1101: segs = 7'b0100001; // "d"
			4'b1110: segs = 7'b0000110; // "E"
			4'b1111: segs = 7'b0001110; // "F"
			default: segs = 7'b1111111; // off
		endcase
	end
endmodule: sseg