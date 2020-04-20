module KeycodeHandler (
                       input logic [7:0] keycode0, keycode1,
                       output logic [2:0] ShooterMove,
                       output logic is_shot
  );

  always_comb begin
      ShooterMove = 3'b000; // if no key is pressed, don't move
      is_shot = 1'b0; // assume no shot
      if((keycode0 == 8'h2c) || (keycode1 == 8'h2c))
        is_shot = 1'b1;

      if((keycode1 == 8'h04) || (keycode1 == 8'h07) || (keycode1 == 8'h16) || (keycode1 == 8'h1a))
      begin
        case (keycode1)
          8'h04: ShooterMove = 3'b100; // a = left
          8'h07: ShooterMove = 3'b010; // d = right
          8'h16: ShooterMove = 3'b011; // s = down
          8'h1a: ShooterMove = 3'b001; // w = up
          default: ;
        endcase
      end

      if((keycode0 == 8'h04) || (keycode0 == 8'h07) || (keycode0 == 8'h16) || (keycode0 == 8'h1a)) // first key takes precedence
      begin
        case (keycode0)
          8'h04: ShooterMove = 3'b100; // a = left
          8'h07: ShooterMove = 3'b010; // d = right
          8'h16: ShooterMove = 3'b011; // s = down
          8'h1a: ShooterMove = 3'b001; // w = up
          default: ;
        endcase
      end

  end

endmodule // KeycodeHndler
