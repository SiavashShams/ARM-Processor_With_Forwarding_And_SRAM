`timescale 1ns/1ns
module Val2Gen_TB();

    reg[11:0] shift_operand;
    reg imm, mem_read, mem_write;
    reg [31:0] reg2;
    wire[31:0] val2;

Va2Gen My_Va2Gen(
    shift_operand,
    imm, mem_read, mem_write,
    reg2,
    val2
);

initial begin
    shift_operand <= 12'b101000101101;
    reg2 <= 32'b10101000100100100011000101000010;
    mem_read <= 1'b0;
    mem_write <= 1'b1;
    #50
    imm <= 1'b0;
    mem_write <= 1'b0;
    #50
    shift_operand <= 12'b101001001101;
    #50
    shift_operand <= 12'b101001101101;
    #50
    imm <= 1'b1;
    #50
    $stop;
end

endmodule

