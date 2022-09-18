`timescale 1ns/1ns
module IF_Stage(
    input clk, rst, freeze, branch_taken,
    input[31:0] branch_addr,
    output reg[31:0] pc, instruction
);

// reg[7:0] mem[0:200];
reg[31:0] pc_out, mux_out;

// initial begin
//     //File initialization
//     $readmemb("inst_mem.txt", mem);
// end

// assign instruction = {mem[pc_out], mem[pc_out + 1], mem[pc_out + 2], mem[pc_out + 3]};

Inst_Mem My_Inst_Mem(pc_out, instruction);
assign mux_out = (branch_taken)? branch_addr:pc;

always@(posedge clk, posedge rst) begin
    if(rst)
        pc_out <= 32'b0;
    else if(~freeze)
        pc_out <= mux_out;
end

assign pc = pc_out + 4;

endmodule

