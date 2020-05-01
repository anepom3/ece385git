//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  12-08-2017                               --
//    Spring 2018 Distribution                                           --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  ball ( input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
               input [9:0]   ShooterX, ShooterY,
               input [1:0]   ShooterFace,
               input logic [0:14][0:19][0:1] barrier,
               input         is_shot,
               input         remove_bullet,


               output logic [9:0] BallX, BallY,  // Output Ball Location Coordinates
               output logic  is_ball,             // Whether current pixel belongs to ball or background
               output logic  bullet_status
              );

    parameter [9:0] Ball_X_Center = 10'd320;  // Center position on the X axis (Center of Shooter width)
    parameter [9:0] Ball_Y_Center = 10'd240;  // Center position on the Y axis (Center of Shooter Height)
    parameter [9:0] Ball_X_Min = 10'd32;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max = 10'd607;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min = 10'd64;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max = 10'd447;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step = 10'd10;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step = 10'd10;      // Step size on the Y axis
    parameter [9:0] Ball_Size = 10'd4;        // Ball size
    parameter [9:0] Half = 10'd15;            // Half-length of a 32x32 sprite
    parameter [9:0] Full = 10'd31;            // Full-length of a 32x32 sprite


    logic [9:0] T_UX; // Gun Tip Up - X Coordinate
    logic [9:0] T_UY; // Gun Tip Up - Y Coordinate
    logic [9:0] T_RX; // Gun Tip Right - X Coordinate
    logic [9:0] T_RY; // Gun Tip Right - Y Coordinate
    logic [9:0] T_DX; // Gun Tip Down - X Coordinate
    logic [9:0] T_DY; // Gun Tip Down - Y Coordinate
    logic [9:0] T_LX; // Gun Tip Left - X Coordinate
    logic [9:0] T_LY; // Gun Tip Left - Y Coordinate
    logic [9:0] T_X; // Gun Tip - X Coordinate
    logic [9:0] T_Y; // Gun Tip - X Coordinate

    logic bullet_active, bullet_active_in; // Status of bulllet

    // Ball X,Y Pos and Motion
    logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion;
    logic [9:0] Ball_X_Pos_in, Ball_X_Motion_in, Ball_Y_Pos_in, Ball_Y_Motion_in;

    // Assign Ball X,Y Pos for Output
    assign BallX = Ball_X_Pos;
    assign BallY = Ball_Y_Pos;
    assign bullet_status = bullet_active;
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
        // If Reset (KEY[0]) is pressed
        if (Reset)
        begin
            Ball_X_Pos <= Ball_X_Center;
            Ball_Y_Pos <= Ball_Y_Center;
            Ball_X_Motion <= 10'd0;
            Ball_Y_Motion <= 10'd0;
            bullet_active <= 1'b0;
        end
        else
        begin
            Ball_X_Pos <= Ball_X_Pos_in;
            Ball_Y_Pos <= Ball_Y_Pos_in;
            Ball_X_Motion <= Ball_X_Motion_in;
            Ball_Y_Motion <= Ball_Y_Motion_in;
            bullet_active <= bullet_active_in;
        end
    end
    //////// Do not modify the always_ff blocks. ////////

    // You need to modify always_comb block.
    always_comb
    begin
        // By default, keep motion and position unchanged
        Ball_X_Pos_in = Ball_X_Pos;
        Ball_Y_Pos_in = Ball_Y_Pos;
        Ball_X_Motion_in = Ball_X_Motion;
        Ball_Y_Motion_in = Ball_Y_Motion;
        bullet_active_in = bullet_active;

        // Shooter Tip Coordinates
        // Face UP
        // Halfway right X, Maintain up Y
        T_UX = ShooterX + Half;
        T_UY = ShooterY;

        // Face RIGHT
        // All the way X, Halfway down Y
        T_RX = ShooterX + Full;
        T_RY = ShooterY + Half;

        // Face DOWN
        // Halfway right X, All the way down Y
        T_DX = ShooterX + Half;
        T_DY = ShooterY + Full;

        // Face LEFT
        // Maintain left X, Halfway down Y
        T_LX = ShooterX;
        T_LY = ShooterY + Half;

        // By Default - Face UP shooter tip cooordinates
        T_X = T_UX;
        T_Y = T_UY;

        // Update position and motion only at rising edge of frame clock
        if (frame_clk_rising_edge)
          begin
              // If spacebar is pressed to shoot.
              if(is_shot)
                begin
                  case(ShooterFace) // Shoots in the direction the shooter is facing
                    2'b00 : //  Up
                    begin
                      Ball_Y_Motion_in = (~(Ball_Y_Step) + 1'b1);
                      Ball_X_Motion_in = 10'd0;
                      T_X = T_UX;
                      T_Y = T_UY;
                    end
                    2'b10 : // Down
                    begin
                      Ball_Y_Motion_in = Ball_Y_Step;
                      Ball_X_Motion_in = 10'd0;
                      T_X = T_DX;
                      T_Y = T_DY;
                    end
                    2'b11 : // Left
                    begin
                      Ball_X_Motion_in = (~(Ball_X_Step) + 1'b1);
                      Ball_Y_Motion_in = 10'd0;
                      T_X = T_LX;
                      T_Y = T_LY;
                    end
                    2'b01 : // Right
                    begin
                      Ball_X_Motion_in = Ball_X_Step;
                      Ball_Y_Motion_in = 10'd0;
                      T_X = T_RX;
                      T_Y = T_RY;
                    end
                    default: // Otherwise keep the motion the same.
                    begin
                      Ball_X_Motion_in = Ball_X_Motion;
                      Ball_Y_Motion_in = Ball_Y_Motion;
                    end
                 endcase
                 // After deciding which direction to shoot,
                 // update the ball's position with its motion
                 Ball_X_Pos_in = T_X + Ball_X_Motion;
                 Ball_Y_Pos_in = T_Y + Ball_Y_Motion;
                 bullet_active_in = 1'b1;
                end

              // Bullet_active but it's not being shot via spacebar 8'h2c:
              if(bullet_active && !is_shot)
                begin
                   // Update the ball's position with its motion
                   Ball_X_Pos_in = Ball_X_Pos + Ball_X_Motion;
                   Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion;
                end


              // Not Fired - the position will be the gun tip.
              if(!bullet_active && !is_shot)
                begin
                  case(ShooterFace)
                    2'b00 : // W : Up
                    begin
                      T_X = T_UX;
                      T_Y = T_UY;
                    end
                    2'b10 : // S : Down
                    begin
                      T_X = T_DX;
                      T_Y = T_DY;
                    end
                    2'b11 : // A : Left
                    begin
                      T_X = T_LX;
                      T_Y = T_LY;
                    end
                    2'b01 : // D : Right
                    begin
                      T_X = T_RX;
                      T_Y = T_RY;
                    end
                    default:
                    begin
                      T_X = T_UX;
                      T_Y = T_UY;
                    end
                 endcase
                 // Return to gun tip.
                 Ball_X_Pos_in = T_X;
                 Ball_Y_Pos_in = T_Y;
                end

              // If Ball in Zombie, barrier, wall square,
              // then stop motion and position back to gun tip.
              if(remove_bullet)
                begin
                  bullet_active_in = 1'b0;
                  Ball_X_Motion_in = 10'd0;
                  Ball_Y_Motion_in = 10'd0;

                  // Decide which way the shooter is facing.
                  case(ShooterFace)
                    2'b00 : //Up
                    begin
                      T_X = T_UX;
                      T_Y = T_UY;
                    end
                    2'b10 : //Down
                    begin
                      T_X = T_DX;
                      T_Y = T_DY;
                    end
                    2'b11 : //Left
                    begin
                      T_X = T_LX;
                      T_Y = T_LY;
                    end
                    2'b01 : //Right
                    begin
                      T_X = T_RX;
                      T_Y = T_RY;
                    end
                    default:;
                 endcase
                 // Return to gun tip.
                 Ball_X_Pos_in = T_X;
                 Ball_Y_Pos_in = T_Y;
                end

           end // End of frame_clk_rising_edge control structure


    end // End of always_comb for calculating new X,Y position

    // Compute whether the pixel corresponds to ball or background
    /* Since the multiplicants are required to be signed, we have to first cast them
       from logic to int (signed by default) before they are multiplied. */
    int DistX, DistY, Size;
    assign DistX = DrawX - Ball_X_Pos;
    assign DistY = DrawY - Ball_Y_Pos;
    assign Size = Ball_Size;

    always_comb begin
        if ( ( DistX*DistX + DistY*DistY) <= (Size*Size) )
            is_ball = 1'b1;
        else
            is_ball = 1'b0;
        /* The ball's (pixelated) circle is generated using the standard circle formula.  Note that while
           the single line is quite powerful descriptively, it causes the synthesis tool to use up three
           of the 12 available multipliers on the chip! */
    end

endmodule
