// This is just a 32-bit register.
module reg #(N=32) (// Inputs
                   input logic CLK, LD, RESET,
                   input logic [N-1:0] DIN,
                   // Outputs
                   output logic [N-1:0] DOUT
                  );

always_ff @ (posedge Clk ) begin
  if(Reset)
    DOUT <= 16'h0000;
  else if (LD)
    DOUT <= DIN;
end

endmodule
