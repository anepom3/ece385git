// WordOutMUX

module WordOutMUX (
                   input logic [31:0] Add_Round_Key_in,
                   input logic [31:0] Inv_Shift_Rows_in,
                   input logic [31:0] Inv_Sub_Bytes_in,
                   input logic [31:0] Inv_Mix_Columns_in,
                   input logic [1:0] OUTPUT_SEL,
                   output logic [31:0] out_word
                  );

  always_comb
  begin
      case (OUTPUT_SEL)
        2'b00: out_word = Add_Round_Key_in;
        2'b01: out_word = Inv_Shift_Rows_in;
        2'b10: out_word = Inv_Sub_Bytes_in;
        2'b11: out_word = Inv_Mix_Columns_in;
        default: ;
      endcase
  end

endmodule // WordOutMUX
