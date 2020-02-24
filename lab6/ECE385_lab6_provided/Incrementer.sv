module Incrementer(input logic [15:0] DIN,
                   output logic [15:0] DOUT);
begin
  always_comb begin
    if(DIN == 16'hFFFF)
      DOUT = 16'h0000;
    else
      DOUT = DIN + 16'h0001;
  end
end
