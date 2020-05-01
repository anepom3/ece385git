module Game_state (input logic Clk, Reset_h, Play,
                   // Place other inputs and outputs
                   input logic enemies,
                   input logic [3:0] player_health,
                   output logic [3:0] level,
                   output logic [1:0] event_screen,
                   output logic new_level,
                   output logic [9:0] zombie_0_speed, zombie_1_speed, zombie_2_speed,
                   output logic [9:0] zombie_0_delay_spawn, zombie_1_delay_spawn, zombie_2_delay_spawn
                  );

    enum logic [3:0] {// Add additional states as needed...
                      Title,
                      Level_1, Level_2, Level_3,
                      Level_4, Level_5, Level_6,
                      Level_7, Level_8, Level_9,
                      Level_10, Win   , Game_Over
                     } State, Next_State;

    // Internal logics here

    // Clock signal events always_ff
    always_ff @ (posedge Clk)
    begin
      if(Reset_h) begin
        State <= Title;
      end
      else begin
        State <= Next_State;
      end
    end

    // Next_State and Control Signals always_comb
    always_comb begin
      // Default Next_State
      Next_State = State;

      //Default control signal values
      level = 4'd0; // Level 1 begins at level = 0001 (i.e. 1 index)
      event_screen = 2'd0; // 00 -Title, 01 - Play, 10 - Win, 11 - Game_Over
      new_level = 0;
      zombie_0_delay_spawn=10'd0;
      zombie_0_speed=10'd0;
      zombie_1_delay_spawn=10'd0;
      zombie_1_speed=10'd0;
      zombie_2_delay_spawn=10'd0;
      zombie_2_speed=10'd0;


      // Assign Next_State based on State
      case(State)
        Title:
          begin
            if(Play)
              Next_State = Level_1;
          end
        Level_1:
          begin
            if(enemies == 0)
              Next_State = Win;
            else if(player_health == 4'b0) // adjust # of bits based on player_health
              Next_State = Game_Over;
          end
        Level_2:
          begin
            if(enemies == 0)
              Next_State = Level_3;
            else if(player_health == 4'b0) // adjust # of bits based on player_health
              Next_State = Game_Over;
          end
        Level_3:
          begin
            if(enemies == 0)
              Next_State = Level_4;
            else if(player_health == 4'b0) // adjust # of bits based on player_health
              Next_State = Game_Over;
          end
        Level_4:
          begin
            if(enemies == 0)
              Next_State = Level_5;
            else if(player_health == 4'b0) // adjust # of bits based on player_health
              Next_State = Game_Over;
          end
        Level_5:
          begin
            if(enemies == 0)
              Next_State = Level_6;
            else if(player_health == 4'b0) // adjust # of bits based on player_health
              Next_State = Game_Over;
          end
        Level_6:
          begin
            if(enemies == 0)
              Next_State = Level_7;
            else if(player_health == 4'b0) // adjust # of bits based on player_health
              Next_State = Game_Over;
          end
        Level_7:
          begin
            if(enemies == 0)
              Next_State = Level_8;
            else if(player_health == 4'b0) // adjust # of bits based on player_health
              Next_State = Game_Over;
          end
        Level_8:
          begin
            if(enemies == 0)
              Next_State = Level_9;
            else if(player_health == 4'b0) // adjust # of bits based on player_health
              Next_State = Game_Over;
          end
        Level_9:
          begin
            if(enemies == 0)
              Next_State = Level_10;
            else if(player_health == 4'b0) // adjust # of bits based on player_health
              Next_State = Game_Over;
          end
        Level_10:
          begin
            if(enemies == 0)
              Next_State = Win;
            else if(player_health == 4'b0) // adjust # of bits based on player_health
              Next_State = Game_Over;
          end
        Win:
          begin
            if(Play)
              Next_State = Title;
          end
        Game_Over:
          begin
            Next_State = Title;
            if(Play)
              Next_State = Level_1;
          end
        default: ;
      endcase

      // Assign Control signals based on State
      case (State)
        Title:;
        Level_1:
          begin
            level = 4'd1;
            event_screen = 2'd1;
            zombie_0_delay_spawn=10'd100;
            zombie_0_speed=10'd1;
            zombie_1_delay_spawn=10'd200;
            zombie_1_speed=10'd1;
            zombie_2_delay_spawn=10'd300;
            zombie_2_speed=10'd2;
          end
        Level_2:
          begin
            level = 4'd2;
            event_screen = 2'd1;
          end
        Level_3:
          begin
            level = 4'd3;
            event_screen = 2'd1;
          end
        Level_4:
          begin
            level = 4'd4;
            event_screen = 2'd1;
          end
        Level_5:
          begin
            level = 4'd5;
            event_screen = 2'd1;
          end
        Level_6:
          begin
            level = 4'd6;
            event_screen = 2'd1;
          end
        Level_7:
          begin
            level = 4'd7;
            event_screen = 2'd1;
          end
        Level_8:
          begin
            level = 4'd8;
            event_screen = 2'd1;
          end
        Level_9:
          begin
            level = 4'd9;
            event_screen = 2'd1;
          end
        Level_10:
          begin
            level = 4'd10;
            event_screen = 2'd1;
          end
        Win:
          begin
            event_screen = 2'd2;
          end
        Game_Over:
          begin
            event_screen = 2'd3;
          end
        default: ;
      endcase

      if(Next_State != State)
        new_level = 1;
    end

endmodule
