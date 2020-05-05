module SpriteTable_Z (
                         input Clk,
                         input [1:0] Zombie0Face, Zombie1Face, Zombie2Face, Zombie3Face, Zombie4Face,
                         input [1:0] Zombie5Face, Zombie6Face, Zombie7Face, Zombie8Face, Zombie9Face,
                         input logic [9:0] Zombie0X, Zombie1X, Zombie2X, Zombie3X, Zombie4X,
                         input logic [9:0] Zombie5X, Zombie6X, Zombie7X, Zombie8X, Zombie9X,
                         input logic [9:0] Zombie0Y, Zombie1Y, Zombie2Y, Zombie3Y, Zombie4Y,
                         input logic [9:0] Zombie5Y, Zombie6Y, Zombie7Y, Zombie8Y, Zombie9Y,
                         input zombie_0_live, zombie_1_live, zombie_2_live, zombie_3_live, zombie_4_live,
                         input zombie_5_live, zombie_6_live, zombie_7_live, zombie_8_live, zombie_9_live,
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
   is_zombie = 1'b0;
    if((DrawX >= Zombie0X) && (DrawX < Zombie0X + 32) && (DrawY >= Zombie0Y) && (DrawY < Zombie0Y + 32))
    begin
      read_address_comb = ((DrawY - Zombie0Y) << 5) + (DrawX - Zombie0X);
      if(zombie_0_live)
        is_zombie = 1'b1;
      face_sel = Zombie0Face;
    end
    else if((DrawX >= Zombie1X) && (DrawX < Zombie1X + 32) && (DrawY >= Zombie1Y) && (DrawY < Zombie1Y + 32))
    begin
      read_address_comb = ((DrawY - Zombie1Y) << 5) + (DrawX - Zombie1X);
      if(zombie_1_live)
        is_zombie = 1'b1;
      face_sel = Zombie1Face;
    end
    else if((DrawX >= Zombie2X) && (DrawX < Zombie2X + 32) && (DrawY >= Zombie2Y) && (DrawY < Zombie2Y + 32))
    begin
      read_address_comb = ((DrawY - Zombie2Y) << 5) + (DrawX - Zombie2X);
      if(zombie_2_live)
        is_zombie = 1'b1;
      face_sel = Zombie2Face;
    end
    else if((DrawX >= Zombie3X) && (DrawX < Zombie3X + 32) && (DrawY >= Zombie3Y) && (DrawY < Zombie3Y + 32))
    begin
      read_address_comb = ((DrawY - Zombie3Y) << 5) + (DrawX - Zombie3X);
      if(zombie_3_live)
        is_zombie = 1'b1;
      face_sel = Zombie3Face;
    end
    else if((DrawX >= Zombie4X) && (DrawX < Zombie4X + 32) && (DrawY >= Zombie4Y) && (DrawY < Zombie4Y + 32))
    begin
      read_address_comb = ((DrawY - Zombie4Y) << 5) + (DrawX - Zombie4X);
      if(zombie_4_live)
        is_zombie = 1'b1;
      face_sel = Zombie4Face;
    end
    else if((DrawX >= Zombie5X) && (DrawX < Zombie5X + 32) && (DrawY >= Zombie5Y) && (DrawY < Zombie5Y + 32))
    begin
      read_address_comb = ((DrawY - Zombie5Y) << 5) + (DrawX - Zombie5X);
      if(zombie_5_live)
        is_zombie = 1'b1;
      face_sel = Zombie5Face;
    end
    else if((DrawX >= Zombie6X) && (DrawX < Zombie6X + 32) && (DrawY >= Zombie6Y) && (DrawY < Zombie6Y + 32))
    begin
      read_address_comb = ((DrawY - Zombie6Y) << 5) + (DrawX - Zombie6X);
      if(zombie_6_live)
        is_zombie = 1'b1;
      face_sel = Zombie6Face;
    end
    else if((DrawX >= Zombie7X) && (DrawX < Zombie7X + 32) && (DrawY >= Zombie7Y) && (DrawY < Zombie7Y + 32))
    begin
      read_address_comb = ((DrawY - Zombie7Y) << 5) + (DrawX - Zombie7X);
      if(zombie_7_live)
        is_zombie = 1'b1;
      face_sel = Zombie7Face;
    end
    else if((DrawX >= Zombie8X) && (DrawX < Zombie8X + 32) && (DrawY >= Zombie8Y) && (DrawY < Zombie8Y + 32))
    begin
      read_address_comb = ((DrawY - Zombie8Y) << 5) + (DrawX - Zombie8X);
      if(zombie_8_live)
        is_zombie = 1'b1;
      face_sel = Zombie8Face;
    end
    else if((DrawX >= Zombie9X) && (DrawX < Zombie9X + 32) && (DrawY >= Zombie9Y) && (DrawY < Zombie9Y + 32))
    begin
      read_address_comb = ((DrawY - Zombie9Y) << 5) + (DrawX - Zombie9X);
      if(zombie_9_live)
        is_zombie = 1'b1;
      face_sel = Zombie9Face;
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
