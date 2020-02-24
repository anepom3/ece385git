module testbench();

timeunit 10ns;

timeprecision 1ns;

//PC_MUX
	// Inputs
   // logic [1:0] PC_MUX; // Select bit 00 - PC + 1, 01 - BUS, 10 - ADDER
   //
   // logic [15:0] PC_PLUS; // Incremented PC (PC + 1)
   //
   // logic [15:0] BUS; // From the BUS
   //
   // logic [15:0] ADDER; // From the Address Adder
   // // Outputs
   // logic [15:0] PC_IN; // Goes to the PC register

//PC
  // Inputs
  logic Clk, LD_IR, Reset;
  logic [15:0] DIN;
  // Outputs
  logic [15:0] DOUT;
	//Holders for answers
	logic [15:0] ans_1, ans_2, ans_3, ans_4;


always begin : CLOCK_GENERATION

 #1 Clk = ~Clk;

end

initial begin : CLOCK_INITIALIZATION
	Clk = 0;
end

// Register test(.*);
IR IR_test(.*);

initial begin : TEST_VECTORS
// PC_PLUS = 16'h0001;
// BUS = 16'h0002;
// ADDER = 16'h0003;
//
// ans_1 = 16'h0001;
// ans_2 = 16'h0002;
// ans_3 = 16'h0003;
// ans_4 = 16'hxxxx;
//
// // Test Case #1 : Select PC+1
// #5 PC_MUX = 2'b00;
// #5;
//
// // Test Case #2 : Select from BUS
// #5 PC_MUX = 2'b01;
// #5;
//
// // Test Case #3 : Select from Address Adder
// #5 PC_MUX = 2'b10;
// #5;
//
// // Test Case #4 : Select from default case (16'hxxxx)
// #5 PC_MUX = 2'b11;
// #5;
#5 Reset = 1'b1;
#5 Reset = 1'b0;
#5 LD_IR = 1'b0;
#5 DIN = 16'h0001;
#5;
#5 LD_IR = 1'b1;
#5 Reset = 1'b1;

end


endmodule
