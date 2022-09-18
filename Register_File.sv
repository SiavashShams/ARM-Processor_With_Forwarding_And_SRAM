module Register_File(
	input clk,rst ,
	input[3:0] srcl ,src2 , dest_wb,
	input [31:0] Result_WB,
	input writeBackEn,
	output [31:0] reg1 ,reg2
);
	integer  j;
	reg[31:0] Reg_File[0:14];
	
	assign reg1 = Reg_File[srcl];
	assign reg2 = Reg_File[src2];
	always @(negedge clk  ) begin
      if (rst)
      			for (j = 0 ; j < 15 ; j = j + 1)
        		Reg_File[j] <= j;
			else if (writeBackEn)
        		Reg_File [dest_wb] <= Result_WB;
    		end
endmodule