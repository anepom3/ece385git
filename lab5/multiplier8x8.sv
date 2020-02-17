// 8bit x 8bit Multiplier Top Level module
// Anthony Nepomuceno and Tyler Mongoven
// ECE 385 Spring 2020
// Lab 5

module multiplier8x8 (input  logic Clk,          //Internal
                                   Reset,        //Push button 0
                                   Run,          //Push button 3
                                   ClearA_LoadB, //Push Button 2
                      input  logic [7:0] S,      //From switches [0:7]

                      // Do we need the Aval and Bval outputs?
                      output logic [7:0] Aval,   //Values of Registers
                                   Bval,
                      // These will output to the Hex Value LED displays
                      output logic [6:0] AHexU,  //Hex values
                                   AHexL,
                                   BHexU,
                                   BHexL,
                       // This will be displayed on the LED G8
                      output logic X_reg);          // Value of sign extension REG X

      // Why do we need these registers?
     /* Declare Internal Registers */
     logic [7:0] A;
     logic [7:0] B;
     logic [7:0] S_hold;
     logic [7:0] A_In; //Data to put into SR A
	  

     /* Declare Internal Wires */
     logic [6:0] AHex0_comb;
     logic [6:0] AHex1_comb;
     logic [6:0] BHex0_comb;
     logic [6:0] BHex1_comb;
	  logic ResetH;
	  logic ClearA_LoadBH;
	  logic RunH;
	  
     logic [7:0] Aval_comb;
     logic [7:0] Bval_comb;


     logic X_reg_comb; //Sign extrension
	  logic X_reg_2_A;

     logic B_Shift_In; //Shift bit from A[0] to B[7]
     logic M; //Current bit of multiplicand (from B, goes into logic of adder)
     logic Shift; //Shift the SRs
     logic select_op; //Wire for Add - 0 or Sub - 1
     logic Ld_A; //Load new data from S into A
     logic Ld_B; //Load new data from S into B
     logic Clear_A; //Clear A to begin multiplication operation


     /* Always_init stuff here??? */

     /* Behavior of Multiplier */
    

     /* Decoders for HEX drivers and output registers
     * Note that the hex drivers are calculated one cycle after Sum so
     * that they have minimal interfere with timing (fmax) analysis.
     * The human eye can't see this one-cycle latency so it's OK. */
    always_ff @(posedge Clk) begin
        // These connect our hex modules to the HEX LED Display outputs.
        AHexL <= AHex0_comb;
        AHexU <= AHex1_comb;
        BHexL <= BHex0_comb;
        BHexU <= BHex1_comb;
		  X_reg <= X_reg_2_A;

    end
	 
	 always_comb begin
		Aval_comb = A;
		Bval_comb = B;
		Aval = Aval_comb;
		Bval = Bval_comb;
		
	 end

    /* Instantiation of modules */
    reg_8   reg_8_A ( // Inputs
                      .Clk(Clk), .Reset(ResetH), .Clear(Clear_A),
                      .Shift_In(X_reg_2_A), .Load(Ld_A), .Shift_En(Shift),
                      .D(A_In),

                      // Outputs
                      .Shift_Out(B_Shift_In), .Data_Out(A));

    reg_8   reg_8_B ( // Inputs
                      .Clk(Clk), .Reset(ResetH), .Clear(1'b0),
                      .Shift_In(B_Shift_In), .Load(Ld_B), .Shift_En(Shift),
                      .D(S_hold),

                      // Outputs
                      .Shift_Out(M),
                      .Data_Out(B)
    );
	 
	 reg_1 reg_1_X (.Clk(Clk),  .Reset(ResetH), .Clear(Clear_A), .D(X_reg_comb), .Data_Out(X_reg_2_A));

    adder_9_bit adder_unit ( // Inputs
                            .S(S_hold), .A(A), .S_9th(S_hold[7]), .A_9th(A[7]),
                            .select_op(select_op),.M(M),

                            //  Outputs
                            .Final_Sum(A_In), .Final_Sum_9th(X_reg_comb), .COUT(x)
    );

    control   control_unit ( // Inputs
                            .Clk(Clk), .Reset(ResetH),
                            .ClearA_LoadB(ClearA_LoadBH), .Run(RunH), .M(M),

                            //  Outputs
                            .Shift_En(Shift), .select_op(select_op),
                            .Ld_A(Ld_A), .Ld_B(Ld_B), .Clear_A(Clear_A)

    );

     /* Hex Drivers */
     HexDriver Ahex0_inst
     (
         .In0(A[3:0]),   // This connects the 4 least significant bits of
         .Out0(AHex0_comb) // register A to the input of a hex driver named Ahex0_inst
     );


     HexDriver Ahex1_inst
     (
         .In0(A[7:4]),
         .Out0(AHex1_comb)
     );


     HexDriver Bhex0_inst
     (
         .In0(B[3:0]),
         .Out0(BHex0_comb)
     );


     HexDriver Bhex1_inst
     (
         .In0(B[7:4]),
         .Out0(BHex1_comb)
     );

	  //Input synchronizers required for asynchronous inputs (in this case, from the switches)
	  //These are array module instantiations
	  //Note: S stands for SYNCHRONIZED, H stands for active HIGH
	  //Note: We can invert the levels inside the port assignments
	  sync button_sync[2:0] (Clk, {~Reset, ~ClearA_LoadB, ~Run}, {ResetH, ClearA_LoadBH, RunH});
	  sync S_sync[7:0] (Clk, S, S_hold);

endmodule
