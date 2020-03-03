module BEN_LOGIC (input logic [15:0] DIN, // From Bus
                  input logic [2:0] IR_Slice,
                  input logic LD_CC,
                  input logic LD_BEN,
                  input logic Clk,
                  input logic Reset,

                  output BEN_OUT
                  );

    // Internal wires
    logic [2:0] logic2NZP_comb;
    logic [2:0] NZP2logic_comb;
    logic logic2BEN_comb;

    // Module instantiation.
    LOGIC0 logic0_inst(.DIN, .DOUT(logic2NZP_comb));
    NZP NZP_inst(.Clk, .LD_CC, .Reset, .DIN(logic2NZP_comb),
                 .DOUT(NZP2logic_comb));
    LOGIC1 logic1_inst(.DIN(NZP2logic_comb), .IR_Slice,
                       .DOUT(logic2BEN_comb));
    BEN BEN_inst(.Clk, .LD_BEN, .Reset,
                 .DIN(logic2BEN_comb), .DOUT(BEN_OUT));

endmodule

module LOGIC0(input logic [15:0] DIN,
              output logic [2:0] DOUT
              );
    logic [2:0] DIN_comb;
    always_comb begin
		
		DOUT = DIN_comb;
      
		if(DIN[15] == 1'b1) begin
        DIN_comb = 3'b100;
      end
      else if (DIN == 16'h0000) begin
        DIN_comb = 3'b010;
      end
      else if (DIN != 16'h0000 && DIN[15] == 1'b0) begin
        DIN_comb = 3'b001;
      end
      else begin
        DIN_comb = 3'bxxx;
		end
    end
endmodule

module LOGIC1(input logic [2:0] DIN,
              input logic [2:0] IR_Slice,
              output logic [2:0] DOUT
             );

   always_comb begin
     DOUT = DIN & IR_Slice;
   end
 endmodule
