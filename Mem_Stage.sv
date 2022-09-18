`timescale 1ns/1ns
module Mem_Stage(
  input clk, rst,
	input WB_EN,
	input MEM_R_EN,
	input MEM_W_EN,
	input [31:0]ALU_Res,
	input [31:0]Val_Rm,
	input [3:0] Dest,
	output [31:0] mem_out,
	output ready
);

    wire[31:0] address;

	wire [15:0] SRAM_DQ;
  	wire [17:0] SRAM_ADDR;
	wire SRAM_UB_N,SRAM_LB_N,SRAM_WE_N,SRAM_CE_N,SRAM_OE_N;

	assign address = (ALU_Res - 32'd1024) >> 2;

	// reg [31:0]memory[0:64];
	
    // always @(posedge clk) begin 
	// 	if (MEM_W_EN == 1'b1)
	// 		memory[(ALU_Res - 32'd1024) >> 2] <= Val_Rm;
	// 	end 
	// assign mem_out = (MEM_R_EN) ? memory[(ALU_Res - 32'd1024) >> 2] :32'd0;	
	
	Sram_Controller My_Sram_Controller(
    	clk, rst,MEM_W_EN, MEM_R_EN,address,Val_Rm,mem_out,ready,
		SRAM_DQ, SRAM_ADDR ,SRAM_UB_N,SRAM_LB_N,SRAM_WE_N,SRAM_CE_N,SRAM_OE_N);	

	SRAM My_SRAM(clk,rst,SRAM_DQ,SRAM_ADDR,SRAM_UB_N,SRAM_LB_N,SRAM_WE_N,SRAM_CE_N,SRAM_OE_N);

endmodule
