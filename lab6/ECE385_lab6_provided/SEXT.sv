modeule sign_ext (
                  input logic [4:0] In_5,
                  input logic [7:0] In_8,
                  input logic [9:0] In_10,

                  output logic [15:0] S_ext5,
                                      S_ext8,
                                      S_ext10
                  );

always_comb begin
    S_ext5 = In_5[4] ? {1,1,1,1,1,1,1,1,1,1,1,In_5[4:0]} : {0,0,0,0,0,0,0,0,0,0,0,In_5[4:0]};
    S_ext8 = In_8[7] ? {1,1,1,1,1,1,1,1,In_8[7:0]} : {0,0,0,0,0,0,0,0,In_8[7:0]};
    S_ext10 = In_10[9] ? {1,1,1,1,1,1,In_10[9:0]} : {0,0,0,0,0,0,In_10[9:0]};
end

endmodule
