//Defining terms for test bench
`define Binary0 16'b0000000000000000
`define Binary1 16'b0000000000000001
`define Binary2 16'b0000000000000010
`define Binary3 16'b0000000000000011
`define Binary4 16'b0000000000000100
`define Binary5 16'b0000000000000101
`define Binary8 16'b0000000000001000
`define BinaryNot1 16'b1111111111111110
`define BinaryNot8 16'b1111111111110111
`define OpAdd 2'b00
`define OpSub 2'b01
`define OpCom 2'b10
`define OpNot 2'b11

//Initiating module
module ALU_tb();
	reg [15:0] Ain, Bin;
	reg [1:0] ALUop;
	reg [15:0] out;
	reg Z;
	reg err;
	//Instantiating ALU module
  	ALU DUT (
    	.Ain(Ain), 
    	.Bin(Bin), 
    	.ALUop(ALUop), 
    	.out(out), 
    	.Z(Z)
  	);
	//Beginning tests
	initial begin
		err = 1'b0; //Initializing Error wave to 0
		//Testing if 1 + 1 = 2
		Ain = `Binary1;
		Bin = `Binary1;
		ALUop = `OpAdd;
		#10;
		//If it doesn't, report it via error wave
		if(ALU_tb.DUT.out !== `Binary2) err = 1'b1; else err = 1'b0;
		#10;
		//Testing if 3 + 2 = 5
		Ain = `Binary3;
		Bin = `Binary2;
		ALUop = `OpAdd;
		#10;
		//If it doesn't, report it via error wave
		if(ALU_tb.DUT.out !== `Binary5) err = 1'b1; else err = 1'b0;
		#10;
		//Testing if 4 - 2 = 2
		Ain = `Binary4;
		Bin = `Binary2;
		ALUop = `OpSub;
		#10;
		//If it doesn't, report it via error wave
		if(ALU_tb.DUT.out !== `Binary2) err = 1'b1; else err = 1'b0;
		#10;
		//Testing if 4 - 1 = 3
		Ain = `Binary4;
		Bin = `Binary1;
		ALUop = `OpSub;
		#10;
		//If it doesn't, report it via error wave
		if(ALU_tb.DUT.out !== `Binary3) err = 1'b1; else err = 1'b0;
		#10;
		//Testing Functionality of Zero Flag
		Ain = `Binary4;
		Bin = `Binary4;
		ALUop = `OpSub;
		#10;
		//If Z doesn't turn on, report it via error wave
		if(ALU_tb.DUT.Z !== 1'b1) err = 1'b1; else err = 1'b0;
		//If out doesn't equal zero, report it via error wave
		if(ALU_tb.DUT.out !== `Binary0) err = 1'b1; else err = 1'b0;
		#10;
		//Testing if 8 = 8
		Ain = `Binary8;
		Bin = `Binary8;
		ALUop = `OpCom;
		#10;
		//If it doesn't, report it via error wave
		if(ALU_tb.DUT.out !== `Binary8) err = 1'b1; else err = 1'b0;
		#10;
		//Testing if 5 = 5
		Ain = `Binary5;
		Bin = `Binary5;
		ALUop = `OpCom;
		#10;
		//If it doesn't, report it via error wave
		if(ALU_tb.DUT.out !== `Binary5) err = 1'b1; else err = 1'b0;
		#10;
		//Testing if not function works for 1
		Bin = `Binary1;
		ALUop = `OpNot;
		#10;
		//If it doesn't, report it via error wave
		if(ALU_tb.DUT.out !== `BinaryNot1) err = 1'b1; else err = 1'b0;
		#10;
		//Testing if not function works for 8
		Bin = `Binary8;
		ALUop = `OpNot;
		#10;
		//If it doesn't, report it via error wave
		if(ALU_tb.DUT.out !== `BinaryNot8) err = 1'b1; else err = 1'b0;
		#330;

	end

endmodule

