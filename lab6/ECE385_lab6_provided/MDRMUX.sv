module MDRMUX  (input logic MDR_MUX, // Select bit 0 - Data_to_CPU, 1 - BUS
               input logic [15:0] Data_to_CPU, // Output from Memory
               input logic [15:0] BUS, // From the BUS

               output logic [15:0] MDR_IN // Goes to the MDR register
              );

              always_comb begin
                case(MDR_MUX)
                  1'b0 : MDR_IN = Data_to_CPU;
                  1'b1 : MDR_IN = BUS;
                endcase
              end
endmodule
