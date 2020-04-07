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
logic [127:0]AddRoundKey_OUT;
logic [127:0]InvShiftRows_OUT;
logic [127:0]InvSubBytes_Statewise_OUT;
logic [31:0]InvMixColumns_OUT;
logic [31:0]InvMixColumns_IN;
logic [1407:0]KeySchedule;
logic [127:0] out_key;
logic [1:0]WORD_SEL;
logic [1:0]OUTPUT_SEL;
logic update_state;
logic inititalize;

// Instantiating Modules
StateDriver state_driver(.Clk(CLK), .Reset(RESET),
												 .Start_h(AES_START),
												 .KeySchedule(KeySchedule),

												 .update_state(update_state), .initialize(initialize),
												 .WORD_SEL(WORD_SEL), .OUTPUT_SEL(OUTPUT_SEL), .out_key(out_key));

KeyExpansion key_exapansion(.clk(CLK), .Cipherkey(AES_KEY), .KeySchedule(KeySchedule));

AddRoundKey add_round_key(.key(out_key), .in(AES_MSG_DEC), .out(AddRoundKey_OUT));
InvShiftRows inv_shift_rows(.data_in(AES_MSG_DEC), .data_out(InvShiftRows_OUT));
InvSubBytes_Statewise inv_sub(.clk(CLK), .data_in(AES_MSG_DEC), .data_out(InvSubBytes_Statewise_OUT));
WordSelMUX word_sel_mux(.state(AES_MSG_DEC), .WORD_SEL(WORD_SEL), .out_word(InvMixColumns_IN));
InvMixColumns inv_mix_col(.in(InvMixColumns_IN), .out(InvMixColumns_OUT));

StateUpdateBuffer state_update_buffer(.Clk(CLK), .update_state(update_state), .initialize(initialize),
																			.initial_state(AES_MSG_ENC),
																			.Inv_Mix_Columns_Word_Val(InvMixColumns_OUT),
																			.Add_Round_Key_Val(AddRoundKey_OUT),
																			.Inv_Shift_Rows_Val(InvShiftRows_OUT),
																			.Inv_Sub_Bytes_Val(InvSubBytes_Statewise_OUT),
																			.state_in(AES_MSG_DEC),
																			.WORD_SEL(WORD_SEL),
																			.state_out(AES_MSG_DEC)
																		);

endmodule
