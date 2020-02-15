module adder_9_bit
(
    input   logic[7:0]     A,
    input   logic[7:0]     B,
	 input	logic				A_9th
	 input	logic				B_9th
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
		logic C0, C1;
		
		four_bit_ra FRA0(.x(A[3 : 0]), .y(B[3 : 0]), .cin(0), .s(Sum[3 : 0]), .cout(C0));
		four_bit_ra FRA1(.x(A[7 : 4]), .y(B[7 : 4]), .cin(C0), .s(Sum[7 : 4]), .cout(C1));
		full_adder(.x(A_9th), .y(B_9th), .cin(C1), .s(Sum_9th), .cout(cout));
	
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
