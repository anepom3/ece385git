module control (input  logic Clk, Reset, ClearA_LoadB, Run, M,
                output logic Shift_En, select_op, Ld_A, Ld_B, Clear_A);

    // Declare signals curr_state, next_state of type enum
    // with enum values of A, B, ..., F as the state values
	 // Note that the length implies a max of 8 states, so you will need to bump this up for 8-bits
    enum logic [4:0] {A0, S0, A1, S1, A2, S2, A3, S3, A4, S4, A5, S5, A6, S6, A7, S7, Finish, Wait}   curr_state, next_state;

	//updates flip flop, current state is the only one
    always_ff @ (posedge Clk)
    begin
        if (Reset)
            curr_state <= Wait;
        else
            curr_state <= next_state;
    end

    // Assign outputs based on state
	always_comb
    begin

		    next_state  = curr_state;	//required because I haven't enumerated all possibilities below
        unique case (curr_state)

        A0     :    next_state = S0;
        S0     :    next_state = A1;
        A1     :    next_state = S1;
        S1     :    next_state = A2;
        A2     :    next_state = S2;
        S2     :    next_state = A3;
  		  A3     :    next_state = S3;
  		  S3     :    next_state = A4;
  		  A4     :    next_state = S4;
  		  S4     :    next_state = A5;
        A5     :    next_state = S5;
        S5     :    next_state = A6;
        A6     :    next_state = S6;
        S6     :    next_state = A7;
        A7     :    next_state = S7;
        S7     :    next_state = Finish;
  		  Finish :    if(~Run)
                      next_state = Wait; //only if Run button is released
  		  Wait   :    if(Run)
                      next_state = A0; //only if Run button is pressed again

        endcase

		  // Assign outputs based on ‘state’
        case (curr_state)

		  /* Fill case statements with vals */
		  A0                          	:
            begin
              Shift_En  = 1'b0;
              select_op = 1'b0;
              Ld_A      = 1'b1;
              Ld_B      = 1'b0;
              Clear_A   = 1'b0;
            end
      A1, A2, A3, A4, A5, A6	     	:
            begin
              Shift_En  = 1'b0;
              select_op = 1'b0;
              Ld_A      = 1'b1;
              Ld_B      = 1'b0;
              Clear_A   = 1'b0;
            end
      S0, S1, S2, S3, S4, S5, S6, S7    :
            begin
              Shift_En  = 1'b1;
              select_op = 1'b0;
              Ld_A      = 1'b0;
              Ld_B      = 1'b0;
              Clear_A   = 1'b0;
            end
      A7     :
        begin
          Shift_En  = 1'b0;
		    Ld_A      = 1'b1;
          Ld_B      = 1'b0;
          Clear_A   = 1'b0;
			 select_op = 1'b1;
          if(M == 1'b0)
            select_op = 1'b0;
        end
      Finish :
        begin
          Shift_En  = 1'b0;
          select_op = 1'b0;
          Ld_A      = 1'b0;
          Ld_B      = 1'b0;
          Clear_A   = 1'b0;
        end
      Wait   :
        begin
          Shift_En  = 1'b0;
          select_op = 1'b0;
          if(ClearA_LoadB)
            begin
              Ld_A      = 1'b0;
              Ld_B      = 1'b1;
              Clear_A   = 1'b1;
            end
          else
            begin
              Ld_A      = 1'b0;
              Ld_B      = 1'b0;
              Clear_A   = 1'b0;
				  if(Run)
					Clear_A = 1'b1;
            end
        end
		  endcase
	 end

endmodule
