module InvSubBytes_Statewise (input logic clk, input logic [127:0] data_in,
                              output logic [127:0] data_out);
  //  State Layout
  //| Word 0  | Word 1 | Word 2 | Word 3|
  // [127:120] [95:88]  [63:56]   [31:24]
  // [119:112] [87:80]  [55:48]   [23:16]
  // [111:104] [79:72]  [47:40]   [15: 8]
  // [103: 96] [71:64]  [39:32]   [ 7: 0]

  // Instantiating Parallel InvSubBytes modules
  InvSubBytes word_0_0 (.clk, .in(data_in[127:120]), .out(data_out[127:120]));
  InvSubBytes word_0_1 (.clk, .in(data_in[119:112]), .out(data_out[119:112]));
  InvSubBytes word_0_2 (.clk, .in(data_in[111:104]), .out(data_out[111:104]));
  InvSubBytes word_0_3 (.clk, .in(data_in[103: 96]), .out(data_out[103: 96]));

  InvSubBytes word_1_0 (.clk, .in(data_in[95:88]), .out(data_out[95:88]));
  InvSubBytes word_1_1 (.clk, .in(data_in[87:80]), .out(data_out[87:80]));
  InvSubBytes word_1_2 (.clk, .in(data_in[79:72]), .out(data_out[79:72]));
  InvSubBytes word_1_3 (.clk, .in(data_in[71:64]), .out(data_out[71:64]));

  InvSubBytes word_2_0 (.clk, .in(data_in[63:56]), .out(data_out[63:56]));
  InvSubBytes word_2_1 (.clk, .in(data_in[55:48]), .out(data_out[55:48]));
  InvSubBytes word_2_2 (.clk, .in(data_in[47:40]), .out(data_out[47:40]));
  InvSubBytes word_2_3 (.clk, .in(data_in[39:32]), .out(data_out[39:32]));

  InvSubBytes word_3_0 (.clk, .in(data_in[31:24]), .out(data_out[31:24]));
  InvSubBytes word_3_1 (.clk, .in(data_in[23:16]), .out(data_out[23:16]));
  InvSubBytes word_3_2 (.clk, .in(data_in[15: 8]), .out(data_out[15: 8]));
  InvSubBytes word_3_3 (.clk, .in(data_in[ 7: 0]), .out(data_out[ 7: 0]));

endmodule
