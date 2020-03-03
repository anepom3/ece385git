module sign_ext (
                  input logic [4:0] In_5,
                  input logic [5:0] In_6,
                  input logic [8:0] In_9,
                  input logic [10:0] In_11,

                  output logic [15:0] S_ext5,
                                      S_ext6,
                                      S_ext9,
                                      S_ext11
                  );

always_comb begin
    S_ext5 = In_5[4] ? {8'hFF, 3'b111, In_5[4:0]} : {8'h00, 3'b000, In_5[4:0]};
    S_ext6 = In_6[5] ? {8'hFF, 2'b11, In_6[5:0]} : {8'h00, 2'b00, In_6[5:0]};
    S_ext9 = In_9[8] ? {4'hF, 3'b111, In_9[8:0]} : {4'h0, 3'b000, In_9[8:0]};
    S_ext11 = In_11[10] ? {4'hF, 1'b1, In_11[10:0]} : {4'h0, 1'b0, In_11[10:0]};
end

endmodule
