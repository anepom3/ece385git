module Bullet (input logic Clk, Reset, frame_clk,
               input logic fire_bullet,
               input logic remove_bullet,
               input logic [1:0] ShooterFace,
               input logic [9:0] ShooterX,ShooterY,
               input logic [0:14][0:19] barrier,
               output logic [9:0] BulletX, BulletY,
               output logic [1:0] Bullet_Direction,
               output logic Bullet_Live
  );

  parameter [9:0] Bullet_X_Center = 10'd319;  // Center position on the X axis (640/2 = 320-16 = 304-1 = 303 + 16 = 319)
  parameter [9:0] Bullet_Y_Center = 10'd198;  // Center position on the Y axis (480/2 = 240-25 = 215-16 = 199-1 = 198)
  parameter [9:0] Bullet_X_Min = 10'd32;       // Leftmost point on the X axis (20 + 12)
  parameter [9:0] Bullet_X_Max = 10'd605;     // Rightmost point on the X axis (639 - 20 - 12 - 2)
  parameter [9:0] Bullet_Y_Min = 10'd64;       // Topmost point on the Y axis (50 + 12)
  parameter [9:0] Bullet_Y_Max = 10'd445;     // Bottommost point on the Y axis (479 - 20 - 12 - 2)
  parameter [9:0] Bullet_X_Step = 10'd4;      // Step size on the X axis
  parameter [9:0] Bullet_Y_Step = 10'd4;      // Step size on the Y axis

  logic [9:0] Bullet_X_Pos, Bullet_X_Motion, Bullet_Y_Pos, Bullet_Y_Motion;
  logic [9:0] Bullet_X_Pos_in, Bullet_X_Motion_in, Bullet_Y_Pos_in, Bullet_Y_Motion_in;
  logic [1:0] Bullet_Direction_Comb, Bullet_Direction_Comb_in;
  logic Bullet_Live_Comb, Bullet_Live_Comb_in;

  assign BulletX = Bullet_X_Pos;
  assign BulletY = Bullet_Y_Pos;
  assign Bullet_Direction = Bullet_Direction_Comb;
  assign Bullet_Live = Bullet_Live_Comb;

  //////// Do not modify the always_ff blocks. ////////
  // Detect rising edge of frame_clk
  logic frame_clk_delayed, frame_clk_rising_edge;
  always_ff @ (posedge Clk) begin
      frame_clk_delayed <= frame_clk;
      frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
  end
  // Update registers
  always_ff @ (posedge Clk)
  begin
      if (Reset)
      begin
          Bullet_X_Pos <= Bullet_X_Center;
          Bullet_Y_Pos <= Bullet_Y_Center;
          Bullet_X_Motion <= 10'd0;
          Bullet_Y_Motion <= 10'd0;
          Bullet_Direction_Comb <= 2'b00;
          Bullet_Live_Comb <= 1'b0;
      end
      else
      begin
          Bullet_X_Pos <= Bullet_X_Pos_in;
          Bullet_Y_Pos <= Bullet_Y_Pos_in;
          Bullet_X_Motion <= Bullet_X_Motion_in;
          Bullet_Y_Motion <= Bullet_Y_Motion_in;
          Bullet_Direction_Comb <= Bullet_Direction_Comb_in;
          Bullet_Live_Comb <= Bullet_Live_Comb_in;
      end
  end
  //////// Do not modify the always_ff blocks. ////////

