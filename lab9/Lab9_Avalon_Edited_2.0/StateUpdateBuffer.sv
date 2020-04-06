// StateUpdateBuffer

module StateUpdateBuffer (
                          input logic Clk,
                            update_state,
                          input logic [31:0] word_in,
                          input logic [127:0] state_in,
                          input logic [1:0] WORD_SEL,
                          output logic [127:0] state_out
                          );



always_ff @ (posedge Clk)
begin
    if(update_state) // Update word from operation into state
      begin
          case (WORD_SEL)
            2'b00: state_out = {word_in, state_in[95:0]};
            2'b01: state_out = {state_in [127:64], word_in, state_in[31:0]};
            2'b10: state_out = {state_in [127:96], word_in, state_in[63:0]};
            2'b11: state_out = {state_in [127:32], word_in};
            default: ;
          endcase
      end
    else
      state_out = state_in; // Do not update state
end

endmodule // StateUpdateBuffer
