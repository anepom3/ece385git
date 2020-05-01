module SpriteTable_Z (
                         input Clk,
                         input [1:0] Zombie0Face, Zombie1Face, Zombie2Face,
                         input [9:0] Zombie0X, Zombie0Y, Zombie1X, Zombie1Y, Zombie2X, Zombie2Y,
                         input [9:0] DrawX, DrawY,
                         output logic is_zombie,
                         output logic [7:0] SpriteR, SpriteG, SpriteB
  );

  logic [9:0] read_address_comb;
  logic [23:0] SpriteColorU, SpriteColorD, SpriteColorL, SpriteColorR; // make 4 of these for each direction
  logic [1:0] face_sel;

  always_comb
  begin // begin of always comb
	 SpriteR = 8'hff;
	 SpriteG = 8'hff;
	 SpriteB = 8'hff;
   face_sel = 2'b00;
   read_address_comb = 10'd0;
    if((DrawX >= Zombie0X) && (DrawX < Zombie0X + 32) && (DrawY >= Zombie0Y) && (DrawY < Zombie0Y + 32))
    begin
      read_address_comb = ((DrawY - Zombie0Y) << 5) + (DrawX - Zombie0X);
      is_zombie = 1;
      face_sel = Zombie0Face;
    end
    else if((DrawX >= Zombie1X) && (DrawX < Zombie1X + 32) && (DrawY >= Zombie1Y) && (DrawY < Zombie1Y + 32))
    begin
      read_address_comb = ((DrawY - Zombie1Y) << 5) + (DrawX - Zombie1X);
      is_zombie = 1;
      face_sel = Zombie1Face;
    end
    else if((DrawX >= Zombie2X) && (DrawX < Zombie2X + 32) && (DrawY >= Zombie2Y) && (DrawY < Zombie2Y + 32))
    begin
      read_address_comb = ((DrawY - Zombie2Y) << 5) + (DrawX - Zombie2X);
      is_zombie = 1;
      face_sel = Zombie2Face;
    end
    else
    begin
      is_zombie = 0;
    end

    if(is_zombie)
    begin
      if(face_sel == 2'b00)
      begin
        SpriteR = SpriteColorU[23:16];
        SpriteG = SpriteColorU[15:8];
        SpriteB = SpriteColorU[7:0];
      end
      if(face_sel == 2'b01)
      begin
        SpriteR = SpriteColorR[23:16];
        SpriteG = SpriteColorR[15:8];
        SpriteB = SpriteColorR[7:0];
      end
      if(face_sel == 2'b10)
      begin
        SpriteR = SpriteColorD[23:16];
        SpriteG = SpriteColorD[15:8];
        SpriteB = SpriteColorD[7:0];
      end
      if(face_sel == 2'b11)
      begin
        SpriteR = SpriteColorL[23:16];
        SpriteG = SpriteColorL[15:8];
        SpriteB = SpriteColorL[7:0];
      end
    end
    else
    begin
      SpriteR = 8'hff;
      SpriteG = 8'hff;
      SpriteB = 8'hff;
    end
  end // end of always comb


  Z_Up_RAM Z_Up_RAM_inst(.data_In(24'd0), .we(1'b0), .write_address(10'd0), .read_address(read_address_comb), .Clk(Clk), .data_Out(SpriteColorU));
  Z_Down_RAM Z_Down_RAM_inst(.read_address(read_address_comb), .Clk(Clk), .data_Out(SpriteColorD));
  Z_Left_RAM Z_Left_RAM_inst(.read_address(read_address_comb), .Clk(Clk), .data_Out(SpriteColorL));
  Z_Right_RAM Z_Right_RAM_inst(.read_address(read_address_comb), .Clk(Clk), .data_Out(SpriteColorR));

endmodule // SpriteTable_S_UP
