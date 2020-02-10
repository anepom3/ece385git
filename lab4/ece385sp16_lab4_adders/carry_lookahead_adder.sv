module carry_lookahead_adder
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     Sum,
    output  logic           CO
);

    /* TODO
     *
     * Insert code here to implement a CLA adder.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */
	  
	  /* Local Variables */
	  logic C4, C8, C12,
	        P0, P4, P8, P12,
			  G0, G4, G8, G12,
			  PG, GG;
	  
	  cla_4bit cla_4bit_0(.A(A[3:0]), .B(B[3:0]), .Cin(0), .Sum(Sum[3:0]), /*.CO(C0),*/ .Pg(P0), .Gg(G0));
	  cla_4bit cla_4bit_4(.A(A[7:4]), .B(B[7:4]), .Cin(C4), .Sum(Sum[7:4]), /*.CO(C8),*/ .Pg(P4), .Gg(G4));
	  cla_4bit cla_4bit_8(.A(A[11:8]), .B(B[11:8]), .Cin(C8), .Sum(Sum[11:8]), /*.CO(C12),*/ .Pg(P8), .Gg(G8));
	  cla_4bit cla_4bit_12(.A(A[15:12]), .B(B[15:12]), .Cin(C12), .Sum(Sum[15:12]), .Pg(P12), .Gg(G12));
	  cla_4bit cla_4bit_c(.A({P12,P8,P4,P0}), .B({G12,G8,G4,G0}), .Cin(0), .Sum({CO,C12,C8,C4}), .Pg(PG), .Gg(GG));
     
endmodule
