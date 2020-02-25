// This file will be for the GatePC, GateMAR, GateMDR, and GateALU tristate
// buffers. (It will actually just be a 5-to-1 MUX, 5th being 16'hxxxx)

module internal_tristate (input logic [15:0] PC_BUS,
                                             MDR_BUS,
                                             MARMUX_BUS,
                                             ALU_BUS,
                          input logic [3:0] Select, // {GateALU, GateMARMUX, GateMDR, GatePC}
                          output logic [15:0] Gate_OUT
);

    always_comb begin
          Gate_OUT = 16'hxxxx;
          case(Select)
              4'b0001 : Gate_OUT = PC_BUS;
              4'b0010 : Gate_OUT = MDR_BUS;
              4'b0100 : Gate_OUT = MARMUX_BUS;
              4'b1000 : Gate_OUT = ALU_BUS;
              default : Gate_OUT = 16'hxxxx;
          endcase
    end

endmodule
