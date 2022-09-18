`timescale 1ns/1ns
module Mem_Stage_Reg(
    input clk, rst,
	input WB_EN_mem , output reg WB_EN_wb,
	input MEM_R_EN_mem , output reg MEM_R_EN_wb,
	input [31:0]ALU_Res_mem , output reg [31:0]ALU_Res_wb,
	input [31:0]Data_mem , output reg [31:0]Data_wb,
	input [3:0]Dest_mem , output reg [3:0]Dest_wb,
	input freeze
);


	always@(posedge clk, posedge rst) begin
		if(rst)begin
			{WB_EN_wb ,MEM_R_EN_wb } <= 2'b0;
			{ALU_Res_wb , Data_wb} <= 64'b0;
			Dest_wb = 4'b0;
			end
		else if(~freeze) begin
			{WB_EN_wb ,MEM_R_EN_wb } <= {WB_EN_mem ,MEM_R_EN_mem} ;
			{ALU_Res_wb , Data_wb} <= {ALU_Res_mem, Data_mem};
			Dest_wb <= Dest_mem;
		end
	end


endmodule
