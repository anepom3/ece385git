module SpriteTable_F (
                      // inputs
                      input logic Clk,
                      input logic [9:0] DrawX,DrawY,
                      //input logic [9:0] fontX,fontY, // String's starting x,y coordinates
                      input logic [3:0] level, // 1 indexed
                      input logic [3:0] player_health,

                      // Outputs
                      output logic is_font_level,is_font_health, is_font_game_over,
                                   is_font_play, is_font_win,
                      output logic [7:0] fontR, fontG, fontB
                      );

  //parameter [10:0] string_space = 11'd16;
  parameter [10:0] string_region = 10'd72;


  logic [71:0] level_string;
  logic [71:0] health_string;
  logic [71:0] game_over_string;
  logic [71:0] play_string;
  logic [71:0] win_string;

  logic [71:0] current_string;
  logic [7:0] current_char;
  logic [9:0] current_x;
  logic [9:0] current_fontX, current_fontY;
  logic [8:0] regions;

  logic [10:0] sprite_addr;
  logic [7:0]  sprite_data;
  font_rom font_rom_inst (.addr(sprite_addr), .data(sprite_data));

  region region_0(.*, .fontX(current_fontX), .fontY(current_fontY), .index(10'd0), .region(regions[0]), .current_x(current_x_0));

  region region_1(.*, .fontX(current_fontX), .fontY(current_fontY), .index(10'd1), .region(regions[1]), .current_x(current_x_1));

  region region_2(.*, .fontX(current_fontX), .fontY(current_fontY), .index(10'd2), .region(regions[2]), .current_x(current_x_2));

  region region_3(.*, .fontX(current_fontX), .fontY(current_fontY), .index(10'd3), .region(regions[3]), .current_x(current_x_3));

  region region_4(.*, .fontX(current_fontX), .fontY(current_fontY), .index(10'd4), .region(regions[4]), .current_x(current_x_4));

  region region_5(.*, .fontX(current_fontX), .fontY(current_fontY), .index(10'd5), .region(regions[5]), .current_x(current_x_5));

  region region_6(.*, .fontX(current_fontX), .fontY(current_fontY), .index(10'd6), .region(regions[6]), .current_x(current_x_6));

  region region_7(.*, .fontX(current_fontX), .fontY(current_fontY), .index(10'd7), .region(regions[7]), .current_x(current_x_7));

  region region_8(.*, .fontX(current_fontX), .fontY(current_fontY), .index(10'd8), .region(regions[8]), .current_x(current_x_8));

  // Implementation
  always_comb begin
    // if(level region) --> fontx_lev, fonty_lev, string=level
    health_string = {8'h48,8'h65,8'h61,8'h6c,8'h74,8'h68,8'h20,8'h30+player_health,8'h7f};
	  level_string = {8'h4c,8'h65,8'h76,8'h65,8'h6c,8'h20,8'h30+level,8'h7f,8'h7f};
    game_over_string ={8'h47,8'h41,8'h4d,8'h45,8'h20,8'h4f,8'h56,8'h45,8'h52};
    win_string = {8'h59,8'h6f,8'h75,8'h20,8'h57,8'h69,8'h6e,8'h21,8'h7f};
    play_string ={8'h50,8'h6c,8'h61,8'h79,8'h7f,8'h7f,8'h7f,8'h7f,8'h7f};

    is_font_level = 1'b0;
    is_font_health  = 1'b0;
    is_font_game_over = 1'b0;
    is_font_play  = 1'b0;
    is_font_win = 1'b0;
    current_x = 10'd0;
    current_fontX = 10'd0;
    current_fontY = 10'd0;
    current_char = 8'd0;
    current_string = 72'd0;
    // Level String
    if((DrawX >= 10'd216) && (DrawX < 10'd216 + string_region) &&
       (DrawY >= 10'd16)  && (DrawY < 10'd31))
       begin
         is_font_level = 1'b1;
         current_string = level_string;
         current_fontX = 10'd216;
         current_fontY = 10'd16;
       end
    // Health String
    if((DrawX >= 10'd360) && (DrawX < 10'd360 + string_region) &&
      (DrawY >= 10'd16)  && (DrawY < 10'd31))
       begin
         is_font_health = 1'b1;
         current_string = health_string;
         current_fontX = 10'd360;
         current_fontY = 10'd16;
       end
    // Game Over
    if((DrawX >= 10'd288) && (DrawX < 10'd288 + string_region) &&
       (DrawY >= 10'd248)  && (DrawY < 10'd248 + 10'd15))
       begin
         is_font_game_over = 1'b1;
         current_string = game_over_string;
         current_fontX = 10'd288;
         current_fontY = 10'd248;
       end
    // You Win!
    if((DrawX >= 10'd288) && (DrawX < 10'd288 + string_region) &&
      (DrawY >= 10'd216)  && (DrawY < 10'd216 + 10'd15))
       begin
         is_font_win = 1'b1;
         current_string = win_string;
         current_fontX = 10'd288;
         current_fontY = 10'd216;
       end
    // Play
    if((DrawX >= 10'd312) && (DrawX < 10'd312 + string_region) &&
       (DrawY >= 10'd232)  && (DrawY < 10'd232 + 10'd15))
       begin
         is_font_play = 1'b1;
         current_string = play_string;
         current_fontX = 10'd312;
         current_fontY = 10'd232;
       end



    fontR = 8'h00;
    fontG = 8'h00;
    fontB = 8'h00;
    case(regions)
      9'b000000001 : begin
        current_x = current_x_0;
        current_char = current_string[71:64];
      end
      9'b000000010 : begin
        current_x = current_x_1;
        current_char = current_string[63:56];
      end
      9'b000000100 : begin
        current_x = current_x_2;
        current_char = current_string[55:48];
      end
      9'b000001000 : begin
        current_x = current_x_3;
        current_char = current_string[47:40];
      end
      9'b000010000 : begin
        current_x = current_x_4;
        current_char = current_string[39:32];
      end
      9'b000100000 : begin
        current_x = current_x_5;
        current_char = current_string[31:24];
      end
      9'b001000000 : begin
        current_x = current_x_6;
        current_char = current_string[23:16];
      end
      9'b010000000 : begin
        current_x = current_x_7;
        current_char = current_string[15:8];
      end
      9'b100000000 : begin
        current_x = current_x_8;
        current_char = current_string[7:0];
      end
      default: ;
    endcase
    sprite_addr = (DrawY - current_fontY + 11'd16 * current_char);
    if((sprite_data[current_x - DrawX] == 1'b1) && (current_char != 8'h7f))
    begin
      fontR = 8'hff;
      fontG = 8'hff;
      fontB = 8'hff;
    end
  end

endmodule // SpriteTable_F

module region (input logic  [9:0] DrawX, DrawY,
               input logic [10:0] fontX, fontY,
               input logic [9:0] index,
               output logic region,
               output logic [10:0] current_x
              );
  parameter [10:0] shape_size_x = 11'd8;
  parameter [10:0] shape_size_y = 11'd16;

  always_comb begin
    current_x = fontX + (index<<3); // index * 8
    region = 1'b0;
    if(DrawX >= current_x && DrawX < current_x + shape_size_x &&
       DrawY >= fontY && DrawY < fontY + shape_size_y)
       begin
         region = 1'b1;
       end
  end
endmodule // region
