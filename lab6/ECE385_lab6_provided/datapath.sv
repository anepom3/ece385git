// TODO we'l make a datapath module here!
// This will be used to connect all the modules together.
// Week 1
// PC (Program Counter) Package: PC, PCMUX, '+1', (GatePC)
// MDR Package: MDR, (GateMDR)
// MAR Package: MAR, (GateMAR)
// IR Package: IR
// Internal Tri-state MUX Package: GateMDR, GateMAR, GatePC (Gate ALU for Week 2)
module datapath (input logic Clk,
                             Reset,
                             LD_PC,
                             LD_IR,
                             LD_MAR,
                             LD_MDR,

                 //Does this need to include the internal connections listed in lines 44-45 of slc3.sv???


                //Should these two be combined into one inout D_BUS
                 input logic [15:0] D_bus_IN, //Data going from other components into data bus

                 output logic [15:0] D_bus_OUT //Data going from data bus into other components
                 );


          //What should we put for the LD values for these instantiations???
          PC PC_inst(.Clk, .Reset, .LD_PC, .DIN(D_bus_OUT), .DOUT(D_bus_IN));

          MDR MDR_inst(.Clk, .Reset, .LD_MDR, .DIN(D_bus_OUT), .DOUT(D_bus_IN));

          MAR MAR_inst(.Clk, .Reset, .LD_MAR, .DIN(D_bus_OUT), .DOUT(D_bus_IN));

          IR IR_inst(.Clk, .Reset, .LD_IR, .DIN(D_bus_OUT), .DOUT(D_bus_IN));

endmodule
