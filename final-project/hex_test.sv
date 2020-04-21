module hex_test(
               input CLOCK_50,
               input        [3:0]  KEY,          //bit 0 is set up as Reset
               output logic [6:0]  HEX0, HEX1, HEX2, HEX3,
                                   HEX4, HEX5);

logic Reset_h, Clk;

logic [9:0] read_address_comb;
logic [23:0] data_comb;
logic ADD;


assign Clk = CLOCK_50;

always_ff @ (posedge Clk) begin
    Reset_h <= ~(KEY[0]);        // The push buttons are active low
end

S_Up_RAM up_ram_inst(.Clk, .we(1'b0), .data_In(24'b0), .write_address(10'b0),
                     .read_address(read_address_comb), .data_Out(data_comb));
REG reg_inst(.Clk, .Reset_h, .ADD, .Data_Out(read_address_comb));
sync button_sync (.Clk, .d(~KEY[1]), .q(ADD));

// Display keycode on hex display
HexDriver hex_inst_0 (data_comb[3:0], HEX0);
HexDriver hex_inst_1 (data_comb[7:4], HEX1);
HexDriver hex_inst_2 (data_comb[11:8], HEX2);
HexDriver hex_inst_3 (data_comb[15:12], HEX3);
HexDriver hex_inst_4 (data_comb[19:16], HEX4);
HexDriver hex_inst_5 (data_comb[23:20], HEX5);

endmodule

// This module keeps track of the address we're on.
module REG(input  logic Clk, Reset_h, ADD,
           output logic [9:0]  Data_Out);

    logic [9:0] data;
    logic new_state, past_state;
    always_ff @ (posedge Clk)
    begin
	 	 if (Reset_h) //notice, this is a sycnrhonous reset, which is recommended on the FPGA
			Data_Out <= 10'h0;
		 else
      begin
        Data_Out <= data;
        past_state <= new_state;
      end
    end

    always_comb begin
      // If we're adding...
      if(ADD && (~past_state))
      begin
        if(data == 10'd1023)
            data = 10'd0;
        else
          data = Data_Out + 10'd1;
      end
      // Otherwise keep everything the same.
      else
        data = Data_Out;
      new_state = ADD;
    end
endmodule
