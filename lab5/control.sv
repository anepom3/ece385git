module control (input  logic Clk, Reset, LoadA, LoadB, Execute,
                output logic Shift_En, Ld_A, Ld_B );

    // Declare signals curr_state, next_state of type enum
    // with enum values of A, B, ..., F as the state values
	 // Note that the length implies a max of 8 states, so you will need to bump this up for 8-bits
    enum logic [4:0] {A0, S0, A1, S1, A2, S2, A3, S3, A4, S4, A5, S5, A6, S6, A7, S7, Finished, Rest}   curr_state, next_state;

	//updates flip flop, current state is the only one
    always_ff @ (posedge Clk)
    begin
        if (Reset)
            curr_state <= A;
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
				Finish :    next_state = Wait; //only if ~RUN
				Wait   :    next_state = S0; //only if RUN

        endcase

		  // Assign outputs based on ‘state’
        case (curr_state)

		  /* Fill case statements with vals */

		  endcase
	 end

endmodule
