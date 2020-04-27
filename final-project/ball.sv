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
               input [9:0]   ZombieX, ZombieY,
               input         hit,
               input [1:0]   ShooterFace,
               input         is_shot,
               input logic [0:14][0:19][0:1] barrier,
               output logic  is_ball             // Whether current pixel belongs to ball or background
              );

    parameter [9:0] Ball_X_Center = 10'd320;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center = 10'd240;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min = 10'd32;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max = 10'd607;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min = 10'd64;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max = 10'd447;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step = 10'd1;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step = 10'd1;      // Step size on the Y axis
    parameter [9:0] Ball_Size = 10'd4;        // Ball size
    parameter [9:0] Half = 10'd15;
    parameter [9:0] Full = 10'd31;


    logic [9:0] T_UX;
    logic [9:0] T_UY;
    logic [9:0] T_RX;
    logic [9:0] T_RY;
    logic [9:0] T_DX;
    logic [9:0] T_DY;
    logic [9:0] T_LX;
    logic [9:0] T_LY;
    logic [9:0] T_X;
    logic [9:0] T_Y;
    logic bullet_active_comb, bullet_active_in;
    logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion;
    logic [9:0] Ball_X_Pos_in, Ball_X_Motion_in, Ball_Y_Pos_in, Ball_Y_Motion_in;
    logic [9:0] Zombie_X_Max, Zombie_Y_Max;

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
            Ball_X_Pos <= Ball_X_Center;
            Ball_Y_Pos <= Ball_Y_Center;
            Ball_X_Motion <= 10'd0;
            Ball_Y_Motion <= 10'd0;
            bullet_active_comb <= 1'b0;
        end
        else
        begin
            Ball_X_Pos <= Ball_X_Pos_in;
            Ball_Y_Pos <= Ball_Y_Pos_in;
            Ball_X_Motion <= Ball_X_Motion_in;
            Ball_Y_Motion <= Ball_Y_Motion_in;
            bullet_active_comb <= bullet_active_in;
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
        bullet_active_in = bullet_active_comb;

        // UP
        // Halfway right X, Maintain up Y
        T_UX = ShooterX + Half;
        T_UY = ShooterY;

        // RIGHT
        // All the way X, Halfway down Y
        T_RX = ShooterX + Full;
        T_RY = ShooterY + Half;

        // DOWN
        // Halfway right X, All the way down Y
        T_DX = ShooterX + Half;
        T_DY = ShooterY + Full;

        // LEFT
        // Maintain left X, Halfway down Y
        T_LX = ShooterX;
        T_LY = ShooterY + Half;

        // By Default
        T_X = T_UX;
        T_Y = T_UY;

        Zombie_X_Max = ZombieX + Full;
        Zombie_Y_Max = ZombieY + Half;
        // Update position and motion only at rising edge of frame clock
        if (frame_clk_rising_edge)
        begin

            // "A": 0x04 (Left), "W": 0x1A (Up), "D": 0x07 (Right), "S" :0x16 (Down)
            // Ball_X_Motion_in = Ball_X_Motion;
            // Ball_Y_Motion_in = Ball_Y_Motion;
            if(is_shot)
            begin
              case(ShooterFace)
                2'b00 : // W : Up
                begin
                  Ball_Y_Motion_in = (~(Ball_Y_Step) + 1'b1);
                  Ball_X_Motion_in = 10'd0;
                  T_X = T_UX;
                  T_Y = T_UY;
                end
                2'b10 : // S : Down
                begin
                  Ball_Y_Motion_in = Ball_Y_Step;
                  Ball_X_Motion_in = 10'd0;
                  T_X = T_DX;
                  T_Y = T_DY;
                end
                2'b11 : // A : Left
                begin
                  Ball_X_Motion_in = (~(Ball_X_Step) + 1'b1);
                  Ball_Y_Motion_in = 10'd0;
                  T_X = T_LX;
                  T_Y = T_LY;
                end
                2'b01 : // D : Right
                begin
                  Ball_X_Motion_in = Ball_X_Step;
                  Ball_Y_Motion_in = 10'd0;
                  T_X = T_RX;
                  T_Y = T_RY;
                end
                default:
                begin
                  Ball_X_Motion_in = Ball_X_Motion;
                  Ball_Y_Motion_in = Ball_Y_Motion;
                end
             endcase
             // Update the ball's position with its motion
             Ball_X_Pos_in = T_X + Ball_X_Motion;
             Ball_Y_Pos_in = T_Y + Ball_Y_Motion;
             bullet_active_in = 1'b1;
            end

            // Bullet_active but it's not being shot via spacebar 8'h2c:
            if(bullet_active_comb && !is_shot)
            begin
              // Be careful when using comparators with "logic" datatype because compiler treats
              //   both sides of the operator as UNSIGNED numbers.
              // e.g. Ball_Y_Pos - Ball_Size <= Ball_Y_Min
              // If Ball_Y_Pos is 0, then Ball_Y_Pos - Ball_Size will not be -4, but rather a large positive number.
              if( Ball_Y_Pos + Ball_Size >= Ball_Y_Max )  // Ball is at the bottom edge, BOUNCE!
                  Ball_Y_Motion_in = (~(Ball_Y_Step) + 1'b1);  // 2's complement.
              else if ( Ball_Y_Pos <= Ball_Y_Min + Ball_Size )  // Ball is at the top edge, BOUNCE!
                  Ball_Y_Motion_in = Ball_Y_Step;
              // TODO: Add other boundary detections and handle keypress here.
              if( Ball_X_Pos + Ball_Size >= Ball_X_Max )  // Ball is at the right edge, BOUNCE!
                  Ball_X_Motion_in = (~(Ball_X_Step) + 1'b1);  // 2's complement.
              else if ( Ball_X_Pos <= Ball_X_Min + Ball_Size )  // Ball is at the left edge, BOUNCE!
                  Ball_X_Motion_in = Ball_X_Step;

               // Update the ball's position with its motion
               Ball_X_Pos_in = Ball_X_Pos + Ball_X_Motion;
               Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion;
            end


            // Not Fired
            if(!bullet_active_comb && !is_shot)
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
               // Update the ball's position with its motion
               Ball_X_Pos_in = T_X;
               Ball_Y_Pos_in = T_Y;
              end

            // Zombie? ... OH NO!!!
            if(hit && is_ball && bullet_active_comb)
            begin
              bullet_active_in = 1'b0;
              Ball_X_Motion_in = 10'd0;
              Ball_Y_Motion_in = 10'd0;
            end

            // If Ball in Zombie square, stop motion and position back to gun tip.
            if((Ball_X_Pos >= ZombieX) && (Ball_X_Pos <= Zombie_X_Max) && (Ball_Y_Pos >= ZombieY) && (Ball_Y_Pos <= Zombie_Y_Max))
            begin
              bullet_active_in = 1'b0;
              Ball_X_Motion_in = 10'd0;
              Ball_Y_Motion_in = 10'd0;
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
                default:;
             endcase
             Ball_X_Pos_in = T_X + Ball_X_Motion;
             Ball_Y_Pos_in = T_Y + Ball_Y_Motion;
            end

            // If Barrier, stop motion and position back to gun tip.
            if((barrier[Ball_Y_Pos>>5][Ball_X_Pos>>5]))
            begin
              bullet_active_in = 1'b0;
              Ball_X_Motion_in = 10'd0;
              Ball_Y_Motion_in = 10'd0;
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
                default:;
             endcase
             Ball_X_Pos_in = T_X + Ball_X_Motion;
             Ball_Y_Pos_in = T_Y + Ball_Y_Motion;
            end
      end // End of frame_clk_rising_edge control structure

        /**************************************************************************************
            ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
            Hidden Question #2/2:
               Notice that Ball_Y_Pos is updated using Ball_Y_Motion.
              Will the new value of Ball_Y_Motion be used when Ball_Y_Pos is updated, or the old?
              What is the difference between writing
                "Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion;" and
                "Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion_in;"?
              How will this impact behavior of the ball during a bounce, and how might that interact with a response to a keypress?
              Give an answer in your Post-Lab.
        **************************************************************************************/

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
