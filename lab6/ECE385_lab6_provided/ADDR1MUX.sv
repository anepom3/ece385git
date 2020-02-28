// This is the file for the ADDR1MUX!
// Inputs: 16-bit PC, 16-bit BaseR, Select Bit
// Outputs: if Select = 0, then PC, else BaseR
module ADDR1MUX (input logic [15:0] PC,
                                    BaseR,

                 input logic [3:0] Select, // ADDR1MUX control signal
                 output logic [15:0] Gate_OUT // To ADDR
);

    always_comb begin
          Gate_OUT = 16'hxxxx;
          case(Select)
              1'b0 : Gate_OUT = PC;
              1'b1 : Gate_OUT = BaseR;
              default : Gate_OUT = 16'hxxxx;
          endcase
    end

endmodule
