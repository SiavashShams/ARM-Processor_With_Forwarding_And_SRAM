`timescale 1ns/1ns
module EXE_Stage_Reg(
    input clk, rst, 
    input wb_enb_exe,output reg wb_enb_mem,
    input mem_read_exe,output reg mem_read_mem,
    input mem_write_exe,output reg mem_write_mem,
    input[31:0] ALU_Res_exe,output reg[31:0] ALU_Res_mem,
    input[31:0] val2_exe,output reg[31:0] val2_mem,
    input[3:0] dest_exe,output reg[3:0] dest_mem,
    input flush, freeze
);

always@(posedge clk, posedge rst) begin
    if(rst) begin
        wb_enb_mem <= 'b0;
        mem_read_mem <= 'b0;
        mem_write_mem <= 'b0;
        ALU_Res_mem <= 'b0;
        val2_mem <= 'b0;
        dest_mem <= 'b0;
    end else if(~freeze) begin
        wb_enb_mem <= wb_enb_exe;
        mem_read_mem <= mem_read_exe;
        mem_write_mem <= mem_write_exe;
        ALU_Res_mem <=  ALU_Res_exe;
        val2_mem <= val2_exe;
        dest_mem <= dest_exe;
    end
end


endmodule
