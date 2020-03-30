/************************************************************************
Avalon-MM Interface for AES Decryption IP Core

Dong Kai Wang, Fall 2017

For use with ECE 385 Experiment 9
University of Illinois ECE Department

Register Map:

 0-3 : 4x 32bit AES Key
 4-7 : 4x 32bit AES Encrypted Message
 8-11: 4x 32bit AES Decrypted Message
   12: Not Used
	13: Not Used
   14: 32bit Start Register
   15: 32bit Done Register

************************************************************************/

module avalon_aes_interface (
	// Avalon Clock Input
	input logic CLK,

	// Avalon Reset Input
	input logic RESET,

	// Avalon-MM Slave Signals
	input  logic AVL_READ,					// Avalon-MM Read
	input  logic AVL_WRITE,					// Avalon-MM Write
	input  logic AVL_CS,						// Avalon-MM Chip Select
	input  logic [3:0] AVL_BYTE_EN,		// Avalon-MM Byte Enable
	input  logic [3:0] AVL_ADDR,			// Avalon-MM Address
	input  logic [31:0] AVL_WRITEDATA,	// Avalon-MM Write Data
	output logic [31:0] AVL_READDATA,	// Avalon-MM Read Data

	// Exported Conduit
	output logic [31:0] EXPORT_DATA		// Exported Conduit Signal to LEDs
);

// Internal Wires
logic [15:0] LD_SEL;
logic [31:0] AVL_WRITEDATA_SEL;

logic [31:0] AES_KEY0_OUT;
logic [31:0] AES_KEY1_OUT;
logic [31:0] AES_KEY2_OUT;
logic [31:0] AES_KEY3_OUT;
logic [31:0] AES_MSG_EN0_OUT;
logic [31:0] AES_MSG_EN1_OUT;
logic [31:0] AES_MSG_EN2_OUT;
logic [31:0] AES_MSG_EN3_OUT;
logic [31:0] AES_MSG_DE0_OUT;
logic [31:0] AES_MSG_DE1_OUT;
logic [31:0] AES_MSG_DE2_OUT;
logic [31:0] AES_MSG_DE3_OUT;
logic [31:0] AES_START_OUT;
logic [31:0] AES_DONE_OUT;

// Register Instantiations
REG AES_KEY0 (.LD(LD_SEL[0]), .DIN(AVL_WRITEDATA_SEL), .DOUT(AES_KEY0_OUT));
REG AES_KEY1 (.LD(LD_SEL[1]), .DIN(AVL_WRITEDATA_SEL), .DOUT(AES_KEY1_OUT));
REG AES_KEY2 (.LD(LD_SEL[2]), .DIN(AVL_WRITEDATA_SEL), .DOUT(AES_KEY2_OUT));
REG AES_KEY3 (.LD(LD_SEL[3]), .DIN(AVL_WRITEDATA_SEL), .DOUT(AES_KEY3_OUT));

REG AES_MSG_EN0 (.LD(LD_SEL[4]), .DIN(AVL_WRITEDATA_SEL), .DOUT(AES_MSG_EN0_OUT));
REG AES_MSG_EN1 (.LD(LD_SEL[5]), .DIN(AVL_WRITEDATA_SEL), .DOUT(AES_MSG_EN1_OUT));
REG AES_MSG_EN2 (.LD(LD_SEL[6]), .DIN(AVL_WRITEDATA_SEL), .DOUT(AES_MSG_EN2_OUT));
REG AES_MSG_EN3 (.LD(LD_SEL[7]), .DIN(AVL_WRITEDATA_SEL), .DOUT(AES_MSG_EN3_OUT));

REG AES_MSG_DE0 (.LD(LD_SEL[8]), .DIN(AVL_WRITEDATA_SEL), .DOUT(AES_MSG_DE0_OUT));
REG AES_MSG_DE1 (.LD(LD_SEL[9]), .DIN(AVL_WRITEDATA_SEL), .DOUT(AES_MSG_DE1_OUT));
REG AES_MSG_DE2 (.LD(LD_SEL[10]), .DIN(AVL_WRITEDATA_SEL), .DOUT(AES_MSG_DE2_OUT));
REG AES_MSG_DE3 (.LD(LD_SEL[11]), .DIN(AVL_WRITEDATA_SEL), .DOUT(AES_MSG_DE3_OUT));

