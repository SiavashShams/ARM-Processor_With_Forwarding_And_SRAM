`timescale 1ns/1ns
module ARM_PROCESSOR(
    input clk,rst,
    input forward_enb
);
wire[31:0] branch_addr_if;
wire[31:0] pc_if,inst_if, inst_id;

wire[31:0] pc_id,pc_exe;
wire flush;
wire[3:0] alu_command_id, alu_command_exe;
wire mem_read_id, mem_read_exe, mem_read_mem;
wire mem_write_id, mem_write_exe, mem_write_mem;
wire B_id;
wire wb_enb_id, wb_enb_mem;
wire S_id, S_exe;
wire imm_id, imm_exe;
wire[3:0] dest_id, dest_exe, dest_mem;
wire[23:0] signed_immed_24_id,signed_immed_24_exe;
wire[11:0] shift_operand_id, shift_operand_exe;
wire[31:0]  val1_id, val1_exe;
wire[31:0]  val2_id, val2_exe, val2_mem;
wire[3:0] SR, SR_exe;
wire[3:0] wb_dest_wb;
wire[31:0] wb_value_wb;
wire[31:0] mem_out, mem_out_wb;
wire[31:0] ALU_Res_wb;
wire wb_enb_wb, mem_read_wb;

wire[31:0] ALU_Res_exe, ALU_Res_mem;
wire[3:0] src1_id,src2_id,src1_exe,src2_exe;
wire two_src;
wire wb_enb_exe;
wire B_exe;
wire hazard, freeze;
wire[1:0] sel_src1, sel_src2;
wire ready;

assign flush = B_exe;
assign freeze = hazard | ~ready;

IF_Stage My_IF_Stage(clk, rst, freeze, B_exe,branch_addr_if,pc_if, inst_if);
IF_Stage_Reg My_IF_Stage_Reg(clk, rst, pc_if,pc_id, inst_if,inst_id,flush, freeze);

ID_Stage My_ID_Stage(clk, rst,inst_id,wb_dest_wb,wb_value_wb,SR,wb_enb_wb,hazard,
                    two_src,alu_command_id,mem_read_id,
                    mem_write_id,B_id,wb_enb_id,S_id,
                    imm_id,dest_id,signed_immed_24_id,shift_operand_id,
                    val1_id, val2_id, src1_id, src2_id);

ID_Stage_Reg My_ID_Stage_Reg(clk, rst, pc_id,pc_exe,
                            alu_command_id, alu_command_exe,
                            mem_read_id, mem_read_exe,
                            mem_write_id, mem_write_exe,
                            B_id,B_exe,
                            wb_enb_id, wb_enb_exe,
                            S_id, S_exe,
                            imm_id, imm_exe,
                            dest_id, dest_exe,
                            signed_immed_24_id,signed_immed_24_exe,
                            shift_operand_id, shift_operand_exe,
                            val1_id, val1_exe, 
                            val2_id, val2_exe,
                            flush,
                            SR, SR_exe,
                            src1_id, src1_exe,
                            src2_id, src2_exe,
                            ~ready);

EXE_Stage My_EXE_Stage (clk, rst,pc_exe, S_exe,shift_operand_exe, imm_exe,
                         mem_read_exe,mem_write_exe,
                        val1_exe,val2_exe,alu_command_exe,SR_exe,signed_immed_24_exe, 
                        sel_src1, sel_src2,ALU_Res_mem, wb_value_wb,
                        ALU_Res_exe, branch_addr_if, SR);


EXE_Stage_Reg My_EXE_Stage_Reg (clk, rst, 
                                wb_enb_exe, wb_enb_mem,
                                mem_read_exe, mem_read_mem,
                                mem_write_exe, mem_write_mem,
                                ALU_Res_exe, ALU_Res_mem,
                                val2_exe, val2_mem,
                                dest_exe, dest_mem, flush,
                                ~ready);

Mem_Stage My_Mem_Stage(clk, rst, 
                    wb_enb_mem, mem_read_mem,mem_write_mem,
                    ALU_Res_mem, val2_mem, dest_mem,mem_out,ready);

Mem_Stage_Reg My_Mem_Stage_Reg(clk, rst,
                                wb_enb_mem, wb_enb_wb,
                                mem_read_mem, mem_read_wb,
                                ALU_Res_mem, ALU_Res_wb,
                                mem_out, mem_out_wb,
                                dest_mem, wb_dest_wb,
                                ~ready);

WB_Stage My_WB_Stage(ALU_Res_wb,mem_out_wb,mem_read_wb, wb_value_wb);

Hazard_Detection_Unit My_Hazard_Detection_Unit(forward_enb,src1_id, src2_id,two_src,
                                                mem_read_mem, mem_read_wb,
                                               dest_exe, dest_mem,
                                                wb_enb_exe, wb_enb_mem, hazard);

Forwarding_Unit My_Forwarding_Unit( forward_enb,
                                    src1_exe,src2_exe,dest_mem, wb_dest_wb,
                                    wb_enb_mem, wb_enb_wb,
                                    sel_src1, sel_src2);

endmodule