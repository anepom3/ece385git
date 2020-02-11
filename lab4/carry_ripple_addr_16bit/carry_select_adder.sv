module carry_select_adder
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     Sum,
    output  logic           CO
);

    /* TODO
     *
     * Insert code here to implement a carry select.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */
	  logic c4, c8, c12;
	  sub_four_bit_ra  init_FRA(.x(A[3 : 0]), .y(B[3 : 0]), .cin(0), .s(Sum[3 : 0]), .cout(c4));
	  four_bit_csa csa0_4bit(.x(A[7 : 4]), .y(B[7 : 4]), .cin(c4), .s(Sum[7 : 4]), .cout(c8));
	  four_bit_csa csa1_4bit(.x(A[11 : 8]), .y(B[11 : 8]), .cin(c8), .s(Sum[11 : 8]), .cout(c12));
	  four_bit_csa csa2_4bit(.x(A[15 : 12]), .y(B[15 : 12]), .cin(c12), .s(Sum[15 : 12]), .cout(CO));
	  
     
endmodule

module four_bit_csa(
							input [3:0] x,
							input [3:0] y,
							input cin,
							output logic [3:0] s,
							output cout
						 );
	logic cout0, cout1; 
	logic [3:0] s0;
	logic [3:0]	s1;
		
	sub_four_bit_ra addr_cin0 (.x(x), .y(y), .cin(0), .s(s0), .cout(cout0));
	sub_four_bit_ra addr_cin1 (.x(x), .y(y), .cin(1), .s(s1), .cout(cout1));
	
	four_bit_mux csa_mux(.sel(cin), .sum_cin0(s0), .sum_cin1(s1), .sum(s));
	
	assign cout = (cout1 & cin) | cout0;

endmodule

module sub_four_bit_ra(
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

//module full_adder(
//						input x,
//						input y,
//						input cin,
//						output logic s,
//						output logic cout
//						);
//	assign s    = x^y^cin;
//	assign cout = (x&y) | (y&cin) | (cin&x);
//	
//endmodule

module four_bit_mux(
							input sel,
							input [3:0] sum_cin0,
							input [3:0] sum_cin1,
							output logic [3:0] sum
						 );
	always_comb
	begin
		case (sel)
			1'b0 : sum = sum_cin0;
			1'b1 : sum = sum_cin1;
		endcase
	end
endmodule
