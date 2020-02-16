module adder_9_bit
(
    input   logic[7:0]     A,
    input   logic[7:0]     B,
	 input	logic				A_9th
	 input	logic				B_9th
	 input	logic				select_op
    output  logic[7:0]     Sum,
	 output	logic				Sum_9th
	 output	logic				B_Sum
    output  logic          cout
);

    /* 
     * This implements the 9-bit adder using a two, 4-bit Carry Ripple Adders, and one
     * Full Adder for the 9th bit.
     * This implementation is completly combinational (it doesn't use always_ff or always_latch).
     */
		logic [7:0] A';
		logic [7:0] B';
		logic A_9th';
		logic B_9th';
		logic cin;
		
		logic C0, C1;
		
		always_comb begin
			A'[0] = A[0] XOR select_op;
			A'[1] = A[1] XOR select_op;
			A'[2] = A[2] XOR select_op;
			A'[3] = A[3] XOR select_op;
			A'[4] = A[4] XOR select_op;
			A'[5] = A[5] XOR select_op;
			A'[6] = A[6] XOR select_op;
			A'[7] = A[7] XOR select_op;
			
			A_9th' = A_9th XOR select_op;

			B'[0] = B[0] XOR select_op;
			B'[1] = B[1] XOR select_op;
			B'[2] = B[2] XOR select_op;
			B'[3] = B[3] XOR select_op;
			B'[4] = B[4] XOR select_op;
			B'[5] = B[5] XOR select_op;
			B'[6] = B[6] XOR select_op;
			B'[7] = B[7] XOR select_op;
			B_9th' = B_9th XOR select_op;
			
			cin = 1b'0 XOR select_op;
		end
		
		
		four_bit_ra FRA0(.x(A'[3 : 0]), .y(B'[3 : 0]), .cin(cin), .s(Sum[3 : 0]), .cout(C0));
		four_bit_ra FRA1(.x(A'[7 : 4]), .y(B'[7 : 4]), .cin(C0), .s(Sum[7 : 4]), .cout(C1));
		full_adder(.x(A_9th'), .y(B_9th'), .cin(C1), .s(Sum_9th), .cout(cout));
	
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
