// This is the file for the ADDR2MUX!
// Inputs: 16-bit PC, 16-bit BaseR, Select Bit
// Outputs: 00 - 16'h0000, 01 - offset6, 10 - PCoffset9, 11 - PCoffset11
module ADDR2MUX (input logic [15:0] offset6, PCoffset9, PCoffset11,

                 input logic [1:0] Select, // ADDR2MUX control signal
                 output logic [15:0] Gate_OUT // To ADDR
);

    always_comb begin
          Gate_OUT = 16'hxxxx;
          case(Select) // Check to make sure selction is correct.
              2'b00 : Gate_OUT = 16'h0000;
              2'b01 : Gate_OUT = offset6;
              2'b10 : Gate_OUT = PCoffset9;
              2'b11 : Gate_OUT = PCoffset11;

              default : Gate_OUT = 16'hxxxx;
          endcase
    end

endmodule
