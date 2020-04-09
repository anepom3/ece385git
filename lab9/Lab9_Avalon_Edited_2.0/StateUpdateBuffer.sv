// StateUpdateBuffer

module StateUpdateBuffer (
                          input logic Clk,
                            update_state,
                            initialize,
                          input logic [127:0] initial_state,
                          input logic [31:0] Inv_Mix_Columns_Word_Val,
                          input logic [127:0] Add_Round_Key_Val,
                          input logic [127:0] Inv_Shift_Rows_Val,
                          input logic [127:0] Inv_Sub_Bytes_Val,
                          input logic [127:0] state_in,
                          input logic [1:0] WORD_SEL,
                          input logic [1:0] OUTPUT_SEL,
                          output logic [127:0] state_out
                          );



always_ff @ (posedge Clk)
begin
    if(update_state) // Update word from operation into state
      begin
          if(initialize)
            state_out = initial_state; // Takes intial encrypted message
          else begin
            case (OUTPUT_SEL) // Select which operation is operating
                2'b00: state_out <= Add_Round_Key_Val;
                2'b01: state_out <= Inv_Shift_Rows_Val;
                2'b10: state_out <= Inv_Sub_Bytes_Val;
                2'b11: // set state_out based on 4 words of Inv_Mix_Columns
                    case (WORD_SEL)
                        2'b00: state_out <= {Inv_Mix_Columns_Word_Val, state_in[95:0]}; // [127:96] [95:64] [63:32] [31:0]
                        2'b01: state_out <= {state_in [127:96], Inv_Mix_Columns_Word_Val, state_in[63:0]};
                        2'b10: state_out <= {state_in [127:64], Inv_Mix_Columns_Word_Val, state_in[31:0]};
                        2'b11: state_out <= {state_in [127:32], Inv_Mix_Columns_Word_Val};
                        default: ;
                    endcase
                default: ;
            endcase
        end
    end
  else
    state_out = state_in; // Do not update state
end

endmodule // StateUpdateBuffer
