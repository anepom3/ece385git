module SpriteTable_Z (
                         input Clk,
                         input [1:0] ZombieFace,
                         input [9:0] ZombieX, ZombieY, DrawX, DrawY,
                         output logic is_zombie,
                         output logic [7:0] SpriteR, SpriteG, SpriteB
  );

  logic [9:0] read_address_comb;
  logic [23:0] SpriteColorU, SpriteColorD, SpriteColorL, SpriteColorR; // make 4 of these for each direction

  always_comb
  begin
    // read_address_comb = 10'd0;
    read_address_comb = ((DrawY - ZombieY) << 5) + (DrawX - ZombieX); // try hard coding if doesn't work
	 SpriteR = 8'hff;
	 SpriteG = 8'hff;
	 SpriteB = 8'hff;
    if((DrawX >= ZombieX) && (DrawX < ZombieX + 32) && (DrawY >= ZombieY) && (DrawY < ZombieY + 32)) // get zombie pixel
    begin
      // ADD IN SHOOTERFACE CHECK AND OTHER 3 SHOOTER SPRITES!!!
      is_zombie = 1;
      if(ZombieFace == 2'b00)
      begin
        SpriteR = SpriteColorU[23:16];
        SpriteG = SpriteColorU[15:8];
        SpriteB = SpriteColorU[7:0];
      end
      if(ZombieFace == 2'b01)
      begin
        SpriteR = SpriteColorR[23:16];
        SpriteG = SpriteColorR[15:8];
        SpriteB = SpriteColorR[7:0];
      end
      if(ZombieFace == 2'b10)
      begin
        SpriteR = SpriteColorD[23:16];
        SpriteG = SpriteColorD[15:8];
        SpriteB = SpriteColorD[7:0];
      end
      if(ZombieFace == 2'b11)
      begin
        SpriteR = SpriteColorL[23:16];
        SpriteG = SpriteColorL[15:8];
        SpriteB = SpriteColorL[7:0];
      end
    end
    else
    begin
      is_zombie = 0;
      SpriteR = 8'hff;
      SpriteG = 8'hff;
      SpriteB = 8'hff;
    end
  end


  Z_Up_RAM Z_Up_RAM_inst(.data_In(24'd0), .we(1'b0), .write_address(10'd0), .read_address(read_address_comb), .Clk(Clk), .data_Out(SpriteColorU));

  // Make other 3 sprite image renderings and make RAM modules for them
   Z_Down_RAM Z_Down_RAM_inst(.read_address(read_address_comb), .Clk(Clk), .data_Out(SpriteColorD));
   Z_Left_RAM Z_Left_RAM_inst(.read_address(read_address_comb), .Clk(Clk), .data_Out(SpriteColorL));
   Z_Right_RAM Z_Right_RAM_inst(.read_address(read_address_comb), .Clk(Clk), .data_Out(SpriteColorR));

endmodule // SpriteTable_S_UP
