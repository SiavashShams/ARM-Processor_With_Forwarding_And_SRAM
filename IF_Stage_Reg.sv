`timescale 1ns/1ns
module IF_Stage_Reg(
    input clk, rst,
    input[31:0] pc_in, output reg[31:0] pc_out,
    input[31:0] inst_if,output reg[31:0] inst_id,
    input flush, input freeze
);

always@(posedge clk, posedge rst) begin
    if(rst) begin
        pc_out <= 32'b0;
        inst_id <= 32'b0;
    end else if(flush) begin
        pc_out <= 32'b0;
        inst_id <= 32'b0;
    end else if(!freeze) begin
        pc_out <= pc_in;
        inst_id <= inst_if;
    end
end


endmodule
