`timescale 1ns/1ns
module ID_Stage(
    input clk, rst,
    input[31:0] inst,
    input[3:0] wb_dest,
    input[31:0] wb_value,
    input[3:0] SR,
    input wb_wb_en,hazard,
    output two_src,
    output[3:0] alu_command_out,
    output mem_read_out,mem_write_out,B_out,wb_enb_out,S_con_out,imm,
    output[3:0] dest,
    output[23:0] signed_immed_24,
    output[11:0] shift_operand,
    output[31:0] val1, val2,
    output[3:0] src1, src2
);

    wire[3:0] opcode;
    wire[3:0] cond;
   
    wire[1:0] mode;
    wire S;
    wire[3:0] alu_command;
    wire mem_read, mem_write,wb_enb, B,S_con, cond_check_out;

    assign opcode = inst[24:21];
    assign cond = inst[31:28];
    assign mode = inst[27:26];
    assign S = inst[20];
    assign imm = inst[25];
    assign dest = inst[15:12];
    assign signed_immed_24 = inst[23:0];
    assign shift_operand = inst[11:0];

    assign src1 = inst[19:16];

    // if command is store reg, Rd(inst[15:12]) is data for storing
    assign src2 = (mem_write)? inst[15:12]:inst[3:0];
   

    assign two_src = !imm || mem_write; 

    Controller My_Controller(opcode,mode,S, alu_command,
                        mem_read, mem_write,wb_enb, B,S_con);

    assign clr_cntls_sel = !cond_check_out || hazard;
    

    //MUX to zero control signals if clr_cntls_sel is 1
    assign alu_command_out = (clr_cntls_sel)? 4'b0000:alu_command;
    assign mem_read_out = (clr_cntls_sel)? 1'b0:mem_read;
    assign mem_write_out = (clr_cntls_sel)? 1'b0:mem_write;
    assign B_out = (clr_cntls_sel)? 1'b0:B;
    assign wb_enb_out = (clr_cntls_sel)? 1'b0:wb_enb;
    assign S_con_out = (clr_cntls_sel)? 1'b0:S_con;

    //Condition Check
    Condition_Check My_Condition_Check(SR,cond,cond_check_out);
    //Register file
    Register_File My_Register_File(clk,rst ,src1 ,src2 , wb_dest,
	                                wb_value,wb_wb_en,val1 ,val2);
endmodule