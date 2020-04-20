/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */

module  S_Up_RAM
(
//		input [4:0] data_In,
//		input [18:0] write_address,
    input [9:0] read_address,
//		input we,
    input Clk,

		output logic [23:0] data_Out // 24-bit RGB color
);

// mem has width of 24 bits (R,G,B) and a total of 1024 addresses (32x32)
logic [23:0] mem [0:1023];

initial
begin
	 $readmemh("sprite_bytes/ShooterUP32x32.txt", mem);
end


always_ff @ (posedge Clk) begin
	//if (we)
		//mem[write_address] <= data_In;
	data_Out<= mem[read_address];
end

endmodule
