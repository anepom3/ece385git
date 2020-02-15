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


     /* Declare Internal Wires */
     logic [6:0] Ahex0_comb;
     logic [6:0] Ahex1_comb;
     logic [6:0] Bhex0_comb;
     logic [6:0] Bhex1_comb;
     logic [7:0] Aval_comb;
     logic [7:0] Bval_comb;
     logic X; //Sign extrension
     logic M; //Current bit of multiplicand (from B, goes into logic of adder)


     /* Always_init stuff here??? */


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


endmodule
