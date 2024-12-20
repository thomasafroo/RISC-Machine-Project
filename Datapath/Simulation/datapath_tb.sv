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
`define Binary11 16'b0000000000001011
`define Binary12 16'b0000000000001100
`define Binary13 16'b0000000000001101
`define Binary14 16'b0000000000001110
`define Binary15 16'b0000000000001111
`define Binary16 16'b0000000000010000
`define Binary32768 16'b1000000000000000
`define Binary49152 16'b1100000000000000
`define NotBinary1 16'b1111111111111110
`define NotBinary8 16'b1111111111110111
`define NotBinary32768 16'b0111111111111111
module datapath_tb();
	// Internal signals
	reg clk, loada, loadb, asel, bsel, loadc, loads, write, Z_out, V_out, N_out;
	reg [1:0] vsel, shift;
	reg [2:0] readnum, writenum, ALUop;
	reg [15:0] mdata, sximm8, PC, sximm5, datapath_out;

	reg [15:0] data_in, data_out, A, in, sout, Ain, Bin, out, C;
	reg err;

	datapath DUT(
		.vsel(vsel),
		.mdata(mdata),
		.sximm8(sximm8),
		.PC(8'b0),
		.clk(clk),
		.readnum(readnum),
		.loada(loada),
		.loadb(loadb),
		.shift(shift),
		.sximm5(sximm5),
		.asel(asel),
		.bsel(bsel),
		.ALUop(ALUop),
		.loadc(loadc),
		.loads(loads),
		.write(write),
		.writenum(writenum),
		.Z_out(Z_out),
		.V_out(V_out),
		.N_out(N_out),
		.datapath_out(datapath_out)
	);


	// Clock generation
	initial begin
		clk = 0;
		forever begin
		#2; clk = ~clk;
		end
	end
	
	initial begin
		//Initializing Error signal to 0
		err= 1'b0;
		//Defining all inputs at beginning to not get weird results
		sximm8= `Binary0;
    	write= 1'b0; 
		vsel= 2'b0; mdata = 16'b0; 
		loada= 1'b0; loadb= 1'b0; 
		asel= 1'b0; bsel= 1'b0; 
		loadc=0; loads=0;
    	readnum = 3'b000; 
		writenum= 3'b000;
    	shift= 2'b00; 
		ALUop= 2'b00;
		C= 16'b0;
		#4;

		//Testing Memory Storage
		//MOV R0, #1;------------------------------------------------------------------
		sximm8 =`Binary1;
		write = 1'b1;
		writenum = 3'b000;
		vsel = 2'b01;
		#4;
		write = 1'b0;
		//Checking R0 contents through C
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
		if(DUT.datapath_out !== `Binary1 || DUT.Z_out != 1'b0) err=1; else err=0;


		//MOV R1, #8;
		sximm8 =`Binary8;
		write = 1'b1;
		writenum = 3'b001;
		vsel = 2'b01;
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



		//Testing Addition------------------------------------------------------------------
		//ADD R2, R1, R0

		//Loading R0 into rB
		readnum = 3'b000;
		loadb = 1'b1;
		#4;

		//Loading R1 into rA
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
		vsel = 2'b11;
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


		//Testing Subtraction------------------------------------------------------------------
		//CMP R1, R0, LSL#1;
		//Loading R0 into rB
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
		shift = 2'b01;
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
		if(DUT.Z_out !== 1'b0 || DUT.N_out !== 0 || DUT.V_out !== 0) err=1; else err=0;
		//Saving output to register 2
		/*
		vsel = 2'b11;
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
		if(DUT.datapath_out !== `Binary7 || DUT.Z_out !== 1'b0) err=1; else err=0;*/


		//Testing NOT Function------------------------------------------------------------------
		//MVN R4, R0
		//Loading R0 into rB
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
		//Saving output to R4
		vsel = 2'b11;
		write = 1'b1;
		writenum = 3'b100;
		#4;
		write = 1'b0;
		//Checking R4 contents through rC
		readnum = 3'b100;
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

		
		//Testing NOT Function------------------------------------------------------------------
		//MVN R4, R1
		//Loading R1 into rB
		readnum = 3'b001;
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
		//if(DUT.datapath_out !== `NotBinary8 || DUT.Z_out !== 1'b0) err=1; else err=0;
		//Saving output to R4
		vsel = 2'b11;
		write = 1'b1;
		writenum = 3'b100;
		#4;
		write = 1'b0;
		//Checking R4 contents through rC
		readnum = 3'b100;
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
		if(DUT.datapath_out !== `NotBinary8 || DUT.Z_out !== 1'b0) err=1; else err=0;



		//Testing AND function----------------------------------------------------
		//AND R2, R1, R0
		//Loading R0 into rB
		readnum = 3'b000;
		loadb = 1'b1;
		#4;

		//Loading R1 into rA
		readnum = 3'b001;
		loadb = 1'b0;
		loada = 1'b1;
		#4;
		loada = 1'b0;
		//Setting up multiplexers to copair R1 and R0
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
		//Saving output to R2
		vsel = 2'b11;
		write = 1'b1;
		writenum = 3'b010;
		#4;
		write = 1'b0;
		//Checking R2 contents through rC
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

		//Testing Shift Left------------------------------------------------------
		//ADD R2, #0, R1, LSL #1
		//Loading R1 into rB
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
		//Saving output to R2
		vsel = 2'b11;
		write = 1'b1;
		writenum = 3'b010;
		#4;
		write = 1'b0;
		//Checking R2 contents through rC
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


		//Testing AND with Shift Right----------------------------------------------
		//AND R2, #0, R1, LSR #1
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
		//Saving output to R2
		vsel = 2'b11;
		write = 1'b1;
		writenum = 3'b010;
		#4;
		write = 1'b0;
		//Checking R2 contents through rC
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

		//MOV R3, #32768;
		sximm8 =`Binary32768;
		write = 1'b1;
		writenum = 3'b011;
		vsel = 2'b01;
		#4;
		write = 1'b0;
		//Checking R3 contents through rC
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

		//Testing AND function with LSL----------------------------------------------------
		//AND R2, R1, R0 LSL #1
		//Loading R0 into rB
		readnum = 3'b000;
		loadb = 1'b1;
		#4;

		//Loading R1 into rA
		readnum = 3'b001;
		loadb = 1'b0;
		loada = 1'b1;
		#4;
		loada = 1'b0;
		//Setting up multiplexers to copair R1 and R0
		asel = 1'b0;
		shift = 2'b01;
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
		//Saving output to R2
		vsel = 2'b11;
		write = 1'b1;
		writenum = 3'b010;
		#4;
		write = 1'b0;
		//Checking R2 contents through rC
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


		//Testing NOT Function------------------------------------------------------------------
		//MVN R5, R3
		//Loading R0 into rB
		readnum = 3'b011;
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
		if(DUT.datapath_out !== `NotBinary32768 || DUT.Z_out !== 1'b0) err=1; else err=0;
		//Saving output to R5
		vsel = 2'b11;
		write = 1'b1;
		writenum = 3'b101;
		#4;
		write = 1'b0;
		//Checking R5 contents through rC
		readnum = 3'b101;
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
		if(DUT.datapath_out !== `NotBinary32768 || DUT.Z_out !== 1'b0) err=1; else err=0;

		//Testing Add with Right Shift------------------------------------------------------
		//ADD R2, #0, R1, LSR #1
		//Loading R1 into rB
		readnum = 3'b001;
		loadb = 1'b1;
		#4;
		loadb = 1'b0;

		//Setting up multiplexers to add leftshifted B register and zero
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
		//Saving output to R2
		vsel = 2'b11;
		write = 1'b1;
		writenum = 3'b010;
		#4;
		write = 1'b0;
		//Checking R2 contents through rC
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
	
		//Testing MOV Function------------------------------------------------------------------
		//MOV R6, R2 LSL #1
		//Loading R2 into rB
		readnum = 3'b010;
		loadb = 1'b1;
		#4;
		//Setting up multiplexers to not rB
		asel = 1'b1;
		shift = 2'b01;
		bsel = 1'b0	;
		ALUop = 2'b00;
		#4;
		//Recording results
		loadc = 1'b1;
		loads = 1'b1;
		#4;
		//Checking output register
		loadc = 1'b0;
		loads = 1'b0;
		#4;
		if(DUT.datapath_out !== `Binary8 || DUT.Z_out !== 1'b0) err=1; else err=0;
		//Saving output to R6
		vsel = 2'b11;
		write = 1'b1;
		writenum = 3'b110;
		#16;
		write = 1'b0;
		//Checking R6 contents in register file
		if (DUT.REGFILE.R6 !== `Binary8) err = 1; else err=0;

/*
		// Testing LDR operation-------------------------------------------------------
		// LDR R6, R0, #4
		mdata = 16'b0110000011000100;
		vsel = 2'b00;
		//Loading R0 into rA
		readnum = 3'b000;
		loada = 1'b1;
		#4;
		loada = 1'b0;

		//Setting up multiplexers to add B register and zero
		asel = 1'b0;
		shift = 2'b00;
		bsel = 1'b1;
		ALUop = 2'b00;
		#4;
		//Recording results
		loadc = 1'b1;
		loads = 1'b1;
		#4;
		//Checking output register
		if(DUT.datapath_out !== (`Binary1 + sximm5) || DUT.Z_out !== 1'b0) err=1; else err=0;
		loadc = 1'b0;
		loads = 1'b0;
		//Saving output to R6
		vsel = 2'b11;
		write = 1'b1;
		writenum = 3'b110;
		#4;
		write = 1'b0;
		if (DUT.REGFILE.R6 !== (`Binary1 + sximm5)) err = 1; else err = 0;


		// Testing LDR operation-------------------------------------------------------
		// LDR R7, R1, #4
		mdata = 16'b0110000011100100;
		vsel = 2'b00;
		//Loading R1 into rA
		readnum = 3'b001;
		loada = 1'b1;
		#4;
		loada = 1'b0;

		//Setting up multiplexers to add B register and zero
		asel = 1'b0;
		shift = 2'b00;
		bsel = 1'b1;
		ALUop = 2'b00;
		#4;
		//Recording results
		loadc = 1'b1;
		loads = 1'b1;
		#4;
		//Checking output register
		if(DUT.datapath_out !== (`Binary8 + sximm5) || DUT.Z_out !== 1'b0) err=1; else err=0;
		loadc = 1'b0;
		loads = 1'b0;
		//Saving output to R7
		vsel = 2'b11;
		write = 1'b1;
		writenum = 3'b111;
		#4;
		write = 1'b0;
		if (DUT.REGFILE.R7 !== (`Binary8 + sximm5)) err = 1; else err = 0; */
		$stop;
	end

endmodule 