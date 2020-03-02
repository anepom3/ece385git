// TODO we'l make a datapath module here!
// This will be used to connect all the modules together.
// Week 1
// PC (Program Counter) Package: PC, PCMUX, '+1', (GatePC)
// MDR Package: MDR, (GateMDR)
// MAR Package: MAR, (GateMAR)
// IR Package: IR
// Internal Tri-state MUX Package: GateMDR, GateMAR, GatePC (Gate ALU for Week 2)
module datapath #(N=16)(// Inputs
                        input logic Clk, Reset,
                                    LD_PC, LD_MDR, LD_MAR, LD_IR,
                                    MIO_EN,LD_BEN, LD_CC,LD_REG,
                                    GatePC, GateMDR, GateMARMUX, GateALU,
                        input logic [1:0] PCMUX, ADDR2MUX, ALUK,
                        input logic DRMUX, SR1MUX, SR2MUX, ADDR1MUX,
                        input logic [N-1:0] MEM2MDR,
                        // Outputs
                        output logic [N-1:0] MAR2MEM, MDR2MEM, IR_OUT, PC_OUT
                        output logic BEN_OUT
                        );

    //Internal wires for datapath
    logic [N-1:0] BUS;

    // PC Packge Internal wires
    logic [N-1:0] PC_PLUS, ADDER, PC_IN, PC_OUT_comb;
    assign PC_OUT = PC_OUT_comb;
    // MAR Package Internal wires

    //MDR Package Internal wires
    logic [N-1:0] MDR_IN, MDR_OUT;
    assign MDR2MEM = MDR_OUT;
    //IR Package Internal wires
    logic [N-1:0] IR_OUT_comb;
    assign IR_OUT = IR_OUT_comb;
    // internal_tristate Package wires

    // ALU Package Internal wires
    logic [N-1:0] ALU_BUS_comb;
    // ADDR Package Internal wires
    logic [N-1:0] ADDR2toADDR, ADDR1toADDR;
    logic [N-1:0] ADDR_OUT_comb;
    // REGFILE Internal wires
    logic[2:0] SR1_SEL, SR2_SEL, DR_SEL;
    logic [N-1:0] SR1_OUT, SR2_OUT;

    // Sign extension Internal wires
    logic [N-1] S_ext5, S_ext6, S_ext9, S_ext11;

    // BEN Logic Internal wires
    logic BEN_OUT_comb;
    assign BEN_OUT = BEN_OUT_comb;
    // Module Instantiations
    // PC Package
    PC PC_inst(.Clk, .Reset, .LD_PC, .DIN(PC_IN), .DOUT(PC_OUT_comb));
    Incrementer Incrementer_inst(.DIN(PC_OUT_comb), .DOUT(PC_PLUS));
    PCMUX PCMUX_inst(.PCMUX, .PC_PLUS(PC_PLUS), .BUS, .ADDER(ADDR_OUT_comb),
                     .PC_IN(PC_IN));

    // MAR Package
    MAR MAR_inst(.Clk, .Reset, .LD_MAR, .DIN(BUS), .DOUT(MAR2MEM));

    // MDR Package
    MDR MDR_inst(.Clk, .Reset, .LD_MDR, .DIN(MDR_IN), .DOUT(MDR_OUT));
    MDRMUX MDRMUX_inst(.MDR_MUX(MIO_EN), .Data_to_CPU(MEM2MDR), .BUS, .MDR_IN);

    // IR Package
    IR IR_inst(.Clk, .Reset, .LD_IR, .DIN(BUS), .DOUT(IR_OUT_comb));

    // Internal Tristate Buffers Package
    internal_tristate internal_tristate_inst(.PC_BUS(PC_OUT), .MDR_BUS(MDR_OUT),
                                             .MARMUX_BUS(ADDR_OUT_comb),
                                             .ALU_BUS(ALU_BUS_comb),
                                             .Select({GateALU, GateMARMUX, GateMDR, GatePC}),
                                             .Gate_OUT(BUS));

    // Register File package
    reg_file reg_file_inst(.Clk, .LD_REG, .Reset, .DIN(BUS),
                           .SR1_SEL, .SR2_SEL(IR_OUT_comb[2:0]),
                           .DR_SEL,
                           .SR1_OUT, .SR2_OUT);
    DRMUX DRMUX_inst(.IR_Slice0(IR_OUT_comb[11:9]), .Select(DRMUX),
                     .Gate_OUT(DR_SEL));
    SR1MUX SR1MUX_inst(.IR_Slice0(IR_OUT_comb[8:6]), .IR_Slice1(IR_OUT_comb[11:9]),
                       .Select(SR1MUX),
                       .Gate_OUT(SR1_SEL));

    // ALU package
    SR2MUX SR2MUX_inst(.SR2_OUT, .imm5(S_ext5), .Select(SR2MUX), .Gate_OUT(B_ALU));
    ALU ALU_inst(.A(SR1_OUT), .B(B_ALU), .ALUK, .DOUT(ALU_BUS_comb));

    // ADDR package
    ADDR ADDR_inst(.ADDR1MUX_IN(ADDR1toADDR), .ADDR2MUX_IN(ADDR2toADDR),
                   .ADDR_OUT(ADDR_OUT_comb));
    ADDR1MUX ADDR1MUX_inst(.PC(PC_OUT_comb), .BaseR(SR1_OUT),
                           .Select(ADDR1MUX),
                           .Gate_OUT(ADDR1toADDR));
    ADDR2MUX ADDR2MUX_inst(.offset6(S_ext6), .PCoffset9(S_ext9), .PCoffset11(S_ext11),
                           .Select(ADDR2MUX),
                           .Gate_OUT(ADDR2toADDR));

    // Sign Extension Package
    sign_ext sign_ext_inst(.In_5(IR_OUT_comb[4:0]), .In_6(IR_OUT_comb[5:0]),
                           .In_9(IR_OUT_comb[8:0]), .In_11(IR_OUT_comb[10:0]),
                           .S_ext5, .S_ext6, .S_ext9, .S_ext11);

    // BEN package
    BEN_LOGIC BEN_LOGIC_inst(.DIN(BUS), .IR_Slice(IR_OUT_comb[11:9]),
                             .LD_CC, .LD_BEN, .Clk, .Reset,
                             .BEN_OUT(BEN_OUT_comb));
endmodule
