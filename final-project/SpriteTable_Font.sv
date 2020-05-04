module SpriteTable_F (
                      // inputs
                      input logic Clk,
                      input logic [9:0] DrawX,DrawY,
                      input logic [9:0] fontX,fontY, // String's starting x,y coordinates
                      input logic [3:0] level, // 1 indexed

                      // Outputs
                      output logic is_font,
                      output logic [7:0] fontR, fontG, fontB
                      );


  logic [56:0] level_string;

  logic [7:0] current_char;
  logic [10:0] current_x;
  logic [6:0] regions;

  logic [10:0] sprite_addr;
  logic [7:0]  sprite_data;
  font_rom font_rom_inst (.addr(sprite_addr), .data(sprite_data));

  region region_0(.*, .fontX(fontX), .fontY(fontY), .index(10'd0), .region(regions[0]), .current_x(current_x_0));

  region region_1(.*, .fontX(fontX), .fontY(fontY), .index(10'd1), .region(regions[1]), .current_x(current_x_1));

  region region_2(.*, .fontX(fontX), .fontY(fontY), .index(10'd2), .region(regions[2]), .current_x(current_x_2));

  region region_3(.*, .fontX(fontX), .fontY(fontY), .index(10'd3), .region(regions[3]), .current_x(current_x_3));

  region region_4(.*, .fontX(fontX), .fontY(fontY), .index(10'd4), .region(regions[4]), .current_x(current_x_4));

  region region_5(.*, .fontX(fontX), .fontY(fontY), .index(10'd5), .region(regions[5]), .current_x(current_x_5));

  region region_6(.*, .fontX(fontX), .fontY(fontY), .index(10'd6), .region(regions[6]), .current_x(current_x_6));

  // Implementation
  always_comb begin
	  level_string = {8'h4c,8'h65,8'h76,8'h65,8'h6c,8'h20,8'h30+level};
    current_x = fontX;
    current_char = level_string[7:0];
    is_font = 1'b0;
    fontR = 8'h00;
    fontG = 8'h00;
    fontB = 8'h00;
    case(regions)
      7'b0000001 : begin
        current_x = current_x_0;
        current_char = level_string[55:48];
        is_font = 1'b1;
      end
      7'b0000010 : begin
        current_x = current_x_1;
        current_char = level_string[47:40];
        is_font = 1'b1;
      end
      7'b0000100 : begin
        current_x = current_x_2;
        current_char = level_string[39:32];
        is_font = 1'b1;
      end
      7'b0001000 : begin
        current_x = current_x_3;
        current_char = level_string[31:24];
        is_font = 1'b1;
      end
      7'b0010000 : begin
        current_x = current_x_4;
        current_char = level_string[23:16];
        is_font = 1'b1;
      end
      7'b0100000 : begin
        current_x = current_x_5;
        current_char = level_string[15:8];
        is_font = 1'b1;
      end
      7'b1000000 : begin
        current_x = current_x_6;
        current_char = level_string[7:0];
        is_font = 1'b1;
      end
      default: ;
    endcase
    sprite_addr = (DrawY-fontY + 11'd16 * current_char);
    if(sprite_data[current_x - DrawX] == 1'b1)
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
