`define Binary0 16'b0000000000000000
`define Binary1 16'b0000000000000001
`define Binary2 16'b0000000000000010
`define Binary3 16'b0000000000000011
`define Binary4 16'b0000000000000100
`define Binary5 16'b0000000000000101
`define Binary6 16'b0000000000000110
`define Binary8 16'b0000000000001000
`define Binary10 16'b0000000000001010
`define Binary32768 16'b1000000000000000
`define Binary49152 16'b1100000000000000
`define OpRet 2'b00
`define OpMul 2'b01
`define OpDiv 2'b10
`define OpExt 2'b11

module shifter_tb();
	reg [15:0] in, sout;
	reg [1:0] shift;
	reg err;
	//Instantiating shifter module
  	shifter DUT (
    	.in(in), 
    	.sout(sout), 
    	.shift(shift)
  	);
	//Beginning tests
	initial begin
		//Initializing error wave to 0
		err = 1'b0;
		//Testing if 2 = 2
		in = `Binary2;
		shift = 2'b00;
		#10;
		//If it doesn't, report it via error wave
		if(shifter_tb.DUT.sout !== `Binary2) err = 1'b1; else err = 1'b0;
		#10;
		//Testing if 2*2 = 4
		shift = `OpMul;
		#10;
		//If it doesn't, report it via error wave
		if(shifter_tb.DUT.sout !== `Binary4) err = 1'b1; else err = 1'b0;
		#10;
		//Testing if 2/2 = 1
		shift = `OpDiv;
		#10;
		//If it doesn't, report it via error wave
		if(shifter_tb.DUT.sout !== `Binary1) err = 1'b1; else err = 1'b0;
		#10;
		//Testing if 3*2 = 6
		in = `Binary3;
		shift = `OpMul;
		#10;
		//If it doesn't, report it via error wave
		if(shifter_tb.DUT.sout !== `Binary6) err = 1'b1; else err = 1'b0;
		#10;
		//Testing if 10/2 = 5
		in = `Binary10;
		shift = `OpDiv;
		#10;
		//If it doesn't, report it via error wave
		if(shifter_tb.DUT.sout !== `Binary5) err = 1'b1; else err = 1'b0;
		#10;
		//Testing if Wrapp-around function works for 1
		in = `Binary32768;
		shift = `OpExt;
		#10;
		//If it doesn't, report it via error wave
		if(shifter_tb.DUT.sout !== `Binary49152) err = 1'b1; else err = 1'b0;
		#390;

	end
	
endmodule

