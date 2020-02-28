// This file is for the NZP register!
module NZP (// Inputs
                   input logic Clk, LD_CC, Reset,
                   input logic [2:0] DIN,
                   // Outputs
                   output logic [2:0] DOUT
                  );

always_ff @ (posedge Clk ) begin
  if(Reset)
    DOUT <= 3'b000;
  else if (LD_CC)
    DOUT <= DIN;
end

endmodule
