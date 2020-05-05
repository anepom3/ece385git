//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  10-06-2017                               --
//                                                                       --
//    Fall 2017 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------

// color_mapper: Decide which color to be output to VGA for each pixel.
module  color_mapper ( input Clk, // Clk goes to Sprite Rendering modules for On-Chip RAM to use
                       input  logic [9:0] DrawX, DrawY,       // Current pixel coordinates
                       input  logic [9:0] ShooterX, ShooterY, // Current location of shooter (upper left pixel)
                       input  logic [1:0] ShooterFace,         // Direction Shooter is facing
                       input  logic [9:0] Zombie0X, Zombie1X, Zombie2X, Zombie3X, Zombie4X,
                       input  logic [9:0] Zombie5X, Zombie6X, Zombie7X, Zombie8X, Zombie9X,
                       input  logic [9:0] Zombie0Y, Zombie1Y, Zombie2Y, Zombie3Y, Zombie4Y,
                       input  logic [9:0] Zombie5Y, Zombie6Y, Zombie7Y, Zombie8Y, Zombie9Y,
                       input  logic [1:0] Zombie0Face, Zombie1Face, Zombie2Face, Zombie3Face, Zombie4Face,
                       input  logic [1:0] Zombie5Face, Zombie6Face, Zombie7Face, Zombie8Face, Zombie9Face,
                       input  logic zombie_0_live, zombie_1_live, zombie_2_live, zombie_3_live, zombie_4_live,
                       input  logic zombie_5_live, zombie_6_live, zombie_7_live, zombie_8_live, zombie_9_live,
                       input  logic [0:14][0:19][0:1] barrier,     // barrier
                       input  logic [1:0] event_screen,
                       input  logic [3:0] level,
                       input  logic [3:0] player_health,
                       input  logic is_ball,
                       output logic [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output
                     );

    logic [7:0] Red, Green, Blue;
    logic [7:0] SpriteR, SpriteG, SpriteB;
    logic [7:0] ZombieR, ZombieG, ZombieB;
    logic [7:0] fontR, fontG, fontB;
    logic is_shooter;
    logic is_zombie;
    logic is_font_level,is_font_health, is_font_game_over, is_font_play, is_font_win;

    // Output colors to VGA
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;

    // Assign color based on is_ball signal
    always_comb
    begin
      //default values
      Red = 8'h00;
      Green = 8'h00;
      Blue = 8'h00;

      if(event_screen == 2'd0) //  Title Screen
      begin
        Red = 8'hff;
        Green = DrawY[9:2];
        Blue = DrawX[9:2];
        if(is_font_play)
        begin
          if(~((fontR == 8'h00) && (fontG == 8'h00) && (fontB == 8'h00)))
          begin
            Red = fontR;
            Green = fontG;
            Blue = fontB;
          end
        end
      end

      if(event_screen == 2'd1) // Gameplay screen
      begin // begin of in-game screen printing
        // Background color (orangish similar to ECEB)
        Red = 8'hf3;
        Green = 8'h69;
        Blue = 8'h0e;
        // // Map of room for game
        if((DrawX > 10'd19) && (DrawX < 10'd620) && (DrawY > 10'd51) && (DrawY < 10'd460))
        begin
            // black edge of map (black)
            Red = 8'h00;
            Green = 8'h00;
            Blue = 8'h00;
            if((DrawX > 10'd31) && (DrawX < 10'd608) && (DrawY > 10'd63) && (DrawY < 10'd448))
            begin
                // Floor of map (blue)
                Red = 8'h00;
                Green = 8'h00;
                Blue = 8'hff;
            end
        end
        // check if pixel is part of a sprite image

        if(is_ball)
        begin
          Red = 8'hff;
          Green = 8'h00;
          Blue = 8'h00;
        end
        if(is_shooter)
        begin
          if(~((SpriteR == 8'hff) && (SpriteG == 8'hff) && (SpriteB == 8'hff)))
          begin
            Red = SpriteR;
            Green = SpriteG;
            Blue = SpriteB;
          end
        end
        if(is_zombie)
        begin
          if(~((ZombieR == 8'hff) && (ZombieG == 8'hff) && (ZombieB == 8'hff)))
          begin
            Red = ZombieR;
            Green = ZombieG;
            Blue = ZombieB;
          end
        end
        if(barrier[DrawY>>5][DrawX>>5]) // render grey if barrier
        begin
          Red = 8'h80;
          Green = 8'h80;
          Blue = 8'h80;
        end
        if(is_font_health || is_font_level)
        begin
          if(~((fontR == 8'h00) && (fontG == 8'h00) && (fontB == 8'h00)))
          begin
            Red = fontR;
            Green = fontG;
            Blue = fontB;
          end
        end
      end // end of in-game screen printing

      if(event_screen == 2'd2) // End Game (Win) Screen
      begin
        Red = DrawX[9:2];
        Green = 8'hff;
        Blue = DrawY[9:2];
        if(is_font_win)
        begin
          if(~((fontR == 8'h00) && (fontG == 8'h00) && (fontB == 8'h00)))
          begin
            Red = fontR;
            Green = fontG;
            Blue = fontB;
          end
        end
      end

      if(event_screen == 2'd3) // End Game (Lose) Screen
      begin
        Red = 8'h00;
        Green = 8'h00;
        Blue = 8'h00;
        if(is_font_game_over)
        begin
          if(~((fontR == 8'h00) && (fontG == 8'h00) && (fontB == 8'h00)))
          begin
            Red = fontR;
            Green = fontG;
            Blue = fontB;
          end
        end
      end

    end
    SpriteTable_S SpriteTable_S_inst(.Clk(Clk), .ShooterFace(ShooterFace), .ShooterX(ShooterX), .ShooterY(ShooterY), .DrawX(DrawX), .DrawY(DrawY),
                                     .is_shooter(is_shooter), .SpriteR(SpriteR), .SpriteG(SpriteG), .SpriteB(SpriteB));
   SpriteTable_Z SpriteTable_Z_inst(.Clk(Clk), .DrawX(DrawX), .DrawY(DrawY),
                                    .Zombie0Face(Zombie0Face), .Zombie0X(Zombie0X), .Zombie0Y(Zombie0Y),
                                    .Zombie1Face(Zombie1Face), .Zombie1X(Zombie1X), .Zombie1Y(Zombie1Y),
                                    .Zombie2Face(Zombie2Face), .Zombie2X(Zombie2X), .Zombie2Y(Zombie2Y),
                                    .Zombie3Face(Zombie3Face), .Zombie3X(Zombie3X), .Zombie3Y(Zombie3Y),
                                    .Zombie4Face(Zombie4Face), .Zombie4X(Zombie4X), .Zombie4Y(Zombie4Y),
                                    .Zombie5Face(Zombie5Face), .Zombie5X(Zombie5X), .Zombie5Y(Zombie5Y),
                                    .Zombie6Face(Zombie6Face), .Zombie6X(Zombie6X), .Zombie6Y(Zombie6Y),
                                    .Zombie7Face(Zombie7Face), .Zombie7X(Zombie7X), .Zombie7Y(Zombie7Y),
                                    .Zombie8Face(Zombie8Face), .Zombie8X(Zombie8X), .Zombie8Y(Zombie8Y),
                                    .Zombie9Face(Zombie9Face), .Zombie9X(Zombie9X), .Zombie9Y(Zombie9Y),
                                    .zombie_0_live, .zombie_1_live, .zombie_2_live, .zombie_3_live, .zombie_4_live,
                                    .zombie_5_live, .zombie_6_live, .zombie_7_live, .zombie_8_live, .zombie_9_live,
                                    .is_zombie(is_zombie), .SpriteR(ZombieR), .SpriteG(ZombieG), .SpriteB(ZombieB));

   SpriteTable_F SpriteTable_F_inst (
                        // inputs
                        .Clk(Clk), .DrawX(DrawX), .DrawY(DrawY),
                        //.fontX(10'd256),.fontY(10'd16), // String's starting x,y coordinates
                        .level(level), // 1 indexed
                        .player_health(player_health), // health remaining
                        // Outputs
                        .is_font_level,.is_font_health, .is_font_game_over,
                        .is_font_play, .is_font_win,
                        .fontR, .fontG, .fontB
                        );
endmodule
