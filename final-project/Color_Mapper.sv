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
                       input  logic [9:0] Zombie0X, Zombie0Y, // Current location of shooter (upper left pixel)
                       input  logic [1:0] Zombie0Face,         // Direction Shooter is facing
                       input  logic [9:0] Zombie1X, Zombie1Y, // Current location of shooter (upper left pixel)
                       input  logic [1:0] Zombie1Face,         // Direction Shooter is facing
                       input  logic [9:0] Zombie2X, Zombie2Y, // Current location of shooter (upper left pixel)
                       input  logic [1:0] Zombie2Face,         // Direction Shooter is facing
                       input  logic zombie_0_live, zombie_1_live, zombie_2_live,
                       input  logic [0:14][0:19][0:1] barrier,     // barrier
                       input  logic [1:0] event_screen,
                       input  logic is_ball,
                       output logic [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output
                     );

    logic [7:0] Red, Green, Blue;
    logic [7:0] SpriteR, SpriteG, SpriteB;
    logic [7:0] ZombieR, ZombieG, ZombieB;
    logic is_shooter;
    logic is_zombie;
    // Output colors to VGA
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;

    // Assign color based on is_ball signal
    always_comb
    begin
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

    end

    SpriteTable_S SpriteTable_S_inst(.Clk(Clk), .ShooterFace(ShooterFace), .ShooterX(ShooterX), .ShooterY(ShooterY), .DrawX(DrawX), .DrawY(DrawY),
                                     .is_shooter(is_shooter), .SpriteR(SpriteR), .SpriteG(SpriteG), .SpriteB(SpriteB));
   SpriteTable_Z SpriteTable_Z_inst(.Clk(Clk), .DrawX(DrawX), .DrawY(DrawY),
                                    .Zombie0Face(Zombie0Face), .Zombie0X(Zombie0X), .Zombie0Y(Zombie0Y),
                                    .Zombie1Face(Zombie1Face), .Zombie1X(Zombie1X), .Zombie1Y(Zombie1Y),
                                    .Zombie2Face(Zombie2Face), .Zombie2X(Zombie2X), .Zombie2Y(Zombie2Y),
                                    .zombie_0_live, .zombie_1_live, .zombie_2_live,
                                    .is_zombie(is_zombie), .SpriteR(ZombieR), .SpriteG(ZombieG), .SpriteB(ZombieB));
endmodule
