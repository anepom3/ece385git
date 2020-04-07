// StateDriver

module StateDriver (
                    input logic Clk,
                      Reset,
                      Start_h, // Start Decryption flag from reg[14]
                    input logic [1407:0] KeySchedule,

                    output logic update_state, // 0 - do nothing to state of message; 1 - take output value and place into state
                    output logic initialize, // 1 - intiialize the state update buffer to be the encrypted message; 0 - follow general decryption for updating the state
                    output logic [1:0] WORD_SEL,
                    output logic [1:0] OUTPUT_SEL,
                    output logic [31:0] out_key
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

    logic [3:0] loop_count; // counts the 9 loops of the main decryption loop
    logic [3:0] loop_count_next; // next loop value


    always_ff @ (posedge Clk)
    begin
      if (Reset)
  			State <= Rest;
        loop_count <= 4'b0000;
        loop_count_next <= 4'b0000;
        update_state <= 1'b0;
        initialize <= 1'b0;
  		else
  			State <= Next_State;
        loop_count <= loop_count_next;
    end

    always_comb
    begin
      // Default Next_State
      Next_State = State;

      // Default control signal values
      loop_count_next = loop_count; // hold value if nothing changes
      out_key = 128'd0;
      WORD_SEL = 2'b00;
      OUTPUT_SEL = 2'b00;
      update_state = 1'b1; // generally active, only set low manually during 'Rest' and 'Done' states
      initialize = 1'b0;


      // Assign Next_State
      case (State)
        Rest:
          if(Start_h)
            Next_State = Key_Expansion_0;

        /* Decryption States */
        Key_Expansion_0: // How many KeyExpansion states are needed???
          Next_State = Key_Expansion_1;
        Key_Expansion_1:
          Next_State = Key_Expansion_2; // finish this and below
        // Add in rest of Key Expansion states
        Add_Round_Key_Init:
          Next_State = Inv_Shift_Rows_Loop;
        Inv_Shift_Rows_Loop:
          Next_State = Inv_Sub_Bytes_Loop;
        Inv_Sub_Bytes_Loop:
          Next_State = Add_Round_Key_Loop;
        Add_Round_Key_Loop:
          Next_State = Inv_Mix_Columns_Loop_0;
        Inv_Mix_Columns_Loop_0:
          Next_State = Inv_Mix_Columns_Loop_1;
        Inv_Mix_Columns_Loop_1:
          Next_State = Inv_Mix_Columns_Loop_2;
        Inv_Mix_Columns_Loop_2:
          Next_State = Inv_Mix_Columns_Loop_3;
        Inv_Mix_Columns_Loop_3:
          if(loop_count >= 4'b1000) // check if it the last loop (Might need to be 1001)
            Next_State = Inv_Shift_Rows_End;
          else
            Next_State = Inv_Mix_Columns_Loop_0;
        Inv_Shift_Rows_End:
          Next_State = Inv_Sub_Bytes_End;
        Inv_Sub_Bytes_End:
          Next_State = Add_Round_Key_End;
        Add_Round_Key_End:
          Next_State = Done;

        Done:
          if(~Start_h)
            Next_State = Rest;
        default: ;
      endcase


      // Assign Control signals based on State
      case (State)
        Rest:
          loop_count_next = 4'd0;
          update_state = 1'b0; // just load state back into itself

        Key_Expansion_0:
          //Key_Expansion_0 signal values
          update_state = 1'b1; // load state back into itself with signal below
          initialize = 1'b1; // bring initial encrypted message in
        // Add in rest of Key Expansion states
        Add_Round_Key_Init:
          out_key = KeySchedule [1407:1280]; // 1) [1407:1376], 2) [1375:1344], 3) [1343:1312], 4) [1311:1280] <-- 4 32bit keys
          OUTPUT_SEL = 2'b00;
        Inv_Shift_Rows_Loop:
          OUTPUT_SEL = 2'b01;
        Inv_Sub_Bytes_Loop:
          OUTPUT_SEL = 2'b10;
        Add_Round_Key_Loop:
          OUTPUT_SEL = 2'b00;
          out_key = KeySchedule [(1407 - (128 * (loop_count+1))):((1280 - (128 * (loop_count+1)))]; // loop_count correct?
        Inv_Mix_Columns_Loop_0:
          WORD_SEL = 2'b00;
          OUTPUT_SEL = 2'b11;
        Inv_Mix_Columns_Loop_1:
          WORD_SEL = 2'b01;
          OUTPUT_SEL = 2'b11;
        Inv_Mix_Columns_Loop_2:
          WORD_SEL = 2'b10;
          OUTPUT_SEL = 2'b11;
        Inv_Mix_Columns_Loop_3:
          WORD_SEL = 2'b11;
          OUTPUT_SEL = 2'b11;
          if(loop_count >= 4'b1000) // check if it the last loop
            loop_count_next = 4'b0000;
          else
            loop_count_next = loop_count + 1;
        Inv_Shift_Rows_End:
          OUTPUT_SEL = 2'b01;
        Inv_Sub_Bytes_End:
          OUTPUT_SEL = 2'b10;
        Add_Round_Key_End:
          OUTPUT_SEL = 2'b00;
          out_key = KeySchedule [127:0]; // last 128-bits are final key

        Done:
          loop_count_next = 4'd0;
          update_state = 1'b0; // just load state back into itself
        default: ;

      endcase
    end


endmodule // StateDriver
