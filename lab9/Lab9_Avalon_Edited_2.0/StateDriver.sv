// StateDriver: This is the State Machine for the Decryption in Hardware protion
// of the lab.

module StateDriver (
                    input logic Clk,
                      Reset,
                      Start_h, // Start Decryption flag from reg[14]
                    input logic [1407:0] KeySchedule, // Contains the key for each round with a total of 11 keys.

                    output logic update_state, // 0 - do nothing to state of message; 1 - take output value and place into state
                    output logic initialize, // 1 - intiialize the state update buffer to be the encrypted message; 0 - follow general decryption for updating the state
                    output logic [1:0] WORD_SEL, // The control signal for which word to output of the current state message.
                    output logic [1:0] OUTPUT_SEL, //
                    output logic [127:0] out_key,
                    output logic Done_h
                    );


    enum logic [4:0] { Rest,
                       Done,
                       // TO-DO: Fill in all needed states for decryption
                       Key_Expansion_0,
                       Key_Expansion_1,
                       Key_Expansion_2,
                       Key_Expansion_3,
                       Key_Expansion_4,
                       Key_Expansion_5,
                       Key_Expansion_6,
                       Key_Expansion_7,
                       Key_Expansion_8,
                       Key_Expansion_9,
                       Add_Round_Key_Init,
                       Inv_Shift_Rows_Loop, //State wise (whole 128 - bits all at once)
                       Inv_Sub_Bytes_Loop, // Byte wise (but can parallelize this to be state wise; no bytes are dependent on each other)
                       Add_Round_Key_Loop, // Word wise or state wise
                       Inv_Mix_Columns_Loop_0, //Word wise and 1 instantiation of Inv_Mix_Columns module
                       Inv_Mix_Columns_Loop_1,
                       Inv_Mix_Columns_Loop_2,
                       Inv_Mix_Columns_Loop_3,
                       Inv_Shift_Rows_End,
                       Inv_Sub_Bytes_End,
                       Add_Round_Key_End
                     } State, Next_State;

    logic [3:0] Loop_count; // counts the 9 loops of the main decryption loop
    logic [3:0] Loop_count_next; // next loop value


    always_ff @ (posedge Clk)
    begin
      if (Reset) begin// Move to rest state and reset appropriate signals.
  			State <= Rest;
        Loop_count <= 4'b0000;
      end
  		else begin // Otherwise proceed to next state and Loop_count
  			State <= Next_State;
        Loop_count <= Loop_count_next;
      end
    end

    always_comb
    begin
      // Default Next_State
      Next_State = State;

      // Default control signal values
      Loop_count_next = Loop_count; // hold value if nothing changes
      out_key = 128'd0;
      WORD_SEL = 2'b00; // Selects the first word of the current state message
      OUTPUT_SEL = 2'b00; // 00 -Add_Round_Key, 01 - Inv_Shift_Rows, 10 - Inv_Sub_Bytes, 11 - Inv_Mix_Columns
      update_state = 1'b1; // generally active, only set low manually during 'Rest' and 'Done' states
      initialize = 1'b0;
      Done_h = 1'b0;


      // Assign Next_State
      case (State)
        Rest:
          if(Start_h)
            Next_State = Key_Expansion_0;

        /* Decryption States */
        Key_Expansion_0: // Goes through 10 clock cycles for complete Key_Expansion
          Next_State = Key_Expansion_1;
        Key_Expansion_1:
          Next_State = Key_Expansion_2;
        Key_Expansion_2:
          Next_State = Key_Expansion_3;
        Key_Expansion_3:
          Next_State = Key_Expansion_4;
        Key_Expansion_4:
          Next_State = Key_Expansion_5;
        Key_Expansion_5:
          Next_State = Key_Expansion_6;
        Key_Expansion_6:
          Next_State = Key_Expansion_7;
        Key_Expansion_7:
          Next_State = Key_Expansion_8;
        Key_Expansion_8:
          Next_State = Key_Expansion_9;
        Key_Expansion_9:
          Next_State = Done;
        Add_Round_Key_Init:
          Next_State = Inv_Shift_Rows_Loop;
        // Begins the 9 Decryption Rounds.
        Inv_Shift_Rows_Loop:
          Next_State = Inv_Sub_Bytes_Loop;
        Inv_Sub_Bytes_Loop:
          Next_State = Add_Round_Key_Loop;
        Add_Round_Key_Loop:
          Next_State = Inv_Mix_Columns_Loop_0;
        // Has 4 Inv_Mix_Columns states because it is wordwise
        Inv_Mix_Columns_Loop_0:
          Next_State = Inv_Mix_Columns_Loop_1;
        Inv_Mix_Columns_Loop_1:
          Next_State = Inv_Mix_Columns_Loop_2;
        Inv_Mix_Columns_Loop_2:
          Next_State = Inv_Mix_Columns_Loop_3;
        Inv_Mix_Columns_Loop_3:
          if(Loop_count >= 4'b1000) // b'1000 = 8, check if it the last loop (Might need to be 1001 = 9)
            Next_State = Inv_Shift_Rows_End;
          else
            // Next_State = Inv_Mix_Columns_Loop_0;
            Next_State = Inv_Shift_Rows_Loop;
        // Final Decryption Round
        Inv_Shift_Rows_End:
          Next_State = Inv_Sub_Bytes_End;
        Inv_Sub_Bytes_End:
          Next_State = Add_Round_Key_End;
        Add_Round_Key_End:
          Next_State = Done;
        // Stay in Done until Start_h is lowered.
        Done:
          if(~Start_h)
            Next_State = Rest;
        default: ;
      endcase


      // Assign Control signals based on State
      case (State)
        Rest:
        begin
          Loop_count_next = 4'd0;
          update_state = 1'b0; // just load state back into itself
        end
        Key_Expansion_0:
          begin//Key_Expansion_0 signal values
          update_state = 1'b1; // load state back into itself with signal below
          initialize = 1'b1; // bring initial encrypted message into StateUpdateBuffer
          end
        Key_Expansion_1:
        begin//Key_Expansion_0 signal values
          update_state = 1'b0;
          initialize = 1'b0;
        end
        Key_Expansion_2:
        begin
          //Key_Expansion_0 signal values
          update_state = 1'b0;
          initialize = 1'b0;
        end
        Key_Expansion_3:
        begin
          //Key_Expansion_0 signal values
          update_state = 1'b0;
          initialize = 1'b0;
        end
        Key_Expansion_4:
        begin
          //Key_Expansion_0 signal values
          update_state = 1'b0;
          initialize = 1'b0;
        end
        Key_Expansion_5:
        begin
          //Key_Expansion_0 signal values
          update_state = 1'b0;
          initialize = 1'b0;
        end
        Key_Expansion_6:
        begin
          //Key_Expansion_0 signal values
          update_state = 1'b0;
          initialize = 1'b0;
        end
        Key_Expansion_7:
        begin
          //Key_Expansion_0 signal values
          update_state = 1'b0;
          initialize = 1'b0;
        end
        Key_Expansion_8:
        begin
          //Key_Expansion_0 signal values
          update_state = 1'b0;
          initialize = 1'b0;
        end
        Key_Expansion_9:
        begin
          //Key_Expansion_0 signal values
          update_state = 1'b0; // load state back into itself with signal below
          initialize = 1'b0;
        end
        Add_Round_Key_Init:
        begin
          out_key = KeySchedule [1407:1280]; // 1) [1407:1376], 2) [1375:1344], 3) [1343:1312], 4) [1311:1280] <-- 4 32bit keys
          OUTPUT_SEL = 2'b00;
        end
        Inv_Shift_Rows_Loop:
          OUTPUT_SEL = 2'b01;
        Inv_Sub_Bytes_Loop:
          OUTPUT_SEL = 2'b10;
        Add_Round_Key_Loop:
        begin
          OUTPUT_SEL = 2'b00;
          case(Loop_count)
            4'b0000:out_key = KeySchedule[1279:1152];
            4'b0001:out_key = KeySchedule[1151:1024];
            4'b0010:out_key = KeySchedule[1023:896];
            4'b0011:out_key = KeySchedule[895:768];
            4'b0100:out_key = KeySchedule[767:640];
            4'b0101:out_key = KeySchedule[639:512];
            4'b0110:out_key = KeySchedule[511:384];
            4'b0111:out_key = KeySchedule[383:256];
            4'b1000:out_key = KeySchedule[255:128];
            default: out_key = KeySchedule[127:0];
          endcase
        end
        Inv_Mix_Columns_Loop_0:
        begin
          WORD_SEL = 2'b00;
          OUTPUT_SEL = 2'b11;
        end
        Inv_Mix_Columns_Loop_1:
        begin
          WORD_SEL = 2'b01;
          OUTPUT_SEL = 2'b11;
        end
        Inv_Mix_Columns_Loop_2:
        begin
          WORD_SEL = 2'b10;
          OUTPUT_SEL = 2'b11;
        end
        Inv_Mix_Columns_Loop_3:
        begin
          WORD_SEL = 2'b11;
          OUTPUT_SEL = 2'b11;
          if(Loop_count >= 4'b1000) // check if it the last loop
            Loop_count_next = 4'b0000;
          else
            Loop_count_next = Loop_count + 1;
        end
        Inv_Shift_Rows_End:
          OUTPUT_SEL = 2'b01;
        Inv_Sub_Bytes_End:
          OUTPUT_SEL = 2'b10;
        Add_Round_Key_End:
        begin
          OUTPUT_SEL = 2'b00;
          out_key = KeySchedule [127:0]; // last 128-bits are final key
        end

        Done:
        begin
          Loop_count_next = 4'd0;
          update_state = 1'b0; // just load state back into itself
          Done_h = 1'b1;
        end
        default: ;
      endcase
    end


endmodule // StateDriver
