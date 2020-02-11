module cla_4bit
(
    input   logic[3:0]     A,
    input   logic[3:0]     B,
	 input   logic          Cin,
    output  logic[3:0]     Sum,
//    output  logic          CO,
	 output  logic          Pg,
	 output  logic          Gg
);

/* Local Variables */
logic[3:0]     Sum_temp;
logic[3:0]     P_temp;
logic[3:0]     G_temp;
logic[3:0]     Carry;


/* Internal Logic */
assign G_temp = (A & B);
assign P_temp = (A ^ B);

assign Carry[0] = Cin;

assign Carry[1] = (Carry[0] & P_temp[0]) | 
                  (G_temp[0]);
						
assign Carry[2] = (Carry[0] & P_temp[0] & P_temp[1]) | 
                  (G_temp[0] & P_temp[1]) | 
						(G_temp[1]);
						
assign Carry[3] = (Carry[0] & P_temp[0] & P_temp[1] & P_temp[2]) | 
                  (G_temp[0] & P_temp[1] & P_temp[2]) | 
						(G_temp[1] & P_temp[2]) | 
						(G_temp[2]);

						
//assign CO =       (Carry[0] & P_temp[0] & P_temp[1] & P_temp[2] & P_temp[3]) | 
//                  (G_temp[0] & P_temp[1] & P_temp[2] & P_temp[3]) | 
//				      (G_temp[1] & P_temp[2] & p_temp[3]) | 
//				      (G_temp[2] & P_temp[3]) | 
//				      (G_temp[3]));

assign Sum_temp = (A ^ B ^ Carry);


assign Sum = Sum_temp;
assign Pg = (P_temp[3] & Carry[3]);
assign Gg = G_temp[3];


endmodule
