module testbench();

timeunit 10ns;	// Half clock cycle at 50 MHz
			// This is the amount of time represented by #1
timeprecision 1ns;

// These signals are internal because the processor will be
// instantiated as a submodule in testbench.
logic clk;
logic [127:0]  Cipherkey;
logic [1407:0] KeySchedule;

// A counter to count the instances where simulation results
// do no match with expected results
//integer ErrorCnt = 0;

// Instantiating the DUT
// Make sure the module and signal names match with those in your design
KeyExpansion keyexpansion(.*);

// Toggle the clock
// #1 means wait for a delay of 1 timeunit
always begin : CLOCK_GENERATION
#1 clk = ~clk;
end

initial begin: CLOCK_INITIALIZATION
    clk = 0;
end

// Testing begins here
// The initial block is not synthesizable
// Everything happens sequentially inside an initial block
// as in a software program
initial begin: TEST_VECTORS
Cipherkey = 128'h000102030405060708090a0b0c0d0e0f;
KeySchedule = 1408'd0;

#50;

end


// if (ErrorCnt == 0)
// 	//$display("Success!");  // Command line output in ModelSim
// 	$display("Key Schedule: \n")
// 	$display("Initial Round:\n")
// else
// 	$display("%d error(s) detected. Try again!", ErrorCnt);
// end
endmodule
