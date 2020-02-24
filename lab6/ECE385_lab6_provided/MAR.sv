// We'll create the MAR module here.
// This is just a 16-bit register.
module MAR #(N=16) (// Inputs
                   input logic Clk, LD_MAR, Reset,
                   input logic [N-1:0] DIN,
                   // Outputs
                   output logic [N-1:0] DOUT
                  );

always_ff @ (posedge Clk ) begin
  if(Reset)
    DOUT <= 16'h0000;
  else if (LD_MAR)
    DOUT <= DIN;
end

endmodule
