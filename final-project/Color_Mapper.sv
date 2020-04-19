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
module  color_mapper ( input  logic [9:0] DrawX, DrawY,       // Current pixel coordinates
                       input  logic [9:0] ShooterX, ShooterY, // Current location of shooter (upper left pixel)
                       input  logic [1:0] ShooterFace,         // Direction Shooter is facing
                       output logic [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output
                     );

    logic [7:0] Red, Green, Blue;
    // logic [7:0] Red_t, Green_t, Blue_t;

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
        // Map of room for game
        if((DrawX > 10'd19) && (DrawX < 10'd620) && (DrawY > 10'd49) && (DrawY < 10'd460))
        begin
            // black edge of map (black)
            Red = 8'hff;
            Green = 8'hff;
            Blue = 8'hff;
            if((DrawX > 10'd31) && (DrawX < 10'd608) && (DrawY > 10'd61) && (DrawY < 10'd448))
            begin
                // Floor of map (blue)
                Red = 8'h00;
                Green = 8'h00;
                Blue = 8'hff;
                // check if pixel is part of shooter image
                if((DrawX >= ShooterX) && (DrawX < ShooterX + 32) && (DrawY >= ShooterY) && (DrawY < ShooterY + 32))
                begin
                  Red = 8'hff;
                  Green = 8'hff;
                  Blue = 8'hff;
                    // get pixel of shooter from on-chip memory???
                    // case (ShooterFace)
                    //   2'b00: // up --> black
                    //   begin
                    //     Red_t = 8'hff;
                    //     Green_t = 8'hff;
                    //     Blue_t = 8'hff;
                    //   end
                    //   2'b01: // right --> red
                    //   begin
                    //     Red_t = 8'hff;
                    //     Green_t = 8'h00;
                    //     Blue_t = 8'h00;
                    //   end
                    //   2'b10: // down --> green
                    //   begin
                    //     Red_t = 8'h00;
                    //     Green_t = 8'hff;
                    //     Blue_t = 8'h00;
                    //   end
                    //   2'b11: // left --> purple
                    //   begin
                    //     Red_t = 8'hff;
                    //     Green_t = 8'h00;
                    //     Blue_t = 8'hff;
                    //   end
                    //   default: ;
                    // endcase
                    // if(~((Red_t == 8'h00) && (Green_t == 8'h00) && (Blue_t == 8'h00))) //check if transparent background pixel of image
                    // begin
                    //     Red = Red_t;
                    //     Green = Green_t;
                    //     Blue = Blue_t;
                    // end
                end
            end
        end
    end
endmodule