always_comb begin
    Bullet_X_Pos_in = Bullet_X_Pos;
    Bullet_Y_Pos_in = Bullet_Y_Pos;
    Bullet_X_Motion_in = Bullet_X_Motion;
    Bullet_Y_Motion_in = Bullet_Y_Motion;
    Bullet_Direction_Comb_in = Bullet_Direction_Comb;
    Bullet_Live_Comb_in = Bullet_Live_Comb;

    if(frame_clk_rising_edge)
    begin
      // this means that the bullet hit a zombie, stop tracking bullet
      if(remove_bullet)
      begin
          Bullet_Live_Comb_in = 1'b0;
      end

      // this means that the bullet needs to start traveling on it's own now
      if(fire_bullet)
      begin
          Bullet_Live_Comb_in = 1'b1; // make bullet live to print
          Bullet_Direction_Comb_in = ShooterFace; // set it's direction and speed
          case (Bullet_Direction_Comb_in)
            2'b00:
              begin
                Bullet_X_Pos_in = ShooterX + 10'd16;
                Bullet_Y_Pos_in = ShooterY;
                Bullet_X_Motion_in = 10'd0;
                Bullet_Y_Motion_in = (~(Bullet_Y_Step) + 1'b1);
              end
            2'b01:
              begin
                Bullet_X_Pos_in = ShooterX + 10'd31;
                Bullet_Y_Pos_in = ShooterY + 10'd16;
                Bullet_X_Motion_in = Bullet_X_Step;
                Bullet_Y_Motion_in = 10'd0;
              end
            2'b10:
              begin
                Bullet_X_Pos_in = ShooterX + 10'd16;
                Bullet_Y_Pos_in = ShooterY + 10'd31;
                Bullet_X_Motion_in = 10'd0;
                Bullet_Y_Motion_in = Bullet_Y_Step;
              end
            2'b11:
              begin
                Bullet_X_Pos_in = ShooterX;
                Bullet_Y_Pos_in = ShooterY + 10'd16;
                Bullet_X_Motion_in = (~(Bullet_X_Step) + 1'b1);
                Bullet_Y_Motion_in = 10'd0;
              end
            default:
              begin
                Bullet_X_Pos_in = ShooterX + 10'd16;
                Bullet_Y_Pos_in = ShooterY;
                Bullet_X_Motion_in = 10'd0;
                Bullet_Y_Motion_in = 10'd0;
              end
          endcase
      end

      // if bullet is not live
      if(~Bullet_Live_Comb)
      begin
          // track bullet location/direction in refernce to shooter
          Bullet_Direction_Comb_in = ShooterFace;
          case (Bullet_Direction_Comb_in)
            2'b00:
              begin
                Bullet_X_Pos_in = ShooterX + 10'd16;
                Bullet_Y_Pos_in = ShooterY;
              end
            2'b01:
              begin
                Bullet_X_Pos_in = ShooterX + 10'd31;
                Bullet_Y_Pos_in = ShooterY + 10'd16;
              end
            2'b10:
              begin
                Bullet_X_Pos_in = ShooterX + 10'd16;
                Bullet_Y_Pos_in = ShooterY + 10'd31;
              end
            2'b11:
              begin
                Bullet_X_Pos_in = ShooterX;
                Bullet_Y_Pos_in = ShooterY + 10'd16;
              end
            default:
              begin
                Bullet_X_Pos_in = ShooterX + 10'd16;
                Bullet_Y_Pos_in = ShooterY;
              end
          endcase
      end

      // if bullet is off map, destroy it
      if((Bullet_X_Pos >= Bullet_X_Max) || (Bullet_X_Pos >= Bullet_X_Max) || (Bullet_X_Pos <= Bullet_X_Max) || (Bullet_X_Pos >= Bullet_X_Max)) // if bullet reaches edge of map, it is done
        Bullet_Live_Comb_in = 0;

      // if bullet hits barrier, destroy it, else move bullet
      if(Bullet_X_Motion == Bullet_X_Step)
      begin
        if((barrier[Bullet_Y_Pos>>5][(Bullet_X_Pos+Bullet_X_Motion)>>5] == 0) && (barrier[(Bullet_Y_Pos+10'd32)>>5][(Bullet_X_Pos+Bullet_X_Motion)>>5] == 0))
        begin
          Bullet_X_Pos_in = Bullet_X_Pos + Bullet_X_Motion;
          Bullet_Y_Pos_in = Bullet_Y_Pos + Bullet_Y_Motion;
        end
        else
          Bullet_Live_Comb_in = 0;
      end
      else if (Bullet_X_Motion == (~(Bullet_X_Step) + 1'b1))
      begin
        if((barrier[Bullet_Y_Pos>>5][(Bullet_X_Pos+Bullet_X_Motion)>>5] == 0) && (barrier[(Bullet_Y_Pos+10'd32)>>5][(Bullet_X_Pos+Bullet_X_Motion)>>5] == 0))
        begin
          Bullet_X_Pos_in = Bullet_X_Pos + Bullet_X_Motion;
          Bullet_Y_Pos_in = Bullet_Y_Pos + Bullet_Y_Motion;
        end
        else
          Bullet_Live_Comb_in = 0;
      end
      else if(Bullet_Y_Motion == Bullet_Y_Step)
      begin
        if((barrier[(Bullet_Y_Pos+Bullet_Y_Motion)>>5][Bullet_X_Pos>>5] == 0) && (barrier[(Bullet_Y_Pos+Bullet_Y_Motion)>>5][(Bullet_X_Pos+10'd32)>>5] == 0))
        begin
          Bullet_X_Pos_in = Bullet_X_Pos + Bullet_X_Motion;
          Bullet_Y_Pos_in = Bullet_Y_Pos + Bullet_Y_Motion;
        end
        else
          Bullet_Live_Comb_in = 0;
      end
      else if(Bullet_Y_Motion == (~(Bullet_Y_Step) + 1'b1))
      begin
        if((barrier[(Bullet_Y_Pos+Bullet_Y_Motion)>>5][Bullet_X_Pos>>5] == 0) && (barrier[(Bullet_Y_Pos+Bullet_Y_Motion)>>5][(Bullet_X_Pos+10'd32)>>5] == 0))
        begin
          Bullet_X_Pos_in = Bullet_X_Pos + Bullet_X_Motion;
          Bullet_Y_Pos_in = Bullet_Y_Pos + Bullet_Y_Motion;
        end
        else
          Bullet_Live_Comb_in = 0;
      end
      else
      begin
        Bullet_Live_Comb_in = 0;
        Bullet_X_Pos_in = Bullet_X_Pos + Bullet_X_Motion;
        Bullet_Y_Pos_in = Bullet_Y_Pos + Bullet_Y_Motion;
      end
    end


end

endmodule // bullet
