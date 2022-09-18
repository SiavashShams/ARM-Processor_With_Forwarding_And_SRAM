`timescale 1ns/1ns
module ID_Stage_Reg(
    input clk, rst,
    input[31:0] pc_id, output reg[31:0]  pc_exe,
    input[3:0] alu_command_id, output reg[3:0]  alu_command_exe,
    input mem_read_id,output reg  mem_read_exe,
    input mem_write_id,output reg  mem_write_exe,
    input B_id,output reg B_exe,
    input wb_enb_id,output reg wb_enb_exe,
    input S_id,output reg S_exe,
    input imm_id,output reg imm_exe,
    input[3:0] dest_id,output reg[3:0] dest_exe,
    input[23:0] signed_immed_24_id,output reg[23:0]  signed_immed_24_exe,
    input[11:0] shift_operand_id,output reg[11:0]  shift_operand_exe,
    input[31:0]  val1_id,output reg[31:0]  val1_exe,
    input[31:0]  val2_id,output reg[31:0]  val2_exe,
    input flush,
    input[3:0] SR, output reg[3:0] SR_exe,
    input[3:0] src1_id,output reg[3:0] src1_exe,
    input[3:0] src2_id,output reg[3:0] src2_exe,
    input freeze
);



always@(posedge clk, posedge rst) begin
    if(rst) begin
        pc_exe <= 32'b0;
        alu_command_exe <= 'b0;
        mem_read_exe <=  'b0;
        mem_write_exe <=  'b0;
        B_exe <= 'b0;
        wb_enb_exe <=  'b0;
        S_exe <=  'b0;
        imm_exe <=  'b0;
        dest_exe <=  'b0;
        signed_immed_24_exe <= 'b0;
        shift_operand_exe <= 'b0;
        val1_exe <=  'b0;
        val2_exe <=  'b0;
        SR_exe <= 'b0;
        src1_exe <= 'b0;
        src2_exe <= 'b0;
    end else if(flush) begin
        pc_exe <= 32'b0;
        alu_command_exe <= 'b0;
        mem_read_exe <=  'b0;
        mem_write_exe <=  'b0;
        B_exe <= 'b0;
        wb_enb_exe <=  'b0;
        S_exe <=  'b0;
        imm_exe <=  'b0;
        dest_exe <=  'b0;
        signed_immed_24_exe <= 'b0;
        shift_operand_exe <= 'b0;
        val1_exe <=  'b0;
        val2_exe <=  'b0;
        SR_exe <= 'b0;
        src1_exe <= 'b0;
        src2_exe <= 'b0;
    end else if(~freeze) begin
        pc_exe <= pc_id;
        alu_command_exe <= alu_command_id;
        mem_read_exe <=  mem_read_id;
        mem_write_exe <=  mem_write_id;
        B_exe <= B_id;
        wb_enb_exe <=  wb_enb_id;
        S_exe <=  S_id;
        imm_exe <=  imm_id;
        dest_exe <=  dest_id;
        signed_immed_24_exe <= signed_immed_24_id;
        shift_operand_exe <=  shift_operand_id;
        val1_exe <=  val1_id;
        val2_exe <=  val2_id;
        SR_exe <= SR;
        src1_exe <= src1_id;
        src2_exe <= src2_id;
    end
end


endmodule
