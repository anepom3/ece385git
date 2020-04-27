// Zombie module
module Zombie (input logic Clk, Reset, frame_clk,
                input logic [2:0] ZombieMove,
                input logic [0:14][0:19][0:1] barrier,
                output logic [9:0] ZombieX, ZombieY,
                output logic [1:0] ZombieFace
  );

  parameter [9:0] Zombie_X_Center = 10'd353;  // Center position on the X axis (640/2 = 320-16 = 304-1 = 303)
  parameter [9:0] Zombie_Y_Center = 10'd248;  // Center position on the Y axis (480/2 = 240-25 = 215-16 = 199-1 = 198)
  parameter [9:0] Zombie_X_Min = 10'd32;       // Leftmost point on the X axis (20 + 12)
  parameter [9:0] Zombie_X_Max = 10'd575;     // Rightmost point on the X axis (639 - 20 - 12 - 32)
  parameter [9:0] Zombie_Y_Min = 10'd64;       // Topmost point on the Y axis (50 + 12)
  parameter [9:0] Zombie_Y_Max = 10'd415;     // Bottommost point on the Y axis (479 - 20 - 12 - 32)
  parameter [9:0] Zombie_X_Step = 10'd1;      // Step size on the X axis
  parameter [9:0] Zombie_Y_Step = 10'd1;      // Step size on the Y axis

  logic [9:0] Zombie_X_Pos, Zombie_X_Motion, Zombie_Y_Pos, Zombie_Y_Motion;
  logic [9:0] Zombie_X_Pos_in, Zombie_X_Motion_in, Zombie_Y_Pos_in, Zombie_Y_Motion_in;
  logic [1:0] ZombieFace_in;

  assign ZombieX = Zombie_X_Pos;
  assign ZombieY = Zombie_Y_Pos;

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
          Zombie_X_Pos <= Zombie_X_Center;
          Zombie_Y_Pos <= Zombie_Y_Center;
          Zombie_X_Motion <= 10'd0;
          Zombie_Y_Motion <= 10'd0;
          ZombieFace <= 2'b00;
      end
      else
      begin
          Zombie_X_Pos <= Zombie_X_Pos_in;
          Zombie_Y_Pos <= Zombie_Y_Pos_in;
          Zombie_X_Motion <= Zombie_X_Motion_in;
          Zombie_Y_Motion <= Zombie_Y_Motion_in;
          ZombieFace <= ZombieFace_in;
      end
  end
  //////// Do not modify the always_ff blocks. ////////


  always_comb
  begin
      // By default, keep motion and position unchanged
      Zombie_X_Pos_in = Zombie_X_Pos;
      Zombie_Y_Pos_in = Zombie_Y_Pos;
      Zombie_X_Motion_in = Zombie_X_Motion;
      Zombie_Y_Motion_in = Zombie_Y_Motion;
      ZombieFace_in = ZombieFace;

      // Update position and motion only at rising edge of frame clock
      if (frame_clk_rising_edge)
      begin

          // ZombieMove
          // 0 - no movement
          // 1 - up; 2 - right
          // 3 - down; 4 - left
          case (ZombieMove)
            3'b000: // no movement
            begin
              Zombie_Y_Motion_in = 10'd0;
              Zombie_X_Motion_in = 10'd0;
            end
            3'b001: // up
            begin
              Zombie_Y_Motion_in = (~(Zombie_Y_Step) + 1'b1);
              Zombie_X_Motion_in = 10'd0;
              ZombieFace_in = 2'b00;
            end
            3'b010: // right
            begin
              Zombie_Y_Motion_in = 10'd0;
              Zombie_X_Motion_in = Zombie_X_Step;
              ZombieFace_in = 2'b01;
            end
            3'b011: // down
            begin
              Zombie_Y_Motion_in = Zombie_Y_Step;
              Zombie_X_Motion_in = 10'd0;
              ZombieFace_in = 2'b10;
            end
            3'b100: // left
            begin
              Zombie_Y_Motion_in = 10'd0;
              Zombie_X_Motion_in = (~(Zombie_X_Step) + 1'b1);
              ZombieFace_in = 2'b11;
            end
            default:
            begin
              Zombie_Y_Motion_in = 10'd0;
              Zombie_X_Motion_in = 10'd0;
            end
          endcase


         if( Zombie_Y_Pos >= Zombie_Y_Max )  // Zombie is at the bottom edge, STOP!
             Zombie_Y_Motion_in = (~(Zombie_Y_Step) + 1'b1);  // stay still at the edge
         else if ( Zombie_Y_Pos <= Zombie_Y_Min )  // Zombie is at the top edge, STOP!
             Zombie_Y_Motion_in = Zombie_Y_Step;
         // TODO: Add other boundary detections and handle keypress here.
         if( Zombie_X_Pos >= Zombie_X_Max )  // Zombie is at the bottom edge, STOP!
             Zombie_X_Motion_in = (~(Zombie_X_Step) + 1'b1);  // stay still at the edge
         else
         if ( Zombie_X_Pos <= Zombie_X_Min )  // Zombie is at the top edge, STOP!
         begin
           Zombie_X_Motion_in = Zombie_X_Step;
         end

          // Update the Zombie's position with its motion
          // Zombie_X_Pos_in = Zombie_X_Pos + Zombie_X_Motion;
          // Zombie_Y_Pos_in = Zombie_Y_Pos + Zombie_Y_Motion;

          // update position only if location attempting to be moved to is not a barrier
          if(Zombie_X_Motion == Zombie_X_Step)
          begin
            if((barrier[Zombie_Y_Pos>>5][(Zombie_X_Pos+Zombie_X_Motion+32)>>5] == 0) && (barrier[(Zombie_Y_Pos+32)>>5][(Zombie_X_Pos+Zombie_X_Motion+32)>>5] == 0))
            begin
              Zombie_X_Pos_in = Zombie_X_Pos + Zombie_X_Motion;
              Zombie_Y_Pos_in = Zombie_Y_Pos + Zombie_Y_Motion;
            end
          end
          else if (Zombie_X_Motion == (~(Zombie_X_Step) + 1'b1))
          begin
            if((barrier[Zombie_Y_Pos>>5][(Zombie_X_Pos+Zombie_X_Motion)>>5] == 0) && (barrier[(Zombie_Y_Pos+32)>>5][(Zombie_X_Pos+Zombie_X_Motion)>>5] == 0))
            begin
              Zombie_X_Pos_in = Zombie_X_Pos + Zombie_X_Motion;
              Zombie_Y_Pos_in = Zombie_Y_Pos + Zombie_Y_Motion;
            end
          end
          else if(Zombie_Y_Motion == Zombie_Y_Step)
          begin
            if((barrier[(Zombie_Y_Pos+Zombie_Y_Motion+32)>>5][Zombie_X_Pos>>5] == 0) && (barrier[(Zombie_Y_Pos+Zombie_Y_Motion+32)>>5][(Zombie_X_Pos+32)>>5] == 0))
            begin
              Zombie_X_Pos_in = Zombie_X_Pos + Zombie_X_Motion;
              Zombie_Y_Pos_in = Zombie_Y_Pos + Zombie_Y_Motion;
            end
          end
          else if(Zombie_Y_Motion == (~(Zombie_Y_Step) + 1'b1))
          begin
            if((barrier[(Zombie_Y_Pos+Zombie_Y_Motion)>>5][Zombie_X_Pos>>5] == 0) && (barrier[(Zombie_Y_Pos+Zombie_Y_Motion)>>5][(Zombie_X_Pos+32)>>5] == 0))
            begin
              Zombie_X_Pos_in = Zombie_X_Pos + Zombie_X_Motion;
              Zombie_Y_Pos_in = Zombie_Y_Pos + Zombie_Y_Motion;
            end
          end
          else
          begin
            Zombie_X_Pos_in = Zombie_X_Pos + Zombie_X_Motion;
            Zombie_Y_Pos_in = Zombie_Y_Pos + Zombie_Y_Motion;
          end
      end
  end


endmodule // Zombie
