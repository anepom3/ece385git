module SpriteTable_S (
                         input Clk,
                         input [1:0] ShooterFace,
                         input [9:0] ShooterX, ShooterY, DrawX, DrawY,
                         output logic is_shooter,
                         output logic [7:0] SpriteR, SpriteG, SpriteB
  );

  logic [9:0] read_address_comb;
  logic [23:0] SpriteColor; // make 4 of these for each direction

  always_comb
  begin
    read_address_comb = 10'd0;
    if((DrawX >= ShooterX) && (DrawX < ShooterX + 32) && (DrawY >= ShooterY) && (DrawY < ShooterY + 32)) // get shooter pixel
    begin
      // ADD IN SHOOTERFACE CHECK AND OTHER 3 SHOOTER SPRITES!!!
      is_shooter = 1;
      read_address_comb = (32 * (DrawX - ShooterX)) + (DrawY - ShooterY);
      if(ShooterFcae == 2'b00)
      begin
        SpriteR = SpriteColor[7:0];
        SpriteG = SpriteColor[15:8];
        SpriteB = SpriteColor[23:6];
      end
      else
      begin
        SpriteR = 8'h00;
        SpriteG = 8'h00;
        SpriteB = 8'h00;
      end
    end
  end
  else
  begin
    is_shooter = 0;
    SpriteR = 8'hff;
    SpriteG = 8'hff;
    SpriteB = 8'hff;
  end



  S_Up_RAM S_Up_RAM_inst(.read_address(read_address_comb), .Clk(Clk), .data_Out(SpriteColor));

  // Make other 3 sprite image renderings and make RAM modules for them
  //  S_Down_RAM S_Down_RAM_inst(.read_address(read_address_comb), .Clk(Clk), .data_Out(SpriteColor));
  //  S_Left_RAM S_Left_RAM_inst(.read_address(read_address_comb), .Clk(Clk), .data_Out(SpriteColor));
  //  S_Right_RAM S_Right_RAM_inst(.read_address(read_address_comb), .Clk(Clk), .data_Out(SpriteColor));

endmodule // SpriteTable_S_UP
