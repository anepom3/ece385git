module multiplier8x8
(
     input logic Clk, //Internal
                 Reset, //Push button 0
                 Run, //Push button 1
                 ClearA_LoadB, //Push Button 2
     input  logic [7:0] S, //From switches
     output logic [7:0] Aval, //Values of Registers
                        Bval,
     output logic [6:0] AHexU, //Hex values
                        AHexL,
                        BHexU,
                        BHexL,
     output logic X
);


     /* Declare Internal Registers */
     logic [7:0] A;
     logic [7:0] B;
     logic [7:0] S_hold;
     logic [7:0] A_In; //Data to put into SR A


     /* Declare Internal Wires */
     logic [6:0] Ahex0_comb;
     logic [6:0] Ahex1_comb;
     logic [6:0] Bhex0_comb;
     logic [6:0] Bhex1_comb;
     logic [7:0] Aval_comb;
     logic [7:0] Bval_comb;
     logic X; //Sign extrension
     logic M; //Current bit of multiplicand (from B, goes into logic of adder)
     logic Ld_A; //Load new data from S into A
     logic Ld_B; //Load new data from S into B
     logic Shift; //Shift the SRs
     logic Clear_A; //Clear A to begin multiplication operation
     logic B_Shift_In; //Shift bit from A[0] to B[7]


     /* Always_init stuff here??? */

     /* Instantiation of modules */
     reg_8   reg_8_A (
               .Clk,
               .Reset,
               .Clear(Clear_A),
               .Shift_In(X),
               .Load(Ld_A),
               .Shift_En(Shift), // double-check value name from output of control
               .D(A_In),//Figure out where to get this (A_In = Sum Output)
               .Shift_Out(B_Shift_In),
               .Data_Out(A)
     );

     reg_8   reg_8_B ( //Finish this
              .Clk,
              .Reset,
              .Clear(0);
              .Shift_In(B_Shift_In),
              .Load(),
              .Shift_En(Shift),
              .D(S),
              .Shift_Out(M),
              .Data_Out(B)
     );

     control   control_unit (

     );

     adder_9_bit adder_unit (
                    .A(S),
                    .B(A),
                    .A_9th().
                    .B_9th(),
                    .select_op(),
                    .Sum(),
                    .Sum_9th(),
                    .cout()
     );


     /* Behavior of Multiplier */
     always_ff @(posedge Clk) begin

          if(!Reset) begin
               /* Do the reset */
               A <= 8'h00;
               B <= 8'h00;
          end

          /* Do    */
          /* Some  */
          /* More  */
          /* Stuff */
          /* In    */
          /* Here  */

     end




     /* Hex Drivers */
     HexDriver Ahex0_inst
     (
         .In0(A[3:0]),   // This connects the 4 least significant bits of
         .Out0(Ahex0_comb) // register A to the input of a hex driver named Ahex0_inst
     );


     HexDriver Ahex1_inst
     (
         .In0(A[7:4]),
         .Out0(Ahex1_comb)
     );


     HexDriver Bhex0_inst
     (
         .In0(B[3:0]),
         .Out0(Bhex0_comb)
     );


     HexDriver Bhex1_inst
     (
         .In0(B[7:4]),
         .Out0(Bhex1_comb)
     );

	  //Input synchronizers required for asynchronous inputs (in this case, from the switches)
	  //These are array module instantiations
	  //Note: S stands for SYNCHRONIZED, H stands for active HIGH
	  //Note: We can invert the levels inside the port assignments
	  sync button_sync[3:0] (Clk, {~Reset, ~LoadA, ~LoadB, ~Execute}, {Reset_SH, LoadA_SH, LoadB_SH, Execute_SH});
	  sync Din_sync[7:0] (Clk, Din, Din_S);
	  sync F_sync[2:0] (Clk, F, F_S);
	  sync R_sync[1:0] (Clk, R, R_S);

endmodule
