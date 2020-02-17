module adder_9_bit
(
  input   logic[7:0]     S,
  input   logic[7:0]     A,
  input	  logic				   S_9th,
  input	  logic				   A_9th,
  input	  logic				   select_op,
  input   logic          M,

  output  logic[7:0]     Final_Sum,
  output	logic				   Final_Sum_9th,
  output  logic          COUT
);

    /*
     * This implements the 9-bit adder using a two, 4-bit Carry Ripple Adders, and one
     * Full Adder for the 9th bit.
     * This implementation is completly combinational (it doesn't use always_ff or always_latch).
     */
		logic [7:0] S_comb;
		logic S_9th_comb;
		logic cin;
    logic [7:0] Sum;
    logic Sum_9th;
    logic cout;

		logic C0, C1;

    // Build XOR (^) network to conditionally flip S input and add 1 via the
    // carry in.
		always_comb begin
			S_comb[0] = S[0] ^ select_op;
			S_comb[1] = S[1] ^ select_op;
			S_comb[2] = S[2] ^ select_op;
			S_comb[3] = S[3] ^ select_op;
			S_comb[4] = S[4] ^ select_op;
			S_comb[5] = S[5] ^ select_op;
			S_comb[6] = S[6] ^ select_op;
			S_comb[7] = S[7] ^ select_op;

			S_9th_comb = S_9th ^ select_op;

			cin = 1'b0 ^ select_op;

      // Building logic to by pass adders if M is 0, i.e. LSB of B is 0
      // so don't add.
      if(M)
        begin
			 COUT = cout;
          Final_Sum = Sum;
          Final_Sum_9th = Sum_9th;
			 if(select_op)
				Final_Sum_9th = ~S_9th;
          
        end
      else
        begin
          Final_Sum = A[7:0];
          Final_Sum_9th = A_9th;
			 COUT = 0;
        end
		end

    // Instantiating the 4-bit ripple adders and a one final full adder for
    // the 9th bit.
		four_bit_ra FRA0(.x(S_comb[3 : 0]), .y(A[3 : 0]), .cin(cin), .s(Sum[3 : 0]), .cout(C0));
		four_bit_ra FRA1(.x(S_comb[7 : 4]), .y(A[7 : 4]), .cin(C0), .s(Sum[7 : 4]), .cout(C1));
		full_adder FA9(.x(S_9th_comb), .y(A_9th), .cin(C1), .s(Sum_9th), .cout(cout));

endmodule




module four_bit_ra(
						input [3:0] x,
						input [3:0] y,
						input cin,
						output logic [3:0] s,
						output logic cout
						);
	logic c0, c1, c2;
	full_adder fa0(.x(x[0]), .y(y[0]), .cin(cin), .s(s[0]), .cout(c0));
	full_adder fa1(.x(x[1]), .y(y[1]), .cin(c0 ), .s(s[1]), .cout(c1));
	full_adder fa2(.x(x[2]), .y(y[2]), .cin(c1 ), .s(s[2]), .cout(c2));
	full_adder fa3(.x(x[3]), .y(y[3]), .cin(c2 ), .s(s[3]), .cout(cout));



endmodule

module full_adder(
						input x,
						input y,
						input cin,
						output logic s,
						output logic cout
						);
	assign s    = x^y^cin;
	assign cout = (x&y) | (y&cin) | (cin&x);

endmodule
