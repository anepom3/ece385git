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
logic [31:0] DE0_WRITEDATA_SEL;
logic [31:0] DE1_WRITEDATA_SEL;
logic [31:0] DE2_WRITEDATA_SEL;
logic [31:0] DE3_WRITEDATA_SEL;

logic [31:0] AES_DUMMY1_OUT;
logic [31:0] AES_DUMMY2_OUT;

logic [31:0] AES_START_OUT;

logic [31:0] AES_DONE_OUT;
logic [31:0] DONE_WRITEDATA_SEL;
logic [127:0] AES_KEY_comb;

logic [127:0] AES_MSG_ENC_comb;
logic [127:0] AES_MSG_DEC_comb;
logic AES_DONE_comb;
// Instantiating Decryption AES module
AES AES_Decryption (.CLK(CLK), .RESET(RESET),
						.AES_START(AES_START_OUT[0]), .AES_DONE(AES_DONE_comb),
	 					.AES_KEY(AES_KEY_comb), .AES_MSG_ENC(AES_MSG_ENC_comb),
						.AES_MSG_DEC(AES_MSG_DEC_comb)
						);

// Register Instantiations
REG AES_KEY0 (.CLK, .RESET, .LD(LD_SEL[0]), .DIN(AVL_WRITEDATA_SEL), .DOUT(AES_KEY0_OUT));
REG AES_KEY1 (.CLK, .RESET, .LD(LD_SEL[1]), .DIN(AVL_WRITEDATA_SEL), .DOUT(AES_KEY1_OUT));
REG AES_KEY2 (.CLK, .RESET, .LD(LD_SEL[2]), .DIN(AVL_WRITEDATA_SEL), .DOUT(AES_KEY2_OUT));
REG AES_KEY3 (.CLK, .RESET, .LD(LD_SEL[3]), .DIN(AVL_WRITEDATA_SEL), .DOUT(AES_KEY3_OUT));

REG AES_MSG_EN0 (.CLK, .RESET, .LD(LD_SEL[4]), .DIN(AVL_WRITEDATA_SEL), .DOUT(AES_MSG_EN0_OUT));
REG AES_MSG_EN1 (.CLK, .RESET, .LD(LD_SEL[5]), .DIN(AVL_WRITEDATA_SEL), .DOUT(AES_MSG_EN1_OUT));
REG AES_MSG_EN2 (.CLK, .RESET, .LD(LD_SEL[6]), .DIN(AVL_WRITEDATA_SEL), .DOUT(AES_MSG_EN2_OUT));
REG AES_MSG_EN3 (.CLK, .RESET, .LD(LD_SEL[7]), .DIN(AVL_WRITEDATA_SEL), .DOUT(AES_MSG_EN3_OUT));

REG AES_MSG_DE0 (.CLK, .RESET, .LD(LD_SEL[8]), .DIN(DE0_WRITEDATA_SEL), .DOUT(AES_MSG_DE0_OUT));
REG AES_MSG_DE1 (.CLK, .RESET, .LD(LD_SEL[9]), .DIN(DE1_WRITEDATA_SEL), .DOUT(AES_MSG_DE1_OUT));
REG AES_MSG_DE2 (.CLK, .RESET, .LD(LD_SEL[10]), .DIN(DE2_WRITEDATA_SEL), .DOUT(AES_MSG_DE2_OUT));
REG AES_MSG_DE3 (.CLK, .RESET, .LD(LD_SEL[11]), .DIN(DE3_WRITEDATA_SEL), .DOUT(AES_MSG_DE3_OUT));

REG AES_DUMMY1 (.CLK, .RESET, .LD(LD_SEL[12]), .DIN(AVL_WRITEDATA_SEL), .DOUT(AES_DUMMY1_OUT));
REG AES_DUMMY2 (.CLK, .RESET, .LD(LD_SEL[13]), .DIN(AVL_WRITEDATA_SEL), .DOUT(AES_DUMMY2_OUT));

REG AES_START (.CLK, .RESET, .LD(LD_SEL[14]), .DIN(AVL_WRITEDATA_SEL), .DOUT(AES_START_OUT));
REG AES_DONE (.CLK, .RESET, .LD(LD_SEL[15]), .DIN(DONE_WRITEDATA_SEL), .DOUT(AES_DONE_OUT));

