module testbench();

timeunit 10ns;	// Half clock cycle at 50 MHz
			// This is the amount of time represented by #1
timeprecision 1ns;

// These signals are internal because the processor will be
// instantiated as a submodule in testbench.
// Avalon Clock Input
  logic CLK;

	// Avalon Reset Input
  logic RESET;

	// Avalon-MM Slave Signals
	logic AVL_READ;					// Avalon-MM Read
	logic AVL_WRITE;					// Avalon-MM Write
	logic AVL_CS;						// Avalon-MM Chip Select
	logic [3:0] AVL_BYTE_EN;		// Avalon-MM Byte Enable
	logic [3:0] AVL_ADDR;			// Avalon-MM Address
	logic [31:0] AVL_WRITEDATA;	// Avalon-MM Write Data
	logic [31:0] AVL_READDATA;	// Avalon-MM Read Data

	// Exported Conduit
	logic [31:0] EXPORT_DATA;		// Exported Conduit Signal to LEDs

// A counter to count the instances where simulation results
// do no match with expected results
//integer ErrorCnt = 0;

// Instantiating the DUT
// Make sure the module and signal names match with those in your design
avalon_aes_interface aes_interface(.*);

// Toggle the clock
// #1 means wait for a delay of 1 timeunit
always begin : CLOCK_GENERATION
#1 CLK = ~CLK;
end

initial begin: CLOCK_INITIALIZATION
    CLK = 0;
end

// Testing begins here
// The initial block is not synthesizable
// Everything happens sequentially inside an initial block
// as in a software program
initial begin: TEST_VECTORS

#500;

end


// if (ErrorCnt == 0)
// 	//$display("Success!");  // Command line output in ModelSim
// 	$display("Key Schedule: \n")
// 	$display("Initial Round:\n")
// else
// 	$display("%d error(s) detected. Try again!", ErrorCnt);
// end
endmodule
