module reg_1 (input  logic Clk, Reset, Clear,
              input  logic  Data_IN, Ld,
              output logic  Data_OUT);
	logic D;
    always_ff @ (posedge Clk)
    begin
	 	 if (Reset | Clear) //notice, this is a sycnrhonous reset, which is recommended on the FPGA
			  Data_OUT <= 1'b0;
		 else
			  Data_OUT <= D;
    end
	 
	 always_comb
	 begin
		if(Ld)
			D=Data_IN;
		else
			D=Data_OUT;
	 end
endmodule
