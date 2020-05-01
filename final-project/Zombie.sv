// Zombie module
module Zombie ( input logic Clk, Reset, frame_clk,
                input logic [0:14][0:19][0:1] barrier,
                input logic [9:0] ShooterX, ShooterY,
                input logic [9:0] Zombie_Spawn_X, Zombie_Spawn_Y,
                input logic [9:0] delay_spawn, Zombie_Speed,
                input logic is_dead, // from collisions.sv file

                output logic [9:0] ZombieX, ZombieY,
                output logic [1:0] ZombieFace,
                output logic is_alive
  );

  // Zombie settings.
  parameter [9:0] Zombie_X_Init = 10'd0;          // Zombie starts at (0,0)
  parameter [9:0] Zombie_Y_Init = 10'd0;          // Zombie starts at (0,0)
  parameter [9:0] Zombie_X_Min = 10'd32;          // Leftmost point on the X axis (20 + 12)
  parameter [9:0] Zombie_X_Max = 10'd575;         // Rightmost point on the X axis (639 - 20 - 12 - 32)
  parameter [9:0] Zombie_Y_Min = 10'd64;          // Topmost point on the Y axis (50 + 12)
  parameter [9:0] Zombie_Y_Max = 10'd415;         // Bottommost point on the Y axis (479 - 20 - 12 - 32)
  logic [9:0] Zombie_X_Step;   // Step size on the X axis
  logic [9:0] Zombie_Y_Step;   // Step size on the Y axis

  // Zombie position, motion, face, alive status, and distance registers.
  logic [9:0] Zombie_X_Pos, Zombie_X_Motion, Zombie_Y_Pos, Zombie_Y_Motion;
  logic [9:0] Zombie_X_Pos_in, Zombie_X_Motion_in, Zombie_Y_Pos_in, Zombie_Y_Motion_in;
  logic [9:0] Zombie_to_Shooter_X, Zombie_to_Shooter_Y;
  logic [1:0] ZombieFace_in;
  logic is_alive_comb, is_alive_comb_in;
  // logic is_dead_comb;
  logic [9:0] Spawn_Countdown, Spawn_Countdown_in;


  assign ZombieX = Zombie_X_Pos;
  assign ZombieY = Zombie_Y_Pos;
  assign is_alive = is_alive_comb;

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
          Zombie_X_Pos <= Zombie_X_Init;
          Zombie_Y_Pos <= Zombie_Y_Init;
          Zombie_X_Motion <= 10'd0;
          Zombie_Y_Motion <= 10'd0;
          ZombieFace <= 2'b00;
          is_alive_comb <= 1'b0; // Eventually should be 0
          Spawn_Countdown <= delay_spawn;
      end
      else
      begin // Update registers.
          Zombie_X_Pos <= Zombie_X_Pos_in;
          Zombie_Y_Pos <= Zombie_Y_Pos_in;
          Zombie_X_Motion <= Zombie_X_Motion_in;
          Zombie_Y_Motion <= Zombie_Y_Motion_in;
          ZombieFace <= ZombieFace_in;
          is_alive_comb <= is_alive_comb_in;
          Spawn_Countdown <= Spawn_Countdown_in;
      end
  end
  //////// Do not modify the always_ff blocks. ////////


  always_comb
  begin // begin of always comb loop

    // Settings initialization
    Zombie_X_Step = Zombie_Speed;
    Zombie_Y_Step = Zombie_Speed;
    Zombie_to_Shooter_X = 10'd0;
    Zombie_to_Shooter_Y = 10'd0;

    // By default, keep motion, position, face direction, and alive status unchanged
    Zombie_X_Pos_in = Zombie_X_Pos;
    Zombie_Y_Pos_in = Zombie_Y_Pos;
    Zombie_X_Motion_in = Zombie_X_Motion;
    Zombie_Y_Motion_in = Zombie_Y_Motion;
    ZombieFace_in = ZombieFace;
    is_alive_comb_in = is_alive_comb;
    Spawn_Countdown_in = Spawn_Countdown; // Causes it to stay at 0

    // Update position and motion only at rising edge of frame clock
    if (frame_clk_rising_edge) // ~60Hz block of execution
    begin // begin of rising edge of frame_clk
      if((Spawn_Countdown > 10'd0) && !is_alive_comb)
      begin
        Spawn_Countdown_in = Spawn_Countdown - 10'd1;
        if(Spawn_Countdown == 10'd1)
          begin
            Zombie_X_Pos_in = Zombie_Spawn_X;
            Zombie_Y_Pos_in = Zombie_Spawn_Y;
            is_alive_comb_in = 1'b1;
          end
      end
      if(is_dead) // if zombie has died, move to off screen and stop printing it
      begin
        Zombie_X_Pos_in = 10'd0;
        Zombie_Y_Pos_in = 10'd0;
        is_alive_comb_in = 1'b0;
        Zombie_X_Motion_in = 10'd0;
        Zombie_Y_Motion_in = 10'd0;
      end
      else // zombie is still alive, move him around the screen
      begin // begin of zombie not dead
        if(is_alive_comb)
        begin // begin of alive updating
          // update motion of zombie
          if(Zombie_X_Pos_in > ShooterX) // zombie is right of shooter
          begin // begin of Zombie motion calculations
              Zombie_to_Shooter_X = Zombie_X_Pos_in - ShooterX;
              if(Zombie_Y_Pos_in > ShooterY) // zombie is below shooter
              begin
                  Zombie_to_Shooter_Y = Zombie_Y_Pos_in - ShooterY;
                  if(Zombie_to_Shooter_X > Zombie_to_Shooter_Y) // X is bigger --> move left
                  begin
                      Zombie_Y_Motion_in = 10'd0;
                      Zombie_X_Motion_in = (~(Zombie_X_Step) + 1'b1);
                      ZombieFace_in = 2'b11;
                  end
                  else // Y is bigger --> move up
                  begin
                      Zombie_Y_Motion_in = (~(Zombie_Y_Step) + 1'b1);
                      Zombie_X_Motion_in = 10'd0;
                      ZombieFace_in = 2'b00;
                  end
              end
              else // zombie is above of shooter
              begin
                  Zombie_to_Shooter_Y = ShooterY - Zombie_to_Shooter_Y;
                  if(Zombie_to_Shooter_X > Zombie_to_Shooter_Y) // X is bigger --> move left
                  begin
                      Zombie_Y_Motion_in = 10'd0;
                      Zombie_X_Motion_in = (~(Zombie_X_Step) + 1'b1);
                      ZombieFace_in = 2'b11;
                  end
                  else // Y is bigger --> move down
                  begin
                      Zombie_Y_Motion_in = Zombie_Y_Step;
                      Zombie_X_Motion_in = 10'd0;
                      ZombieFace_in = 2'b10;
                  end
              end
          end
          else // zombie is left of shooter
          begin
              Zombie_to_Shooter_X = ShooterX - Zombie_X_Pos_in;
              if(Zombie_Y_Pos_in > ShooterY) // zombie is below shooter
              begin
                  Zombie_to_Shooter_Y = Zombie_Y_Pos_in - ShooterY;
                  if(Zombie_to_Shooter_X > Zombie_to_Shooter_Y) // X is bigger --> move right
                  begin
                      Zombie_Y_Motion_in = 10'd0;
                      Zombie_X_Motion_in = Zombie_X_Step;
                      ZombieFace_in = 2'b01;
                  end
                  else // Y is bigger --> move up
                  begin
                      Zombie_Y_Motion_in = (~(Zombie_Y_Step) + 1'b1);
                      Zombie_X_Motion_in = 10'd0;
                      ZombieFace_in = 2'b00;
                  end
              end
              else // zombie is above of shooter
              begin
                  Zombie_to_Shooter_Y = ShooterY - Zombie_to_Shooter_Y;
                  if(Zombie_to_Shooter_X > Zombie_to_Shooter_Y) // X is bigger --> move right
                  begin
                      Zombie_Y_Motion_in = 10'd0;
                      Zombie_X_Motion_in = Zombie_X_Step;
                      ZombieFace_in = 2'b01;
                  end
                  else // Y is bigger --> move down
                  begin
                      Zombie_Y_Motion_in = Zombie_Y_Step;
                      Zombie_X_Motion_in = 10'd0;
                      ZombieFace_in = 2'b10;
                  end
              end
          end // end of Zombie motion calculations
          // Wall cases of motion: Hit wall, reverse direction.
          if( Zombie_Y_Pos >= Zombie_Y_Max )  // Zombie is at the bottom edge, STOP!
              Zombie_Y_Motion_in = (~(Zombie_Y_Step) + 1'b1);  // stay still at the edge
          else if ( Zombie_Y_Pos <= Zombie_Y_Min )  // Zombie is at the top edge, STOP!
              Zombie_Y_Motion_in = Zombie_Y_Step;
          if( Zombie_X_Pos >= Zombie_X_Max )  // Zombie is at the bottom edge, STOP!
              Zombie_X_Motion_in = (~(Zombie_X_Step) + 1'b1);  // stay still at the edge
          else if ( Zombie_X_Pos <= Zombie_X_Min )  // Zombie is at the top edge, STOP!
            Zombie_X_Motion_in = Zombie_X_Step;

          // Update position only if location attempting to be moved to is not a barrier
          // Barrier cases:
          if(Zombie_X_Motion == Zombie_X_Step) // Moving Right.
            begin
              if((barrier[Zombie_Y_Pos>>5][(Zombie_X_Pos+Zombie_X_Motion+32)>>5] == 0) && (barrier[(Zombie_Y_Pos+32)>>5][(Zombie_X_Pos+Zombie_X_Motion+32)>>5] == 0))
              begin
                Zombie_X_Pos_in = Zombie_X_Pos + Zombie_X_Motion;
                Zombie_Y_Pos_in = Zombie_Y_Pos + Zombie_Y_Motion;
              end
            end
            else if (Zombie_X_Motion == (~(Zombie_X_Step) + 1'b1)) // Moving Left.
            begin
              if((barrier[Zombie_Y_Pos>>5][(Zombie_X_Pos+Zombie_X_Motion)>>5] == 0) && (barrier[(Zombie_Y_Pos+32)>>5][(Zombie_X_Pos+Zombie_X_Motion)>>5] == 0))
              begin
                Zombie_X_Pos_in = Zombie_X_Pos + Zombie_X_Motion;
                Zombie_Y_Pos_in = Zombie_Y_Pos + Zombie_Y_Motion;
              end
            end
            else if(Zombie_Y_Motion == Zombie_Y_Step) // Moving Down.
            begin
              if((barrier[(Zombie_Y_Pos+Zombie_Y_Motion+32)>>5][Zombie_X_Pos>>5] == 0) && (barrier[(Zombie_Y_Pos+Zombie_Y_Motion+32)>>5][(Zombie_X_Pos+32)>>5] == 0))
              begin
                Zombie_X_Pos_in = Zombie_X_Pos + Zombie_X_Motion;
                Zombie_Y_Pos_in = Zombie_Y_Pos + Zombie_Y_Motion;
              end
            end
            else if(Zombie_Y_Motion == (~(Zombie_Y_Step) + 1'b1)) // Moving Up.
            begin
              if((barrier[(Zombie_Y_Pos+Zombie_Y_Motion)>>5][Zombie_X_Pos>>5] == 0) && (barrier[(Zombie_Y_Pos+Zombie_Y_Motion)>>5][(Zombie_X_Pos+32)>>5] == 0))
              begin
                Zombie_X_Pos_in = Zombie_X_Pos + Zombie_X_Motion;
                Zombie_Y_Pos_in = Zombie_Y_Pos + Zombie_Y_Motion;
              end
            end
            else // Otherwise, have the Zombie continue to move in that direction.
            begin
              Zombie_X_Pos_in = Zombie_X_Pos + Zombie_X_Motion;
              Zombie_Y_Pos_in = Zombie_Y_Pos + Zombie_Y_Motion;
            end
        end // end of alive updating
      end // end of zombie not dead
    end // end of rising frame
  end // end of always comb loop

endmodule // Zombie
