module testbench();

timeunit 10ns;

timeprecision 1ns;


//Week 1 Simulation - Functioning IR from PC

    //Inputs
    logic [15:0] S;
    logic Clk, Reset, Run, Continue;
    wire [15:0] Data;

    logic [11:0] LED;
    logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
    logic CE, UB, LB, OE, WE;
    logic [19:0] ADDR;


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
  // logic Clk, LD_IR, Reset;
  // logic [15:0] DIN;
  // Outputs
  // logic [15:0] DOUT;
	//Holders for answers
	// logic [15:0] ans_1, ans_2, ans_3, ans_4;


always begin : CLOCK_GENERATION

 #1 Clk = ~Clk;

end

initial begin : CLOCK_INITIALIZATION
	Clk = 0;
end

// Register test(.*);
// IR IR_test(.*);
lab6_toplevel lab6_toplevel_inst(.*);

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
// Tests for Registers
// #5 Reset = 1'b1;
// #5 Reset = 1'b0;
// #5 LD_IR = 1'b0;
// #5 DIN = 16'h0001;
// #5;
// #5 LD_IR = 1'b1;
// #5 Reset = 1'b1;

// Test Case 1 : Reset

#2 Reset = 1;
#2 Reset = 0; // Reset is Pressed
#2 Reset = 1;
#2 S = 16'h005A;
#2 Run = 0; // Run is Pressed, start doing stuff

//Instruction #1 : opCLR(R0) : IR = 0x5020 (0101 000 000 1 00000)
#8 Continue = 1; // Continue needs to go from low to high to go to the next instruction
#2 Continue = 0; // Get next instruction into IR
#8 Continue = 1; // Continue needs to go from low to high to go to the next instruction

//Instruction #2 : opLDR(R1,R0,inSW) : IR = 0x6200 (0110 001 000 000000)
#8 Continue = 1; // Continue needs to go from low to high to go to the next instruction
#2 Continue = 0; // Get next instruction into IR
#8 Continue = 1; // Continue needs to go from low to high to go to the next instruction

//Instruction #3 : opJMP(R1) : IR = 0xC040 (1100 000 001 000000)
#8 Continue = 1; // Continue needs to go from low to high to go to the next instruction
#2 Continue = 0; // Get next instruction into IR
#8 Continue = 1; // Continue needs to go from low to high to go to the next instruction

//Instruction #4 : opLDR(R1,R0,inSW) : IR = 0x6200 (0110 001 000 000000)
#8 Continue = 1; // Continue needs to go from low to high to go to the next instruction
#2 Continue = 0; // Get next instruction into IR
#8 Continue = 1; // Continue needs to go from low to high to go to the next instruction

//Instruction #5 : opSTR(R1,R0,outHEx) : IR = 0x7200 (0111 001 000 000000)
#8 Continue = 1; // Continue needs to go from low to high to go to the next instruction
#2 Continue = 0; // Get next instruction into IR
#8 Continue = 1; // Continue needs to go from low to high to go to the next instruction


end


endmodule
