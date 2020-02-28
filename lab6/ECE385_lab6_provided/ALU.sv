// This file is for the ALU module.
module ALU (input logic [15:0] A, B
            input logic [1:0] ALUK

            output logic [15:0] DOUT);
  always_comb begin
    case(ALUK)
      2'b00 : DOUT = A + B;
      2'b01 : DOUT = A & B;
      2'b10 : DOUT = ~A;
      2'b11 : DOUT = A;
  end
endmodule
