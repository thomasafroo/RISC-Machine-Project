
module regfile_tb();
 	reg [15:0] data_in;
	reg [2:0] writenum, readnum;
	reg write, clk;
 	reg [15:0] data_out;
	reg err;
  
  // Instantiate the regfile module
  regfile DUT (
    .data_in(data_in),
    .writenum(writenum),
    .write(write),
    .readnum(readnum),
    .clk(clk),
    .data_out(data_out)
  );
  
  // Clock generation
  initial begin
	clk = 0;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
	#5 clk = ~clk;
  end
  
  // Test procedure
  initial begin
	// Initialize inputs
    data_in = 16'b0000_0000_0000_0000;
    writenum = 3'b000;
    write = 0;
    readnum = 3'b000;
	err = 1'b0;

    // Test Case 1: Write to register 0 and read back
    #10 data_in = 16'b0000_0000_1010_1010; 
    writenum = 3'b000;                     
    write = 1;                             
    #10 write = 0;                         
    readnum = 3'b000;                      
    #10;                                   
	if(regfile_tb.DUT.data_out !== 16'b0000_0000_1010_1010) err = 1'b1; else err = 1'b0;
    //$display("Test Case 1: Read from register 0, Expected: 16'b0000_0000_1010_1010, Got: %b", data_out);

    // Test Case 2: Write to register 3 and read back
    #10 data_in = 16'b0000_0000_0101_0101; 
    writenum = 3'b011;                     
    write = 1;                             
    #10 write = 0;                         
    readnum = 3'b011;                      
    #10;                                   
	if(regfile_tb.DUT.data_out !== 16'b0000_0000_0101_0101) err = 1'b1; else err = 1'b0;
    //$display("Test Case 2: Read from register 3, Expected: 16'b0000_0000_0101_0101, Got: %b", data_out);

    // Test Case 3: Write to register 7 and read back
    #10 data_in = 16'b0000_0000_1111_0000; 
    writenum = 3'b111;                     
    write = 1;                             
    #10 write = 0;                         
    readnum = 3'b111;                      
    #10;                                   
	if(regfile_tb.DUT.data_out !== 16'b0000_0000_1111_0000) err = 1'b1; else err = 1'b0;
    //$display("Test Case 3: Read from register 7, Expected: 16'b0000_0000_1111_0000, Got: %b", data_out);

    // Test Case 4: Read from an unwritten register (register 2)
    readnum = 3'b010;
    #10;
	if(regfile_tb.DUT.data_out !== 16'bxxxxxxxxxxxxxxxx) err = 1'b1; else err = 1'b0;
    //$display("Test Case 4: Read from register 2 (unwritten), Expected: 16'bxxxxxxxxxxxxxxxx, Got: %b", data_out);

    #100; // Total delay to observe waveform

  end
endmodule

