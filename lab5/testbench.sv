module testbench();

timeunit 10ns;

timeprecision 1ns;
	
	// Inputs 
	logic 			Clk, //Internal
						Reset, //Push button 0
						Run, //Push button 1
						ClearA_LoadB; //Push Button 2
						
	logic [7:0] 	S; //From switches
	
	// Outputs
	logic [7:0] 	Aval, //Values of Registers
                  Bval;
						
	logic [6:0] 	AHexU, //Hex values
                  AHexL,
                  BHexU,
                  BHexL;
						
   logic 			X_reg;
	
	//Holders for answers
	logic [15:0] ans_1, ans_2;
 
 
always begin : CLOCK_GENERATION
 
 #1 Clk = ~Clk;
 
end
 
 
 
initial begin : CLOCK_INITIALIZATION
	Clk = 0;
end

multiplier8x8 tp(.*);

initial begin : TEST_VECTORS

// Reset
#1 Reset = 0;
ClearA_LoadB = 1;
Run   = 1;

//test case1
#1 Reset = 1; // Release Reset button

#1 ClearA_LoadB = 0; // Press ClearA_LoadB
	S     = 8'b00000010; // 2 into Load B

#1 ClearA_LoadB = 1;
	S		= 8'b10000001; // -127 held on the switches
	
#1 ans_1 = 16'hff02; // -254 is the answer

#1 Run   = 0; //check answer at 450ns

// Reset
#40 Reset = 0;
#1 ClearA_LoadB = 1;
#1 Run   = 1;

//test case2
#2 Reset = 1; // Release Reset button

#2 ClearA_LoadB = 0; // Press ClearA_LoadB
	S     = 8'b10000000; // -128 into Load B

#2 ClearA_LoadB = 1;
	S		= 8'b10000000; // -128 held on the switches
	
#1 ans_2 = 16'h8000; // 16384 is the answer

#1 Run   = 0; //check answer at 900ns

end


endmodule