// We'll create the MDR module here!
// This is just a 16-bit register.
module MDR #(N=16) (// Inputs
                   input logic Clk, LD_MDR, Reset,
                   input logic [N-1:0] DIN,
                   // Outputs
                   output logic [N-1:0] DOUT
                  );

always_ff @ (posedge Clk ) begin
  if(Reset)
    DOUT <= 16'h0000;
  else if (LD_MDR)
    DOUT <= DIN;
end

endmodule
