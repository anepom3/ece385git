// This file will be for the GatePC, GateMAR, GateMDR, and GateALU tristate
// buffers. (It will actually just be a 5-to-1 MUX, 5th being 16'hxxxx)

module internal_tristate (input logic [15:0] GatePC_IN,
                                             GateMAR_IN,
                                             GateMDR_IN,
                                             GateALU_IN,
                          input logic [3:0] Select, // {GatePC, GateMAR, GateMDR, GateALU}
                          output logic [15:0] Gate_OUT
);

    always_comb begin
          Gate_OUT = 16'hxxxx;
          case(Select)
              4'b0001 : Gate_OUT = GateALU_IN;
              4'b0010 : Gate_OUT = GateMAR_IN;
              4'b0100 : Gate_OUT = GateMDR_IN;
              4'b1000 : Gate_OUT = GatePC_IN; 
              default : Gate_OUT = 16'hxxxx;
          endcase
    end

endmodule
