module PCMUX  (input logic [1:0] PC_MUX, // Select bit 00 - PC + 1, 01 - BUS, 10 - ADDER
               input logic [15:0] PC_PLUS, // Incremented PC (PC + 1)
               input logic [15:0] BUS, // From the BUS
               input logic [15:0] ADDER, // From the Address Adder

               output logic [15:0] PC_IN // Goes to the PC register
              );

              always_comb begin
                case(PC_MUX)
                  2'b00 : PC_IN = PC_PLUS;
                  2'b01 : PC_IN = BUS;
                  2'b10 : PC_IN = ADDER;
                  default: PC_IN = 16'hxxxx;
                endcase
              end
endmodule
