module LED #(N=12) (// Inputs
                   input logic Clk, Reset, LD_LED,
                   input logic [N-1:0] DIN,
                   // Outputs
                   output logic [N-1:0] DOUT
                  );

always_ff @ (posedge Clk ) begin
  if(Reset)
    DOUT <= 12'h000;
  else if (LD_LED)
    DOUT <= DIN;
end

endmodule
