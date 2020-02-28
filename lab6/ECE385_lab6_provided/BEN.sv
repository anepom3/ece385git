// This file is for the BEN register!
module BEN (// Inputs
                   input logic Clk, LD_BEN, Reset,
                   input logic DIN,
                   // Outputs
                   output logic DOUT
                  );

always_ff @ (posedge Clk ) begin
  if(Reset)
    DOUT <= 3'b000;
  else if (LD_BEN)
    DOUT <= DIN;
end

endmodule
