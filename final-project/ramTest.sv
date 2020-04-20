module testbench();

timeunit 10ns;

timeprecision 1ns;

// Declare internal logics HERE
//logic [23:0] data_In;
//logic [9:0] write_address;
//logic [9:0] read_address;
//logic we;
logic Clk;

//logic [23:0] data_Out;

logic [1:0] ShooterFace;
logic [9:0] ShooterX, ShooterY, DrawX, DrawY;
//logic is_shooter;
//logic [7:0] SpriteR, SpriteG, SpriteB;
logic [7:0] VGA_R, VGA_G, VGA_B;
// Instantiate test RAM module for OCM (on-chip memory)

//S_Up_RAM testRam (.*, .write_address(10'b0), .we(1'b0), .data_In(24'b0));
//SpriteTable_S spritetable(.*);
color_mapper mapper(.*);
always begin : CLOCK_GENERATION

#1 Clk = ~Clk;

end

initial begin : CLOCK_INITIALIZATION
	Clk = 0;
end

initial begin: TEST_VECTORS
#5;

// #5 read_address = 10'h0;
//
// #5 read_address = 10'hf;
//
// #5 read_address = 10'h10;
//
// #5 read_address = 10'h11;
//
// #5 read_address = 10'd1018;
//
// #5 read_address = 10'd1023;
//
// #2 read_address = 10'd985;
#5;
	ShooterX = 10'd32;
	ShooterY = 10'd62;
	DrawX = 10'd32;
	DrawY = 10'd62;
#5;
#5;
	DrawX = 10'd32 + 2;
	DrawY = 10'd62 + 2;
#5;
#5;
	DrawX = 10'd32 + 2;
	DrawY = 10'd62 + 31;
#5;
#5;
	DrawX = 10'd32 + 7;
	DrawY = 10'd62 + 29;
#5;
end

endmodule
