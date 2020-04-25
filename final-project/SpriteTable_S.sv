module SpriteTable_S (
                         input Clk,
                         input [1:0] ShooterFace,
                         input [9:0] ShooterX, ShooterY, DrawX, DrawY,
                         output logic is_shooter,
                         output logic [7:0] SpriteR, SpriteG, SpriteB
  );

  logic [9:0] read_address_comb;
  logic [23:0] SpriteColorU, SpriteColorD, SpriteColorL, SpriteColorR; // make 4 of these for each direction

  always_comb
  begin
    // read_address_comb = 10'd0;
    read_address_comb = ((DrawY - ShooterY) << 5) + (DrawX - ShooterX); // try hard coding if doesn't work
	 SpriteR = 8'hff;
	 SpriteG = 8'hff;
	 SpriteB = 8'hff;
    if((DrawX >= ShooterX) && (DrawX < ShooterX + 32) && (DrawY >= ShooterY) && (DrawY < ShooterY + 32)) // get shooter pixel
    begin
      // ADD IN SHOOTERFACE CHECK AND OTHER 3 SHOOTER SPRITES!!!
      is_shooter = 1;
      if(ShooterFace == 2'b00)
      begin
        SpriteR = SpriteColorU[23:16];
        SpriteG = SpriteColorU[15:8];
        SpriteB = SpriteColorU[7:0];
      end
      if(ShooterFace == 2'b01)
      begin
        SpriteR = SpriteColorR[23:16];
        SpriteG = SpriteColorR[15:8];
        SpriteB = SpriteColorR[7:0];
      end
      if(ShooterFace == 2'b10)
      begin
        SpriteR = SpriteColorD[23:16];
        SpriteG = SpriteColorD[15:8];
        SpriteB = SpriteColorD[7:0];
      end
      if(ShooterFace == 2'b11)
      begin
        SpriteR = SpriteColorL[23:16];
        SpriteG = SpriteColorL[15:8];
        SpriteB = SpriteColorL[7:0];
      end
    end
    else
    begin
      is_shooter = 0;
      SpriteR = 8'hff;
      SpriteG = 8'hff;
      SpriteB = 8'hff;
    end
  end


  S_Up_RAM S_Up_RAM_inst(.data_In(24'd0), .we(1'b0), .write_address(10'd0), .read_address(read_address_comb), .Clk(Clk), .data_Out(SpriteColorU));

  // Make other 3 sprite image renderings and make RAM modules for them
   S_Down_RAM S_Down_RAM_inst(.read_address(read_address_comb), .Clk(Clk), .data_Out(SpriteColorD));
   S_Left_RAM S_Left_RAM_inst(.read_address(read_address_comb), .Clk(Clk), .data_Out(SpriteColorL));
   S_Right_RAM S_Right_RAM_inst(.read_address(read_address_comb), .Clk(Clk), .data_Out(SpriteColorR));

endmodule // SpriteTable_S_UP
