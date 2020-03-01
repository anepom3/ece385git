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
                                    MIO_EN,
                                    GatePC, GateMDR, GateMARMUX, GateALU,
                        input logic [1:0] PCMUX,
                        input logic [N-1:0] MEM2MDR,
                        // Outputs
                        output logic [N-1:0] MAR2MEM, MDR2MEM, IR_OUT, PC_OUT
                        );

    //Internal wires for datapath
    logic [N-1:0] BUS;

    // PC Packge Internal wires
    logic [N-1:0] PC_PLUS, ADDER, PC_IN;
    assign ADDER = 16'hxxxx;
    // MAR Package Internal wires

    //MDR Package Internal wires
    logic [N-1:0] MDR_IN, MDR_OUT;
    assign MDR2MEM = MDR_OUT;
    //IR Package Internal wires

    // internal_tristate Package wires

    // Module Instantiations
    // PC Package
    PC PC_inst(.Clk, .Reset, .LD_PC, .DIN(PC_IN), .DOUT(PC_OUT));
    Incrementer Incrementer_inst(.DIN(PC_OUT), .DOUT(PC_PLUS));
    PCMUX PCMUX_inst(.PCMUX, .PC_PLUS(PC_PLUS), .BUS, .ADDER(ADDER),
                     .PC_IN(PC_IN));

    // MAR Package
    MAR MAR_inst(.Clk, .Reset, .LD_MAR, .DIN(BUS), .DOUT(MAR2MEM));

    // MDR Package
    MDR MDR_inst(.Clk, .Reset, .LD_MDR, .DIN(MDR_IN), .DOUT(MDR_OUT));
    MDRMUX MDRMUX_inst(.MDR_MUX(MIO_EN), .Data_to_CPU(MEM2MDR), .BUS, .MDR_IN);

    // IR Package
    IR IR_inst(.Clk, .Reset, .LD_IR, .DIN(BUS), .DOUT(IR_OUT));

    // Internal Tristate Buffers Package
    internal_tristate internal_tristate_inst(.PC_BUS(PC_OUT), .MDR_BUS(MDR_OUT),
                                             .MARMUX_BUS(16'hxxxx),
                                             .ALU_BUS(16'hxxx),
                                             .Select({GateALU, GateMARMUX, GateMDR, GatePC}),
                                             .Gate_OUT(BUS));

    // Register File package
    reg_file reg_file_inst();
    DRMUX DRMUX_inst();
    SR1MUX SR1MUX_inst();

    // ALU package
    SR2MUX SR2MUX_inst();
    ALU ALU_inst();

    // ADDR package
    ADDR ADDR_inst();
    ADDR1MUX ADDR1MUX_inst();
    ADDR2MUX ADDR2MUX_inst();

    // Sign Extension Package
    sign_ext sign_ext_inst();

    // BEN package
    BEN_LOGIC BEN_LOGIC_inst();
endmodule
