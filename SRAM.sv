`timescale 1ns/1ns
module SRAM(clk,rst,SRAM_DQ,SRAM_ADDR,SRAM_UB_N,SRAM_LB_N,SRAM_WE_N,
            SRAM_CE_N,SRAM_OE_N);
  
  inout[15:0] SRAM_DQ;
  input [17:0] SRAM_ADDR;
  input clk,rst,SRAM_UB_N,SRAM_LB_N,SRAM_WE_N,SRAM_CE_N,SRAM_OE_N;
  
  reg [15:0] memory [0:63];
 	integer i;
  always@(posedge rst)
  begin
  		 if (rst) 
			for(i=0; i<=63; i = i+1) begin
				memory[i] = 16'b0;
			end
  end
  

assign #1 SRAM_DQ = SRAM_WE_N ? memory[SRAM_ADDR]: 32'bz;

always@(posedge clk) begin
    if(~SRAM_WE_N) begin
        memory[SRAM_ADDR] <= SRAM_DQ;
    end
end
endmodule
