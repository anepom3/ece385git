// This is the file for the SR1MUX!
// Inputs: IR[8:6], IR[11:9] Select Bit
// Outputs: 0 - IR[8:6], 1 - IR[11:9]
module SR1MUX (input logic [2:0] IR_Slice0, IR_Slice1

                 input logic Select, // ADDR2MUX control signal
                 output logic [2:0] Gate_OUT // To REGFILE
);

    always_comb begin
          Gate_OUT = 3'bxxx; // Check if we can do this with 'x' - is 'x' a
                             // nibble only (i.e. 4-bits)?
          case(Select) // Check to make sure selction is correct.
              1'b0 : Gate_OUT = IR_Slice0;
              1'b1 : Gate_OUT = IR_Slice1;

              default : Gate_OUT = 3'bxxx;
          endcase
    end

endmodule
