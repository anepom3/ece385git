
module lab7_soc (
	clk_clk,
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
	reset_reset_n,
	sdram_clk_clk);	

	input		clk_clk;
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
	input		reset_reset_n;
	output		sdram_clk_clk;
endmodule
