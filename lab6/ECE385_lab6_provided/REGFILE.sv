// This file is for the REGFILE module!
module reg_file (
                 input logic Clk, LD_REG, Reset,
                 input logic [15:0] DIN,
                 input logic [2:0] SR1_SEL, SR2_SEL, DR_SEL,

                 output logic [15:0] SR1_OUT, SR2_OUT
                );


    Reg_16 SR0_inst(.Clk, .LD_REG(LD_REG0), .Reset, .DIN, DOUT(SR0_VAL);
    Reg_16 SR1_inst(.Clk, .LD_REG(LD_REG1), .Reset, .DIN, DOUT(SR1_VAL);
    Reg_16 SR2_inst(.Clk, .LD_REG(LD_REG2), .Reset, .DIN, DOUT(SR2_VAL);
    Reg_16 SR3_inst(.Clk, .LD_REG(LD_REG3), .Reset, .DIN, DOUT(SR3_VAL);
    Reg_16 SR4_inst(.Clk, .LD_REG(LD_REG4), .Reset, .DIN, DOUT(SR4_VAL);
    Reg_16 SR5_inst(.Clk, .LD_REG(LD_REG5), .Reset, .DIN, DOUT(SR5_VAL);
    Reg_16 SR6_inst(.Clk, .LD_REG(LD_REG6), .Reset, .DIN, DOUT(SR6_VAL);
    Reg_16 SR7_inst(.Clk, .LD_REG(LD_REG7), .Reset, .DIN, DOUT(SR7_VAL);

    // Internal Wires
    logic [15:0] SR0_VAL;
    logic [15:0] SR1_VAL;
    logic [15:0] SR2_VAL;
    logic [15:0] SR3_VAL;
    logic [15:0] SR4_VAL;
    logic [15:0] SR5_VAL;
    logic [15:0] SR6_VAL;
    logic [15:0] SR7_VAL;

    logic LD_REG0;
    logic LD_REG1;
    logic LD_REG2;
    logic LD_REG3;
    logic LD_REG4;
    logic LD_REG5;
    logic LD_REG6;
    logic LD_REG7;


    always_comb begin

        if (LD_REG) begin // If LD_REG then set proper register to load data into
            {LD_REG0, LD_REG1, LD_REG2, LD_REG3, LD_REG4, LD_REG5, LD_REG6, LD_REG7} = 8'b0;
            unique case (DR_SEL)
                3'b000: LD_REG0 = 1;
                3'b001: LD_REG1 = 1;
                3'b010: LD_REG2 = 1;
                3'b011: LD_REG3 = 1;
                3'b100: LD_REG4 = 1;
                3'b101: LD_REG5 = 1;
                3'b110: LD_REG6 = 1;
                3'b111: LD_REG7 = 1;
                default: {LD_REG0, LD_REG1, LD_REG2, LD_REG3, LD_REG4, LD_REG5, LD_REG6, LD_REG7} = 8'b0;
            endcase
        end

        unique case (SR1_SEL) // Set proper value for SR1
            3'b000: SR1_OUT = SR0_VAL;
            3'b001: SR1_OUT = SR1_VAL;
            3'b010: SR1_OUT = SR2_VAL;
            3'b011: SR1_OUT = SR3_VAL;
            3'b100: SR1_OUT = SR4_VAL;
            3'b101: SR1_OUT = SR5_VAL;
            3'b110: SR1_OUT = SR6_VAL;
            3'b111: SR1_OUT = SR7_VAL;
            default: SR1_OUT = 16'b0;
        endcase

        unique case (SR2_SEL) // Set proper value for SR2
            3'b000: SR2_OUT = SR0_VAL;
            3'b001: SR2_OUT = SR1_VAL;
            3'b010: SR2_OUT = SR2_VAL;
            3'b011: SR2_OUT = SR3_VAL;
            3'b100: SR2_OUT = SR4_VAL;
            3'b101: SR2_OUT = SR5_VAL;
            3'b110: SR2_OUT = SR6_VAL;
            3'b111: SR2_OUT = SR7_VAL;
            default: SR2_OUT = 16'b0;
        endcase

    end

endmodule // end of reg_file



module Reg_16 (
               input logic Clk, LD_REG, Reset,
               input logic [15:0] DIN,
               output logic [15:0] DOUT
              );

    always_ff @ (posedge Clk) begin

      if(Reset)
        DOUT <= 16'h0000;
      else if (LD_REG)
        DOUT <= DIN;

    end

endmodule // end of Reg_16
