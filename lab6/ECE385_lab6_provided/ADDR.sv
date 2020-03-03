// This file is for the ADDR module!
module ADDR (input logic [15:0] ADDR1MUX_IN, ADDR2MUX_IN,
             output logic [15:0] ADDR_OUT);

             // carry_select_adder carry_select_adder_inst(.A(ADDR1MUX_IN), .B(ADDR2MUX_IN), .Sum(ADDR_OUT), .CO(1'b0));
             // or just
             always_comb begin
               ADDR_OUT = ADDR1MUX_IN + ADDR2MUX_IN;
            end
endmodule
