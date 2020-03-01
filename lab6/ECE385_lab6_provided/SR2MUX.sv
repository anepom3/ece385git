// This is the file for the SR2MUX!
// Inputs: 16-bit SR2_OUT, 16-bit SEXT[imm5], Select Bit
// Outputs: 0 - SR2_OUT, 1 - SEXT[imm5]
module SR2MUX (input logic [15:0] SR2_OUT, imm5

                 input logic Select, // ADDR2MUX control signal
                 output logic [15:0] Gate_OUT // To ADDR
);

    always_comb begin
          Gate_OUT = 16'hxxxx;
          case(Select) // Check to make sure selction is correct.
              1'b0 : Gate_OUT = SR2_OUT;
              1'b1 : Gate_OUT = imm5;

              default : Gate_OUT = 16'hxxxx;
          endcase
    end

endmodule
