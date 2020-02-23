// We'll create the program counter module here!
module PC #(N=16) (// Inputs
                   input logic Clk, LD_PC, Reset,
                   input logic [N-1:0] DIN,
                   // Outputs
                   output logic [N-1:0] DOUT
                  );

always_ff @ (posedge Clk ) begin
  if(Reset)
    DOUT <= 16'h0000;
  else if (LD_PC)
    DOUT <= DIN;
end

endmodule
