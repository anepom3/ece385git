// This file will be for the GatePC, GateMAR, GateMDR, and GateALU tristate
// buffers. (It will actually just be a 5-to-1 MUX, 5th being 16'hxxxx)

module internal_tristate (input logic [15:0] GatePC,
                                             GateMAR,
                                             GateMDR,
                                             GateALU,
                          input logic [3:0] Select,
                          output logic [15:0] Gate_OUT
);

    always_comb begin
          Gate_OUT = 4'bxxxx;
          case(Select)
              4'b0001 : Gate_OUT = GatePC;
              4'b0010 : Gate_OUT = GateMAR;
              4'b0100 : Gate_OUT = GateMDR;
              4'b1000 : Gate_OUT = GateALU;
              default : Gate_OUT = 4'0000;
          endcase
    end

endmodule
