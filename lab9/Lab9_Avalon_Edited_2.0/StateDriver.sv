// StateDriver
// Input : System Clock, input Byte
// Output: SubBytes transformation of the Byte

module StateDriver (
                    input logic Clk,
                      Reset,
                      Start_h, // Start Decryption flag from reg[14]
                    input logic [1407:0] KeySchedule,

                    output logic update_state, // 0 - do nothing to state of message; 1 - take output value and place into state
                    output logic [1:0] WORD_SEL,
                    output logic [1:0] OUTPUT_SEL,
                    output logic [31:0] out_key
                    );


    enum logic [4:0] { Rest,
                       Done,
                       // TO-DO: Fill in all needed states for decryption
                       Add_Round_Key_Init,
                       Inv_Shift_Rows_Loop,
                       Inv_Sub_Bytes_Loop,
                       Add_Round_Key_Loop,
                       Inv_Mix_Columns_Loop,
                       Inv_Shift_Rows_End,
                       Inv_Sub_Bytes_End,
                       Add_Round_Key_End
                     } State, Next_State;

    logic [2:0] word_cycle; // cycles through 4 words for each operation
    logic [2:0] word_cycle_next; // next word for operation
    logic [3:0] loop_count; // counts the 9 loops of the main decryption loop
    logic [3:0] loop_count_next; // next loop value


    always_ff @ (posedge Clk)
    begin
      if (Reset)
  			State <= Rest;
        word_cycle <= 3'b000;
        word_cycle_next <= 3'b000;
        loop_count <= 4'b0000;
        loop_count_next <= 4'b0000;
  		else
  			State <= Next_State;
        word_cycle <= word_cycle_next;
        loop_count <= loop_count_next;
    end

    always_comb
    begin
      // Default Next_State
      Next_State = State;

      // Default control signal values
      word_cycle_next = word_cycle; // hold value if nothing changes
      loop_count_next = loop_count; // hold value if nothing changes
      cur_key = 32'h00000000;
      WORD_SEL = 2'b00;
      OUTPUT_SEL = 2'b00;
      update_state = 1'b1; // generally active, only set low manually during 'Rest' and 'Done' states


      // Assign Next_State
      case (State)
        Rest:
          if(Start_h)
            Next_State = Add_Round_Key_Init;

        /* Decryption States */
        Add_Round_Key_Init:
          if(word_cycle == 3'b011)
            Next_State = Inv_Shift_Rows_Loop;
        Inv_Shift_Rows_Loop:
          if(word_cycle == 3'b011)
            Next_State = Inv_Sub_Bytes_Loop;
        Inv_Sub_Bytes_Loop:
          if(word_cycle == 3'b011)
            Next_State = Add_Round_Key_Loop;
        Add_Round_Key_Loop:
          if(word_cycle == 3'b011)
            Next_State = Inv_Mix_Columns_Loop;
        Inv_Mix_Columns_Loop:
          if(word_cycle == 3'b011)
          begin
            if(loop_count >= 4'b1001)
              Next_State = Inv_Shift_Rows_End;
            else
              Next_State = Inv_Shift_Rows_Loop;
          end
        Inv_Shift_Rows_End:
          if(word_cycle == 3'b011)
            Next_State = Inv_Sub_Bytes_End;
        Inv_Sub_Bytes_End:
          if(word_cycle == 3'b011)
            Next_State = Add_Round_Key_End;
        Add_Round_Key_End:
          if(word_cycle == 3'b011)
            Next_State = Done;

        Done:
          if(~Start_h)
            Next_State = Rest;
        default: ;
      endcase


      // Assign Control signals based on State
      case (State)
        Rest:
          word_cycle_next = 3'd0;
          loop_count_next = 4'd0;
          update_state = 1'b0; // just load state back into itself

        Add_Round_Key_Init:
          out_key = KeySchedule [(1407 - (32 * word_cycle)):(1408 - (32 * word_cycle) - 32)];
          WORD_SEL = word_cycle [1:0];
          OUTPUT_SEL = 2'b00;
          if(word_cycle == 3'b011)
            word_cycle_next = 3'b000; // set to 0 for next operation
          else
            word_cycle_next = word_cycle + 1;

        Inv_Shift_Rows_Loop:
          WORD_SEL = word_cycle [1:0];
          OUTPUT_SEL = 2'b01;
          if(word_cycle == 3'b011)
            word_cycle_next = 3'b000; // set to 0 for next operation
          else
            word_cycle_next = word_cycle + 1;

        Inv_Sub_Bytes_Loop:
          WORD_SEL = word_cycle [1:0];
          OUTPUT_SEL = 2'b10;
          if(word_cycle == 3'b011)
            word_cycle_next = 3'b000; // set to 0 for next operation
          else
            word_cycle_next = word_cycle + 1;

        Add_Round_Key_Loop:
          WORD_SEL = word_cycle [1:0];
          OUTPUT_SEL = 2'b00;
          out_key = KeySchedule [((1407 - (128 * loop_count)) - (32 * word_cycle)):((1408 - (128 * loop_count)) - (32 * word_cycle) - 32)];
          if(word_cycle == 3'b011)
            word_cycle_next = 3'b000; // set to 0 for next operation
          else
            word_cycle_next = word_cycle + 1;

        Inv_Mix_Columns_Loop: // Include check for if it was the last loop
          WORD_SEL = word_cycle [1:0];
          OUTPUT_SEL = 2'b11;
          if(word_cycle == 3'b011)
          begin
            word_cycle_next = 3'b000; // set to 0 for next operation
            if(loop_count >= 4'b1001)
              loop_count = 4'b0000; // reset to 0 if loop are done and going to end
            else
              loop_count = loop_count + 1;
          end

        Inv_Shift_Rows_End:
          WORD_SEL = word_cycle [1:0];
          OUTPUT_SEL = 2'b01;
          if(word_cycle == 3'b011)
            word_cycle_next = 3'b000; // set to 0 for next operation
          else
            word_cycle_next = word_cycle + 1;

        Inv_Sub_Bytes_End:
          WORD_SEL = word_cycle [1:0];
          OUTPUT_SEL = 2'b10;
          if(word_cycle == 3'b011)
            word_cycle_next = 3'b000; // set to 0 for next operation
          else
            word_cycle_next = word_cycle + 1;

        Add_Round_Key_End:
          WORD_SEL = word_cycle [1:0];
          OUTPUT_SEL = 2'b00;
          out_key = KeySchedule [(127 - (32 * word_cycle)):(128 - (32 * word_cycle) - 32)]; // last 128-bits are final key
          if(word_cycle == 3'b011)
            word_cycle_next = 3'b000; // set to 0 for next operation
          else
            word_cycle_next = word_cycle + 1;

        Done:
          word_cycle_next = 3'd0;
          loop_count_next = 4'd0;
          update_state = 1'b0; // just load state back into itself
        default: ;

      endcase
    end


endmodule // StateDriver
