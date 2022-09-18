`timescale 1ns/1ns
module EXE_Stage(
    input clk,rst,
    input[31:0] pc,
    input S,
    input[11:0] shift_operand,
    input imm, mem_read, mem_write,
    input [31:0]val1,
    input [31:0]reg2,
    input[3:0] alu_command,
    input[3:0] SR,
    input[23:0] signed_immed_24,
    input[1:0] sel_src1, sel_src2,
    input[31:0] alu_res_f, wb_value_f,
    output[31:0] ALU_Res,
    output[31:0] branch_addr,
    output reg[3:0] SR_reg
);

wire[31:0] val2;
wire[3:0] SR_out;

wire[31:0] val1_mux,reg2_mux;

assign reg2_mux =  (sel_src2 == 2'b00)? reg2:
                    (sel_src2 == 2'b01)? alu_res_f:
                    (sel_src2 == 2'b10)? wb_value_f:32'bx; 

Va2Gen My_Va2Gen(shift_operand,imm, mem_read, mem_write,reg2_mux,val2);

assign val1_mux =  (sel_src1 == 2'b00)? val1:
                    (sel_src1 == 2'b01)? alu_res_f:
                    (sel_src1 == 2'b10)? wb_value_f:32'bx; 

ALU My_ALU(val1_mux, val2,alu_command,SR[1] ,ALU_Res,SR_out);

assign branch_addr = pc + {{6{signed_immed_24[23]}}, signed_immed_24, 2'b00};

always@(negedge clk, posedge rst) begin
    if(rst)
        SR_reg <= 3'b0;
    else if(S)
        SR_reg <= SR_out;
end


endmodule