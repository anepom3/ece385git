module reg_1 (input  logic Clk, Reset, Clear,
              input  logic  D,
              output logic  Data_Out);

    always_ff @ (posedge Clk)
    begin
	 	 if (Reset | Clear) //notice, this is a sycnrhonous reset, which is recommended on the FPGA
			  Data_Out <= 1'b0;
		 else
			  Data_Out <= D;
    end

endmodule