module testbench();

timeunit 10ns; // Half clock cycle at 50 MHz
					// This the amount of time represented by #1

timeprecision 1ns;

// These signals are internal because the processor will be
// instantiated as a submodule in testbench.

logic Clk  = 0;
logic [1:0] A;
logic [1:0] B;
logic c_in = 0;

logic [1:0] S;
logic c_out;

// To store expected results
logic [1:0] answer;

// Instantiating the 2-bit adder
adder2 my_adder2(.A(A),.B(B), .c_in(c_in),
					  .S(S),.c_out(c_out));
					  
// Creating a block for toggling the clock

always begin : CLOCK_GENERATION
	#1 Clk = ~Clk;						// It will delay for 1 timeunit
end

// Creating a block to initialize the clock low
initial begin : CLOCK_INITIALIZATION
	Clk = 0;
end

// Creating a testing block.
// Note that this block is not synthesizable.
// Everything happens sequentially like in a regular software
// program.

initial begin : TEST_BLOCK
// Add 2 + 1 = 3
A = 2'b10;
B = 2'b01;
answer = 2'b11; 

#2;

if (S != answer)
	$display("Error detected. Expected value: %b. Actual value %b.", answer, S);
else
	$display("Success! All test passed!");
end

endmodule
