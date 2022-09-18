module IF_Stage_TB();
reg clk,rst,freeze, branch_taken;
reg[31:0] branch_addr;
wire[31:0] pc, instruction;
IF_Stage My_IF_Stage(clk, rst, freeze, branch_taken,branch_addr,pc, instruction);

always #10 clk = ~clk;
parameter t_hold = 2; 

initial begin
    clk = 1'b0;
    rst = 1'b1;
    freeze = 1'b0;
    branch_taken = 1'b0;
    @(posedge clk)
    #t_hold
    rst = 1'b0;
    @(posedge clk)
    #t_hold
    #500
    $stop;
end

endmodule