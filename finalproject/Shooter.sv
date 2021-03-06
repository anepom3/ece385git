// Shooter module
module Shooter (input logic Clk, Reset, frame_clk,
                input logic [2:0] ShooterMove,
                output logic [9:0] ShooterX, ShooterY,
                output logic [1:0] ShooterFace
  );

  parameter [9:0] Shooter_X_Center = 10'd303;  // Center position on the X axis (640/2 = 320-16 = 304-1 = 303)
  parameter [9:0] Shooter_Y_Center = 10'd198;  // Center position on the Y axis (480/2 = 240-25 = 215-16 = 199-1 = 198)
  parameter [9:0] Shooter_X_Min = 10'd32;       // Leftmost point on the X axis (20 + 12)
  parameter [9:0] Shooter_X_Max = 10'd585;     // Rightmost point on the X axis (649 - 20 - 12 - 32)
  parameter [9:0] Shooter_Y_Min = 10'd62;       // Topmost point on the Y axis (50 + 12)
  parameter [9:0] Shooter_Y_Max = 10'd415;     // Bottommost point on the Y axis (479 - 20 - 12 - 32)
  parameter [9:0] Shooter_X_Step = 10'd1;      // Step size on the X axis
  parameter [9:0] Shooter_Y_Step = 10'd1;      // Step size on the Y axis

  logic [9:0] Shooter_X_Pos, Shooter_X_Motion, Shooter_Y_Pos, Shooter_Y_Motion;
  logic [9:0] Shooter_X_Pos_in, Shooter_X_Motion_in, Shooter_Y_Pos_in, Shooter_Y_Motion_in;
  logic [1:0] ShooterFace_in;

  assign ShooterX = Shooter_X_Pos;
  assign ShooterY = Shooter_Y_Pos;

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
          Shooter_X_Pos <= Shooter_X_Center;
          Shooter_Y_Pos <= Shooter_Y_Center;
          Shooter_X_Motion <= 10'd0;
          Shooter_Y_Motion <= 10'd0;
          ShooterFace <= 2'b00;
      end
      else
      begin
          Shooter_X_Pos <= Shooter_X_Pos_in;
          Shooter_Y_Pos <= Shooter_Y_Pos_in;
          Shooter_X_Motion <= Shooter_X_Motion_in;
          Shooter_Y_Motion <= Shooter_Y_Motion_in;
          ShooterFace <= ShooterFace_in;
      end
  end
  //////// Do not modify the always_ff blocks. ////////


  always_comb
  begin
      // By default, keep motion and position unchanged
      Shooter_X_Pos_in = Shooter_X_Pos;
      Shooter_Y_Pos_in = Shooter_Y_Pos;
      Shooter_X_Motion_in = Shooter_X_Motion;
      Shooter_Y_Motion_in = Shooter_Y_Motion;
      ShooterFace_in = ShooterFace;

      // Update position and motion only at rising edge of frame clock
      if (frame_clk_rising_edge)
      begin

          // ShooterMove
          // 0 - no movement
          // 1 - up; 2 - right
          // 3 - down; 4 - left
          case (ShooterMove)
            3'b000: // no movement
            begin
              Shooter_Y_Motion_in = 10'd0;
              Shooter_X_Motion_in = 10'd0;
            end
            3'b001: // up
            begin
              Shooter_Y_Motion_in = (~(Shooter_Y_Step) + 1'b1);
              Shooter_X_Motion_in = 10'd0;
              ShooterFace_in = 2'b00;
            end
            3'b010: // right
            begin
              Shooter_Y_Motion_in = 10'd0;
              Shooter_X_Motion_in = Shooter_X_Step;
              ShooterFace_in = 2'b01;
            end
            3'b011: // down
            begin
              Shooter_Y_Motion_in = Shooter_Y_Step;
              Shooter_X_Motion_in = 10'd0;
              ShooterFace_in = 2'b10;
            end
            3'b100: // right
            begin
              Shooter_Y_Motion_in = 10'd0;
              Shooter_X_Motion_in = (~(Shooter_X_Step) + 1'b1);
              ShooterFace_in = 2'b11;
            end
            default:
            begin
              Shooter_Y_Motion_in = 10'd0;
              Shooter_X_Motion_in = 10'd0;
            end
          endcase


         if( Shooter_Y_Pos >= Shooter_Y_Max )  // Shooter is at the bottom edge, STOP!
             Shooter_Y_Motion_in = 10'd0;  // stay still at the edge
         else if ( Shooter_Y_Pos <= Shooter_Y_Min )  // Shooter is at the top edge, STOP!
             Shooter_Y_Motion_in = 10'd0;
         // TODO: Add other boundary detections and handle keypress here.
         if( Shooter_X_Pos + >= Shooter_X_Max )  // Shooter is at the bottom edge, STOP!
             Shooter_X_Motion_in = 10'd0;  // stay still at the edge
         else if ( Shooter_X_Pos <= Shooter_X_Min )  // Shooter is at the top edge, STOP!
             Shooter_X_Motion_in = 10'd0;

          // Update the Shooter's position with its motion
          Shooter_X_Pos_in = Shooter_X_Pos + Shooter_X_Motion;
          Shooter_Y_Pos_in = Shooter_Y_Pos + Shooter_Y_Motion;
      end
  end


endmodule // Shooter
