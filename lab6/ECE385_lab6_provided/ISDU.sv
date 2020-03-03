//------------------------------------------------------------------------------
// Company:          UIUC ECE Dept.
// Engineer:         Stephen Kempf
//
// Create Date:    17:44:03 10/08/06
// Design Name:    ECE 385 Lab 6 Given Code - Incomplete ISDU
// Module Name:    ISDU - Behavioral
//
// Comments:
//    Revised 03-22-2007
//    Spring 2007 Distribution
//    Revised 07-26-2013
//    Spring 2015 Distribution
//    Revised 02-13-2017
//    Spring 2017 Distribution
//------------------------------------------------------------------------------


module ISDU (   input logic         Clk,
									Reset,
									Run,
									Continue,

				input logic[3:0]    Opcode,
				input logic         IR_5,
				input logic         IR_11,
				input logic         BEN,

				output logic        LD_MAR,
									LD_MDR,
									LD_IR,
									LD_BEN,
									LD_CC,
									LD_REG,
									LD_PC,
									LD_LED, // for PAUSE instruction

				output logic        GatePC,
									GateMDR,
									GateALU,
									GateMARMUX,

				output logic [1:0]  PCMUX,
				output logic        DRMUX,
									SR1MUX,
									SR2MUX,
									ADDR1MUX,
				output logic [1:0]  ADDR2MUX,
									ALUK,

				output logic        Mem_CE,
									Mem_UB,
									Mem_LB,
									Mem_OE,
									Mem_WE
				);

	enum logic [4:0] {  Halted,
						PauseIR1, // Done
						PauseIR2, // Done
						S_18, // Done
						S_33_1, // Done
						S_33_2, // Done
						S_35, // Done
						S_32,
						S_01, // Done
						S_05,
						S_09,
						S_00,
						S_22,
						S_27,
						S_12,
						S_04,
						S_21,
						S_06,
						S_25_1,
						S_25_2,
						S_07,
						S_23,
						S_16_1,
						S_16_2}   State, Next_state;   // Internal state logic

	always_ff @ (posedge Clk)
	begin
		if (Reset)
			State <= Halted;
		else
			State <= Next_state;
	end

	always_comb
	begin
		// Default next state is staying at current state
		Next_state = State;

		// Default controls signal values
		LD_MAR = 1'b0;
		LD_MDR = 1'b0;
		LD_IR = 1'b0;
		LD_BEN = 1'b0;
		LD_CC = 1'b0;
		LD_REG = 1'b0;
		LD_PC = 1'b0;
		LD_LED = 1'b0;

		GatePC = 1'b0;
		GateMDR = 1'b0;
		GateALU = 1'b0;
		GateMARMUX = 1'b0;

		ALUK = 2'b00;

		PCMUX = 2'b00;
		DRMUX = 1'b0;
		SR1MUX = 1'b0;
		SR2MUX = 1'b0;
		ADDR1MUX = 1'b0;
		ADDR2MUX = 2'b00;

		Mem_OE = 1'b1;
		Mem_WE = 1'b1;

		// Assign next state
		unique case (State)
			Halted :
				if (Run)
					Next_state = S_18;
			S_18 :
				Next_state = S_33_1;
			// Any states involving SRAM require more than one clock cycles.
			// The exact number will be discussed in lecture.
			S_33_1 :
				Next_state = S_33_2;
			S_33_2 :
				Next_state = S_35;
			S_35 :
				Next_state = S_32;
			// PauseIR1 and PauseIR2 are only for Week 1 such that TAs can see
			// the values in IR.
			PauseIR1 :
				if (~Continue)
					Next_state = PauseIR1;
				else
					Next_state = PauseIR2;
			PauseIR2 :
				if (Continue)
					Next_state = PauseIR2;
				else
					Next_state = S_18;
			S_32 :
				case (Opcode) // You need to finish the rest of opcodes.....
					4'b0001 : // ADD
						Next_state = S_01;
					4'b0101 : // AND
						Next_state = S_05;
					4'b1001 : // NOT
						Next_state = S_09;
					4'b0000 : // BR
						Next_state = S_00;
					4'b1100 : // JMP
						Next_state = S_12;
					4'b0100 : // JSR
						Next_state = S_04;
					4'b0110 : // LDR
						Next_state = S_06;
					4'b0111 : // STR
						Next_state = S_07;
					4'b1101 : // PAUSE
						Next_state = PauseIR1;
					default :
						Next_state = S_18;
				endcase
			// You need to finish the rest of states.....
			S_01 :
				Next_state = S_18;
			S_05 :
				Next_state = S_18;
			S_09 :
				Next_state = S_18;
			S_00 : begin
				Next_state = S_18;
				if(BEN)
					Next_state = S_22;
					end
			S_22 :
				Next_state = S_18;
			S_12 :
				Next_state = S_18;
			S_04 :
				Next_state = S_21;
			S_21 :
				Next_state = S_18;
			S_06 :
				Next_state = S_25_1;
			S_25_1 :
				Next_state = S_25_2;
			S_25_2 :
				Next_state = S_27;
			S_27 :
				Next_state = S_18;
			S_07 :
				Next_state = S_23;
			S_23 :
				Next_state = S_16_1;
			S_16_1 :
				Next_state = S_16_2;
			S_16_2 :
				Next_state = S_18;
			default : ;

		endcase

		// Assign control signals based on current state
		case (State)
			Halted: ;
			S_18 : // MAR <- PC; PC <- PC+1;
				begin
					GatePC = 1'b1;
					LD_MAR = 1'b1;
					PCMUX = 2'b00;
					LD_PC = 1'b1;
				end
			S_33_1 : // MDR <- M
				Mem_OE = 1'b0;
			S_33_2 :
				begin
					Mem_OE = 1'b0;
					LD_MDR = 1'b1;
				end
			S_35 : // IR <- MDR
				begin
					GateMDR = 1'b1;
					LD_IR = 1'b1;
				end
			PauseIR1:
			begin
				LD_LED = 1'b1;
			end // Paused
			PauseIR2:
			begin
				LD_LED = 1'b1;
			end  // Paused
			S_32 : // Set BEN
				LD_BEN = 1'b1;
			S_01 : // DR <- SR1 + Input2 (SR2 or imm5); set CC
				begin
					SR2MUX = IR_5;
					ALUK = 2'b00;
					GateALU = 1'b1;
					LD_REG = 1'b1;
					// incomplete... does something else need to happen in this state???
				end
			// You need to finish the rest of states.....
			S_05 : // DR <- SR1 & Input2 (SR2 or imm5); set CC
				begin
					// Fill in proper signals here, check if extra state needed for memory interaction
					SR2MUX = IR_5; // choose between SR2 and imm5
					ALUK = 2'b01; // AND operation of ALU
					GateALU = 1'b1; // result comes from ALU
					LD_REG = 1'b1; // load into DR
					LD_CC = 1'b1; // set CC
				end
			S_09 : // DR <- NOT(SR); set CC
				begin
					// Fill in proper signals here, check if extra state needed for memory interaction
					ALUK = 2'b10; // NOT operation of ALU
					GateALU = 1'b1; // result comes from ALU
					LD_REG = 1'b1; // load into DR
					LD_CC = 1'b1; // set CC
				end
			S_00 : // [BEN]
				begin
					// Fill in proper signals here, check if extra state needed for memory interaction
					// I think this one is just nothing...???
				end
			S_22 : // PC <- PC + off9
				begin
					// Fill in proper signals here, check if extra state needed for memory interaction
					ADDR2MUX = 2'b10; // sign-extended 9-bit offset
					LD_PC = 1'b1; // set PC value
					PCMUX = 2'b10; // set PC value from adder output value
				end
			S_12 : // PC <- BaseR
				begin
					// Fill in proper signals here, check if extra state needed for memory interaction
					ADDR1MUX = 1'b1; // adder input from reg instead of PC
					LD_PC = 1'b1; // set PC value
					PCMUX = 2'b10; // set PC value from adder output value
				end
			S_04 : // R7 <- PC
				begin
					// Fill in proper signals here, check if extra state needed for memory interaction
					DRMUX = 1'b1 ;// set DR to 111
					LD_REG = 1'b1; // set value into DR
					GatePC = 1'b1; // put PC onto the datapath
				end
			S_21 : // PC <- PC + off11
				begin
					// Fill in proper signals here, check if extra state needed for memory interaction
					LD_PC = 1'b1; // set PC value
					PCMUX = 2'b10; // set PC value from adder output value
					ADDR2MUX = 2'b11; // sign-extended 11-bit offset
				end
			S_06 : // MAR <- B + off6
				begin
					// Fill in proper signals here, check if extra state needed for memory interaction
					LD_MAR = 1'b1; // set MAR value
					ADDR1MUX = 1'b1; // Adder 1 input from BaseR
					ADDR2MUX = 2'b01; // Adder 2 input from sign-extended 6-bit value
					GateMARMUX = 1'b1; // put adder output onto the datapath
				end
			S_25_1 : // MDR <- M[MAR] : State 1
				begin
					// Fill in proper signals here, check if extra state needed for memory interaction
					Mem_OE = 1'b0; // set memory output enable
				end
			S_25_2 : // MDR <- M[MAR] : State 2
				begin
					// Fill in proper signals here, check if extra state needed for memory interaction
					Mem_OE = 1'b0; // set memory output enable
					LD_MDR = 1'b1; // set MDR value
				end
			S_27 : // DR <- MDR; set CC
				begin
					// Fill in proper signals here, check if extra state needed for memory interaction
					LD_REG = 1'b1; // set value into DR
					GateMDR = 1'b1; // put MDR onto datapath
					LD_CC = 1'b1;
				end
			S_07 : // MAR <- B + off6
				begin
					// Fill in proper signals here, check if extra state needed for memory interaction
					LD_MAR = 1'b1; // set MAR value
					ADDR1MUX = 1'b1; // Adder 1 input from BaseR
					ADDR2MUX = 2'b01; // Adder 2 input from sign-extended 6-bit value
					GateMARMUX = 1'b1; // put adder output onto the datapath
				end
			S_23 : // MDR <- SR
				begin
					// Fill in proper signals here, check if extra state needed for memory interaction
					LD_MDR = 1'b1; // set MDR value
					ALUK = 2'b11; // Nop operation for ALU
					GateALU = 1'b1; // put output of ALU onto datapath
					SR1MUX = 1'b1; // Select SR (IR[11:9])
				end
			S_16_1 : // M[MAR] <- MDR : State 1
				begin
					// Fill in proper signals here, check if extra state needed for memory interaction
					Mem_WE = 1'b0; // set memory write enable
				end
			S_16_2 : // M[MAR] <- MDR : State 2
				begin
					// Fill in proper signals here, check if extra state needed for memory interaction
					Mem_WE = 1'b0; // set memory write enable
				end
			default : ;
		endcase
	end

	 // These should always be active
	assign Mem_CE = 1'b0;
	assign Mem_UB = 1'b0;
	assign Mem_LB = 1'b0;

endmodule
