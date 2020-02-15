module testbench();

timeunit 10ns;

timeprecision 1ns;
	
	// Inputs 
	logic 			Clk, //Internal
						Reset, //Push button 0
						Run, //Push button 1
						ClearA_LoadB, //Push Button 2
	logic [7:0] 	S, //From switches
	
	// Outputs
	logic [7:0] 	Aval, //Values of Registers
                  Bval,
	logic [6:0] 	AHexU, //Hex values
                  AHexL,
                  BHexU,
                  BHexL,
   logic 			X
 
 
always begin : CLOCK_GENERATION
 
 #1 Clk = ~Clk;
 
end
 
 
 
initial begin : CLOCK_INITIALIZATION
	Clk = 0;
end

multiplier8x8 tp(.*);

initial begin : TEST_VECTORS

Reset = 0;
LoadB = 1;
Run   = 1;

//test case1
#2 Reset = 1;

#2 LoadB = 0;
	S     = 8'b0000 0001; // 

#2 LoadB = 1;
	S		= 8'b0000 0002;
	
#2 Run   = 0;

#22 ;

end


endmodule