// TODO we'l make a datapath module here!
// This will be used to connect all the modules together.
// Week 1
// PC (Program Counter) Package: PC, PCMUX, '+1', (GatePC)
// MDR Package: MDR, (GateMDR)
// MAR Package: MAR, (GateMAR)
// IR Package: IR
// Internal Tri-state MUX Package: GateMDR, GateMAR, GatePC (Gate ALU for Week 2)
module datapath #(N=16)(// Inputs
                        input logic Clk, Reset,
                        input [N-1:0] DIN,
                        // Outputs
                        output logic [N-1:0] DOUT
                        );
always_ff @ (posedge Clk) begin
  if(Reset)
    DOUT <= 16'h0000;
  else
    DOUT <= DIN;
end

endmodule


endmodule
