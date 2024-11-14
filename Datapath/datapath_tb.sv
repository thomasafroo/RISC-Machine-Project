`define Binary0 16'b0000000000000000
`define Binary1 16'b0000000000000001
`define Binary2 16'b0000000000000010
`define Binary3 16'b0000000000000011
`define Binary4 16'b0000000000000100
`define Binary5 16'b0000000000000101
`define Binary6 16'b0000000000000110
`define Binary7 16'b0000000000000111
`define Binary8 16'b0000000000001000
`define Binary9 16'b0000000000001001
`define Binary10 16'b0000000000001010
`define Binary16 16'b0000000000010000
`define Binary32768 16'b1000000000000000
`define Binary49152 16'b1100000000000000
`define NotBinary1 16'b1111111111111110

module datapath_tb;
  // checks datapath for compatibility with autograder

  reg clk;
  reg [15:0] datapath_in;
  reg write, vsel, loada, loadb, asel, bsel, loadc, loads;
  reg [2:0] readnum, writenum;
  reg [1:0] shift, ALUop;

  wire [15:0] datapath_out;
  wire Z_out;

  reg err;

	datapath DUT ( .clk         (clk),

                // register operand fetch stage
                .readnum     (readnum),
                .vsel        (vsel),
                .loada       (loada),
                .loadb       (loadb),

                // computation stage (sometimes called "execute")
                .shift       (shift),
                .asel        (asel),
                .bsel        (bsel),
                .ALUop       (ALUop),
                .loadc       (loadc),
                .loads       (loads),

                // set when "writing back" to register file
                .writenum    (writenum),
                .write       (write),  
                .datapath_in (datapath_in),

                // outputs
                .Z_out       (Z_out),
                .datapath_out(datapath_out)
             );

	//To terminate the tb at 500ps
/*
	initial begin
		#500;
		$stop;
	end
*/
/*
	//Clock tempo setter
	initial forever begin
		clk = 1'b0; 
		#2;
		clk = 1'b1; 
		#2;
	end
*/

	initial begin
		clk = 0;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
		#2 clk = ~clk;
	end
	initial begin
		//Initializing Error signal to 0
		err = 1'b0;
		//Defining all inputs at beginning to not get weird results
		datapath_in = `Binary0;
    		write = 1'b0; 
		vsel= 1'b0; 
		loada= 1'b0; loadb= 1'b0; 
		asel= 1'b0; bsel= 1'b0; 
		loadc=0; loads=0;
    		readnum = 3'b000; 
		writenum= 3'b000;
    		shift = 2'b00; 
		ALUop= 2'b00;
		#4;
		
		//Testing Memory Storage
		//MOV r0, #1;
		datapath_in =`Binary1;
		write = 1'b1;
		writenum = 3'b000;
		vsel = 1'b1;
		#4;
		write = 1'b0;
		//Checking r0 contents through rC
		readnum = 3'b000;
		loadb = 1'b1;
		#4;
		loadb = 1'b0;
		asel = 1'b1;
		bsel = 1'b0;
		shift = 2'b00;
		ALUop = 2'b00;
		loadc = 1'b1;
		loads = 1'b1;
		#4;
		loadc = 1'b0;
		loads = 1'b0;
		if(DUT.datapath_out !== `Binary1 || DUT.Z_out !== 1'b0) err=1; else err=0;

		//MOV r1, #8;
		datapath_in =`Binary8;
		write = 1'b1;
		writenum = 3'b001;
		vsel = 1'b1;
		#4;
		write = 1'b0;
		//Checking r0 contents through rC
		readnum = 3'b001;
		loadb = 1'b1;
		#4;
		loadb = 1'b0;
		asel = 1'b1;
		bsel = 1'b0;
		shift = 2'b00;
		ALUop = 2'b00;
		loadc = 1'b1;
		loads = 1'b1;
		#4;
		loadc = 1'b0;
		loads = 1'b0;
		if(DUT.datapath_out !== `Binary8 || DUT.Z_out !== 1'b0) err=1; else err=0;

		//Testing Addition
		//ADD r2, r1, r0

		//Loading r0 into rB
		readnum = 3'b000;
		loadb = 1'b1;
		#4;

		//Loading r1 into rA
		readnum = 3'b001;
		loadb = 1'b0;
		loada = 1'b1;
		#4;
		loada = 1'b0;
		//Setting up multiplexers to add contents of A&B registers
		asel = 1'b0;
		shift = 2'b00;
		bsel = 1'b0;
		ALUop = 2'b00;
		#4;
		//Recording results
		loadc = 1'b1;
		loads = 1'b1;
		#4;
		//Checking output register
		loadc = 1'b0;
		loads = 1'b0;
		if(DUT.datapath_out !== `Binary9 || DUT.Z_out !== 1'b0) err=1; else err=0;
		//Saving output to register 2
		vsel = 1'b0;
		write = 1'b1;
		writenum = 3'b010;
		#4;
		write = 1'b0;
		//Checking r2 contents through rC
		readnum = 3'b010;
		loadb = 1'b1;
		#4;
		loadb = 1'b0;
		asel = 1'b1;
		bsel = 1'b0;
		shift = 2'b00;
		ALUop = 2'b00;
		loadc = 1'b1;
		loads = 1'b1;
		#4;
		loadc = 1'b0;
		loads = 1'b0;
		if(DUT.datapath_out !== `Binary9 || DUT.Z_out !== 1'b0) err=1; else err=0;

		//Testing Subtraction
		//SUB r2, r1, r0;
		//Loading r0 into rB
		readnum = 3'b000;
		loadb = 1'b1;
		#4;

		//Loading r1 into rA
		readnum = 3'b001;
		loadb = 1'b0;
		loada = 1'b1;
		#4;
		loada = 1'b0;
		//Setting up multiplexers to subtract contents of B register from contents of A register
		asel = 1'b0;
		shift = 2'b00;
		bsel = 1'b0;
		ALUop = 2'b01;
		#4;
		//Recording results
		loadc = 1'b1;
		loads = 1'b1;
		#4;
		//Checking output register
		loadc = 1'b0;
		loads = 1'b0;
		if(DUT.datapath_out !== `Binary7 || DUT.Z_out !== 1'b0) err=1; else err=0;
		//Saving output to register 2
		vsel = 1'b0;
		write = 1'b1;
		writenum = 3'b010;
		#4;
		write = 1'b0;
		//Checking r2 contents through rC
		readnum = 3'b010;
		loadb = 1'b1;
		#4;
		loadb = 1'b0;
		asel = 1'b1;
		bsel = 1'b0;
		shift = 2'b00;
		ALUop = 2'b00;
		loadc = 1'b1;
		loads = 1'b1;
		#4;
		loadc = 1'b0;
		loads = 1'b0;
		if(DUT.datapath_out !== `Binary7 || DUT.Z_out !== 1'b0) err=1; else err=0;
		
		//Testing NOT Function
		//NEG r2, r0
		//Loading r0 into rB
		readnum = 3'b000;
		loadb = 1'b1;
		#4;
		//Setting up multiplexers to not rB
		asel = 1'b1;
		shift = 2'b00;
		bsel = 1'b0;
		ALUop = 2'b11;
		#4;
		//Recording results
		loadc = 1'b1;
		loads = 1'b1;
		#4;
		//Checking output register
		loadc = 1'b0;
		loads = 1'b0;
		if(DUT.datapath_out !== `NotBinary1 || DUT.Z_out !== 1'b0) err=1; else err=0;
		//Saving output to register 2
		vsel = 1'b0;
		write = 1'b1;
		writenum = 3'b010;
		#4;
		write = 1'b0;
		//Checking r2 contents through rC
		readnum = 3'b010;
		loadb = 1'b1;
		#4;
		loadb = 1'b0;
		asel = 1'b1;
		bsel = 1'b0;
		shift = 2'b00;
		ALUop = 2'b00;
		loadc = 1'b1;
		loads = 1'b1;
		#4;
		loadc = 1'b0;
		loads = 1'b0;
		if(DUT.datapath_out !== `NotBinary1 || DUT.Z_out !== 1'b0) err=1; else err=0;
		
		//Testing AND function
		//AND r2, r1, r0
		//Loading r0 into rB
		readnum = 3'b000;
		loadb = 1'b1;
		#4;

		//Loading r1 into rA
		readnum = 3'b001;
		loadb = 1'b0;
		loada = 1'b1;
		#4;
		loada = 1'b0;
		//Setting up multiplexers to copair r1 and r0
		asel = 1'b0;
		shift = 2'b00;
		bsel = 1'b0;
		ALUop = 2'b10;
		#4;
		//Recording results
		loadc = 1'b1;
		loads = 1'b1;
		#4;
		//Checking output register
		loadc = 1'b0;
		loads = 1'b0;
		if(DUT.datapath_out !== `Binary0 || DUT.Z_out !== 1'b1) err=1; else err=0;
		//Saving output to register 2
		vsel = 1'b0;
		write = 1'b1;
		writenum = 3'b010;
		#4;
		write = 1'b0;
		//Checking r2 contents through rC
		readnum = 3'b010;
		loadb = 1'b1;
		#4;
		loadb = 1'b0;
		asel = 1'b1;
		bsel = 1'b0;
		shift = 2'b00;
		ALUop = 2'b00;
		loadc = 1'b1;
		loads = 1'b1;
		#4;
		loadc = 1'b0;
		loads = 1'b0;
		if(DUT.datapath_out !== `Binary0 || DUT.Z_out !== 1'b1) err=1; else err=0;
		
		//Testing Shift Left
		//ADD r2, #0, r1, LSL #1
		//Loading r1 into rB
		readnum = 3'b001;
		loadb = 1'b1;
		#4;
		loadb = 1'b0;

		//Setting up multiplexers to add leftshifted B register and zero
		asel = 1'b1;
		shift = 2'b01;
		bsel = 1'b0;
		ALUop = 2'b00;
		#4;
		//Recording results
		loadc = 1'b1;
		loads = 1'b1;
		#4;
		//Checking output register
		loadc = 1'b0;
		loads = 1'b0;
		if(DUT.datapath_out !== `Binary16 || DUT.Z_out !== 1'b0) err=1; else err=0;
		//Saving output to register 2
		vsel = 1'b0;
		write = 1'b1;
		writenum = 3'b010;
		#4;
		write = 1'b0;
		//Checking r2 contents through rC
		readnum = 3'b010;
		loadb = 1'b1;
		#4;
		loadb = 1'b0;
		asel = 1'b1;
		bsel = 1'b0;
		shift = 2'b00;
		ALUop = 2'b00;
		loadc = 1'b1;
		loads = 1'b1;
		#4;
		loadc = 1'b0;
		loads = 1'b0;
		if(DUT.datapath_out !== `Binary16 || DUT.Z_out !== 1'b0) err=1; else err=0;

		//Testing Shift Right
		//ADD r2, #0, r1, LSR #1
		//Loading r1 into rB
		readnum = 3'b001;
		loadb = 1'b1;
		#4;
		loadb = 1'b0;

		//Setting up multiplexers to add rightshifted B register and zero
		asel = 1'b1;
		shift = 2'b10;
		bsel = 1'b0;
		ALUop = 2'b00;
		#4;
		//Recording results
		loadc = 1'b1;
		loads = 1'b1;
		#4;
		//Checking output register
		loadc = 1'b0;
		loads = 1'b0;
		if(DUT.datapath_out !== `Binary4 || DUT.Z_out !== 1'b0) err=1; else err=0;
		//Saving output to register 2
		vsel = 1'b0;
		write = 1'b1;
		writenum = 3'b010;
		#4;
		write = 1'b0;
		//Checking r2 contents through rC
		readnum = 3'b010;
		loadb = 1'b1;
		#4;
		loadb = 1'b0;
		asel = 1'b1;
		bsel = 1'b0;
		shift = 2'b00;
		ALUop = 2'b00;
		loadc = 1'b1;
		loads = 1'b1;
		#4;
		loadc = 1'b0;
		loads = 1'b0;
		if(DUT.datapath_out !== `Binary4 || DUT.Z_out !== 1'b0) err=1; else err=0;

		//MOV r3, #32768;
		datapath_in =`Binary32768;
		write = 1'b1;
		writenum = 3'b011;
		vsel = 1'b1;
		#4;
		write = 1'b0;
		//Checking r3 contents through rC
		readnum = 3'b011;
		loadb = 1'b1;
		#4;
		loadb = 1'b0;
		asel = 1'b1;
		bsel = 1'b0;
		shift = 2'b00;
		ALUop = 2'b00;
		loadc = 1'b1;
		loads = 1'b1;
		#4;
		loadc = 1'b0;
		loads = 1'b0;
		if(DUT.datapath_out !== `Binary32768 || DUT.Z_out !== 1'b0) err=1; else err=0;

		//Testing Arithatic Shift Right
		//ASR r2, r3, #1
		//Loading r3 into rB
		readnum = 3'b011;
		loadb = 1'b1;
		#4;
		loadb = 1'b0;

		//Setting up multiplexers to add arthimatic-rightshifted B register and zero
		asel = 1'b1;
		shift = 2'b11;
		bsel = 1'b0;
		ALUop = 2'b00;
		#4;
		//Recording results
		loadc = 1'b1;
		loads = 1'b1;
		#4;
		//Checking output register
		loadc = 1'b0;
		loads = 1'b0;
		if(DUT.datapath_out !== `Binary49152 || DUT.Z_out !== 1'b0) err=1; else err=0;
		//Saving output to register 2
		vsel = 1'b0;
		write = 1'b1;
		writenum = 3'b010;
		#4;
		write = 1'b0;
		//Checking r2 contents through rC
		readnum = 3'b010;
		loadb = 1'b1;
		#4;
		loadb = 1'b0;
		asel = 1'b1;
		bsel = 1'b0;
		shift = 2'b00;
		ALUop = 2'b00;
		loadc = 1'b1;
		loads = 1'b1;
		#4;
		loadc = 1'b0;
		loads = 1'b0;
		if(DUT.datapath_out !== `Binary49152 || DUT.Z_out !== 1'b0) err=1; else err=0;

		//Testing Adding Constant Value
		//ADD r2, r0, #4

		//Loading r0 into rA
		readnum = 3'b000;
		loada = 1'b1;
		#4;
		loada = 1'b0;
		//Setting up multiplexers to add contentsof A register with constant value 4
		asel = 1'b0;
		shift = 2'b00;
		datapath_in = `Binary4;
		bsel = 1'b1;
		ALUop = 2'b00;
		#4;
		//Recording results
		loadc = 1'b1;
		loads = 1'b1;
		#4;
		//Checking output register
		loadc = 1'b0;
		loads = 1'b0;
		if(DUT.datapath_out !== `Binary5 || DUT.Z_out !== 1'b0) err=1; else err=0;
		//Saving output to register 2
		vsel = 1'b0;
		write = 1'b1;
		writenum = 3'b010;
		#4;
		write = 1'b0;
		//Checking r2 contents through rC
		readnum = 3'b010;
		loadb = 1'b1;
		#4;
		loadb = 1'b0;
		asel = 1'b1;
		bsel = 1'b0;
		shift = 2'b00;
		ALUop = 2'b00;
		loadc = 1'b1;
		loads = 1'b1;
		#4;
		loadc = 1'b0;
		loads = 1'b0;
		if(DUT.datapath_out !== `Binary5 || DUT.Z_out !== 1'b0) err=1; else err=0;
	end
endmodule