always_comb begin
	// Initialize the LD_SEL to be all 0's at first.
	LD_SEL = 16'b0;
	AVL_WRITEDATA_SEL = 32'b0;
	AVL_READDATA = 32'b0;
	DE0_WRITEDATA_SEL = AVL_WRITEDATA_SEL;
	DE1_WRITEDATA_SEL = AVL_WRITEDATA_SEL;
	DE2_WRITEDATA_SEL = AVL_WRITEDATA_SEL;
	DE3_WRITEDATA_SEL = AVL_WRITEDATA_SEL;
  DONE_WRITEDATA_SEL = AVL_WRITEDATA_SEL;
	if(AES_DONE_comb && !(AVL_WRITE))begin
		LD_SEL[11:8] = 4'b1111;
		LD_SEL[15] = 1'b1;
		DE0_WRITEDATA_SEL = AES_MSG_DEC_comb[127:96];
		DE1_WRITEDATA_SEL = AES_MSG_DEC_comb[95:64];
		DE2_WRITEDATA_SEL = AES_MSG_DEC_comb[63:32];
		DE3_WRITEDATA_SEL = AES_MSG_DEC_comb[31:0];
		DONE_WRITEDATA_SEL = {28'h0000000,3'b000, AES_DONE_comb};
	end
	if(AVL_WRITE && AVL_CS) begin
		// Selects which Register to WRITE to.
		case (AVL_ADDR)
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
		case (AVL_BYTE_EN)
			4'b1111: AVL_WRITEDATA_SEL = AVL_WRITEDATA;
			4'b1100: AVL_WRITEDATA_SEL = AVL_WRITEDATA & 32'h11110000;
			4'b0011: AVL_WRITEDATA_SEL = AVL_WRITEDATA & 32'h00001111;
			4'b1000: AVL_WRITEDATA_SEL = AVL_WRITEDATA & 32'h11000000;
			4'b0100: AVL_WRITEDATA_SEL = AVL_WRITEDATA & 32'h00110000;
			4'b0010: AVL_WRITEDATA_SEL = AVL_WRITEDATA & 32'h00001100;
			4'b0001: AVL_WRITEDATA_SEL = AVL_WRITEDATA & 32'h00000011;
			default: AVL_WRITEDATA_SEL = 32'b0;
		endcase
	end
	// Selects which Register to get READ Data from.
	if(AVL_READ && AVL_CS) begin
		case (AVL_ADDR)
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

	EXPORT_DATA[0] = AES_KEY3_OUT[0];
	EXPORT_DATA[1] = AES_KEY3_OUT[1];
	EXPORT_DATA[2] = AES_KEY3_OUT[2];
	EXPORT_DATA[3] = AES_KEY3_OUT[3];

	EXPORT_DATA[4] = AES_KEY3_OUT[4];
	EXPORT_DATA[5] = AES_KEY3_OUT[5];
	EXPORT_DATA[6] = AES_KEY3_OUT[6];
	EXPORT_DATA[7] = AES_KEY3_OUT[7];

	EXPORT_DATA[8] = AES_KEY3_OUT[8];
	EXPORT_DATA[9] = AES_KEY3_OUT[9];
	EXPORT_DATA[10] = AES_KEY3_OUT[10];
	EXPORT_DATA[11] = AES_KEY3_OUT[11];

	EXPORT_DATA[12] = AES_KEY3_OUT[12];
	EXPORT_DATA[13] = AES_KEY3_OUT[13];
	EXPORT_DATA[14] = AES_KEY3_OUT[14];
	EXPORT_DATA[15] = AES_KEY3_OUT[15];

	EXPORT_DATA[16] = AES_KEY0_OUT[16];
	EXPORT_DATA[17] = AES_KEY0_OUT[17];
	EXPORT_DATA[18] = AES_KEY0_OUT[18];
	EXPORT_DATA[19] = AES_KEY0_OUT[19];

	EXPORT_DATA[20] = AES_KEY0_OUT[20];
	EXPORT_DATA[21] = AES_KEY0_OUT[21];
	EXPORT_DATA[22] = AES_KEY0_OUT[22];
	EXPORT_DATA[23] = AES_KEY0_OUT[23];

	EXPORT_DATA[24] = AES_KEY0_OUT[24];
	EXPORT_DATA[25] = AES_KEY0_OUT[25];
	EXPORT_DATA[26] = AES_KEY0_OUT[26];
	EXPORT_DATA[27] = AES_KEY0_OUT[27];

	EXPORT_DATA[28] = AES_KEY0_OUT[28];
	EXPORT_DATA[29] = AES_KEY0_OUT[29];
	EXPORT_DATA[30] = AES_KEY0_OUT[30];
	EXPORT_DATA[31] = AES_KEY0_OUT[31];

	AES_KEY_comb = {AES_KEY0_OUT, AES_KEY1_OUT, AES_KEY2_OUT, AES_KEY3_OUT};
	AES_MSG_ENC_comb = {AES_MSG_EN0_OUT, AES_MSG_EN1_OUT, AES_MSG_EN2_OUT, AES_MSG_EN3_OUT};


end

endmodule
