module BEN_LOGIC (input logic [15:0] DIN, // From Bus
                  input logic [2:0] IR_Slice
                  input logic LD_CC
                  input logic LD_BEN

                  output BEN_OUT
                  );
    LOGIC0 logic0_inst();
    NZP NZP_inst();
    LOGIC1 logic1_inst();
    BEN BEN_inst();

endmodule

module LOGIC0(input logic [15:0] DIN,
              output logic [2:0] DOUT
              );
    logic DIN_comb;
    always_comb begin
      if(DIN[15] == 1) begin
        DIN_comb = 
      end
    end
endmodule

module LOGIC1(input logic [2:0] DIN,
              input logic [2:0] IR_Slice
              output logic DOUT
             );

   always_comb begin
     DOUT = DIN & IR_Slice;
   end
 endmodule
