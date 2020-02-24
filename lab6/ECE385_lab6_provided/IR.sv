// We'll create the IR file here!
// This is just a 16-bit register.
module IR #(N=16) (// Inputs
                   input logic Clk, LD_IR, Reset,
                   input logic [N-1:0] DIN,
                   // Outputs
                   output logic [N-1:0] DOUT
                  );

always_ff @ (posedge Clk ) begin
  if(Reset)
    DOUT <= 16'h0000;
  else if (LD_IR)
    DOUT <= DIN;
end

endmodule
