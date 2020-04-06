// This is just a 32-bit register.
module REG #(N=32) (// Inputs
                   input logic CLK, LD, RESET,
                   input logic [N-1:0] DIN,
                   // Outputs
                   output logic [N-1:0] DOUT
                  );

always_ff @ (posedge CLK ) begin
  if(RESET)
    DOUT <= N'h0000;
  else if (LD)
    DOUT <= DIN;
end

endmodule
