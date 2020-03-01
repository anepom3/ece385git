// This is the file for the DRMUX!
// Inputs: IR[11:0], Select Bit
// Outputs: 0 - IR[11:9], 1 - 3'b111
module DRMUX (input logic [2:0] IR_Slice0,

                 input logic Select, // ADDR2MUX control signal
                 output logic [2:0] Gate_OUT // To REGFILE
);

    always_comb begin
          Gate_OUT = 3'bxxx; // Check if we can do this with 'x' - is 'x' a
                             // nibble only (i.e. 4-bits)?
          case(Select) // Check to make sure selction is correct.
              1'b0 : Gate_OUT = IR_Slice0;
              1'b1 : Gate_OUT = 3'b111;

              default : Gate_OUT = 3'bxxx;
          endcase
    end

endmodule
