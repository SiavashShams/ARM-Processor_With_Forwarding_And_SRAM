`timescale 1ns/1ns
module WB_Stage(
    input[31:0]ALU_Res,
    input[31:0]mem_out,
    input mem_read,
    output[31:0] wb_value
);

assign wb_value = (mem_read)? mem_out:ALU_Res;

endmodule