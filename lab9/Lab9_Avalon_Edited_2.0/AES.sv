/************************************************************************
AES Decryption Core Logic

Dong Kai Wang, Fall 2017

For use with ECE 385 Experiment 9
University of Illinois ECE Department
************************************************************************/

module AES (
	input	 logic CLK,
	input  logic RESET,
	input  logic AES_START,
	output logic AES_DONE,
	input  logic [127:0] AES_KEY,
	input  logic [127:0] AES_MSG_ENC,
	output logic [127:0] AES_MSG_DEC
);

// Internal Wires
logic [127:0]AddRoundKey_OUT
logic [127:0]InvShiftRows_OUT
logic [127:0]InvSubBytes_Statewise_OUT
logic [31:0]InvMixColumns_OUT

// Instantiating Modules
StateDriver state_driver(.Clk(CLK), .Reset(RESET),
												 .Start_h(AES_START),
												 .KeySchedule(),

												 .update_state(), .WORD_SEL(),
												 .OUTPUT_SEL(), .out_key);

AddRoundKey add_round_key(.key(AES_KEY), .in(), .out());
InvShiftRows inv_shift_rows(.data_in(), .data_out());
InvSubBytes_Statewise inv_sub(.clk(CLK), .data_in(), .data_out());
WordSelMUX word_sel_mux(.state(), .WORD_SEL(), .out_word());
InvMixColumns inv_mix_col(.in(), .out());


endmodule

StateUpdateBuffer state_update_buffer(.Clk(CLK), .update_state(),
																			.Inv_Mix_Columns_Word_Val(InvMixColumns_OUT),
																			.Add_Round_Key_Val(AddRoundKey_OUT),
																			.Inv_Shift_Rows_Val(InvShiftRows_OUT),
																			.Inv_Sub_Bytes_Val(InvSubBytes_Statewise_OUT),
																			.state_in(),
																			.WORD_SEL(),
																			.state_out()
																		);
