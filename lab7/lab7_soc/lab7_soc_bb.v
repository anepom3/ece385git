
module lab7_soc (
	led_wire_export,
	nios2_gen2_0_irq_irq,
	nios2_gen2_0_custom_instruction_master_readra,
	sdram_wire_addr,
	sdram_wire_ba,
	sdram_wire_cas_n,
	sdram_wire_cke,
	sdram_wire_cs_n,
	sdram_wire_dq,
	sdram_wire_dqm,
	sdram_wire_ras_n,
	sdram_wire_we_n,
	sdram_clk_clk,
	reset_reset_n,
	clk_clk,
	button_wire_export,
	sw_wire_export);	

	output	[7:0]	led_wire_export;
	input	[31:0]	nios2_gen2_0_irq_irq;
	output		nios2_gen2_0_custom_instruction_master_readra;
	output	[12:0]	sdram_wire_addr;
	output	[1:0]	sdram_wire_ba;
	output		sdram_wire_cas_n;
	output		sdram_wire_cke;
	output		sdram_wire_cs_n;
	inout	[15:0]	sdram_wire_dq;
	output	[1:0]	sdram_wire_dqm;
	output		sdram_wire_ras_n;
	output		sdram_wire_we_n;
	output		sdram_clk_clk;
	input		reset_reset_n;
	input		clk_clk;
	input	[1:0]	button_wire_export;
	input	[7:0]	sw_wire_export;
endmodule
