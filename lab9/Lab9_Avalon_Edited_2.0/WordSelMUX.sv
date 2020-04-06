// WordSelMUX

module WordSelMUX (
                   input logic [127:0] state,
                   input logic [1:0] WORD_SEL,
                   output logic [31:0] out_word
                  );

  always_comb
  begin
      case (WORD_SEL)
        2'b00: out_word = state [127:96]; // These might be backwards!
        2'b01: out_word = state [95:64];
        2'b10: out_word = state [63:32];
        2'b11: out_word = state [31:0];
        default: ;
      endcase
  end

endmodule // WordSelMUX