REG AES_DUMMY1 (.LD(LD_SEL[12]), .DIN(AVL_WRITEDATA_SEL), .DOUT(32'hZZZZZZZZ));
REG AES_DUMMY2 (.LD(LD_SEL[13]), .DIN(AVL_WRITEDATA_SEL), .DOUT(32'hZZZZZZZZ));

REG AES_START (.LD(LD_SEL[14]), .DIN(AVL_WRITEDATA_SEL), .DOUT(AES_START_OUT));
REG AES_DONE (.LD(LD_SEL[15]), .DIN(AVL_WRITEDATA_SEL), .DOUT(AES_DONE_OUT));
always_comb begin
	// Initialize the LD_SEL to be all 0's at first.
	LD_SEL = 16'b0;
	if(AVL_WRITE && AVL_CS) begin
		// Selects which Register to WRITE to.
		
		unique case (AVL_ADDR)
			4'b0000: LD_SEL[0] = 1;
			4'b0001: LD_SEL[1] = 1;
			4'b0010: LD_SEL[2] = 1;
			4'b0011: LD_SEL[3] = 1;
			4'b0100: LD_SEL[4] = 1;
			4'b0101: LD_SEL[5] = 1;
			4'b0110: LD_SEL[6] = 1;
			4'b0111: LD_SEL[7] = 1;
			4'b1000: LD_SEL[8] = 1;
			4'b1001: LD_SEL[9] = 1;
			4'b1010: LD_SEL[10] = 1;
			4'b1011: LD_SEL[11] = 1;
			4'b1100: LD_SEL[12] = 1;
			4'b1101: LD_SEL[13] = 1;
			4'b1110: LD_SEL[14] = 1;
			4'b1111: LD_SEL[15] = 1;
			default: LD_SEL = 16'b0;
		endcase
		// Selects which bytes of the WRITE DATA to be written.
		unique case (AVL_BYTE_EN)
			4'b1111: AVL_WRITEDATA_SEL = AVL_WRITEDATA;
			4'b1100: AVL_WRITEDATA_SEL = AVL_WRITEDATA & 32'h1110000;
			4'b0011: AVL_WRITEDATA_SEL = AVL_WRITEDATA & 32'h0001111;
			4'b1000: AVL_WRITEDATA_SEL = AVL_WRITEDATA & 32'h1100000;
			4'b0100: AVL_WRITEDATA_SEL = AVL_WRITEDATA & 32'h0010000;
			4'b0010: AVL_WRITEDATA_SEL = AVL_WRITEDATA & 32'h0001100;
			4'b0001: AVL_WRITEDATA_SEL = AVL_WRITEDATA & 32'h0000011;
			default: AVL_WRITEDATA_SEL = 32'b0;
		endcase
	end
	// Selects which Register to get READ Data from.
	if(AVL_READ && AVL_CS) begin
		unique case (AVL_ADDR)
			4'b0000: AVL_READDATA = AES_KEY0_OUT;
			4'b0001: AVL_READDATA = AES_KEY1_OUT;
			4'b0010: AVL_READDATA = AES_KEY2_OUT;
			4'b0011: AVL_READDATA = AES_KEY3_OUT;
			4'b0100: AVL_READDATA = AES_MSG_EN0_OUT;
			4'b0101: AVL_READDATA = AES_MSG_EN1_OUT;
			4'b0110: AVL_READDATA = AES_MSG_EN2_OUT;
			4'b0111: AVL_READDATA = AES_MSG_EN3_OUT;
			4'b1000: AVL_READDATA = AES_MSG_DE0_OUT;
			4'b1001: AVL_READDATA = AES_MSG_DE1_OUT;
			4'b1010: AVL_READDATA = AES_MSG_DE2_OUT;
			4'b1011: AVL_READDATA = AES_MSG_DE3_OUT;
			4'b1100: AVL_READDATA = 32'b0;
			4'b1101: AVL_READDATA = 32'b0;
			4'b1110: AVL_READDATA = AES_START_OUT & 32'h00000001;
			4'b1111: AVL_READDATA = AES_DONE_OUT & 32'h00000001;
			default: AVL_READDATA = 32'b0;
		endcase
	end

	EXPORT_DATA = {AES_KEY0_OUT[15:0],AES_KEY3_OUT[31:16]};

end

endmodule
