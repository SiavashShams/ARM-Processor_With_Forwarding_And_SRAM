module Va2Gen (
    input[11:0] shift_operand,
    input imm, mem_read, mem_write,
    input [31:0] reg2,
    output [31:0] val2
);

wire[5:0] rotate_imm2;
wire[7:0] immed_8;
wire[31:0] container32;
wire[31:0] shifted_immed;
wire [31:0] shifted_reg2;
wire signed[31:0] arith_right_shifted_reg2;
wire [4:0] shift_imm;
wire[1:0] shift;

assign val2 =   (mem_read || mem_write) ? shift_operand: // STR, LDR -> 12bit offset
                (imm) ? shifted_immed: shifted_reg2; // 32-bit immediate(container rotation) vs immeditate shift(shifted Rm)


// 32-bit immediate(container rotation)
assign rotate_imm2 = shift_operand[11:8] << 1;
assign immed_8 = shift_operand[7:0];
assign container32 = {24'b0,immed_8};
assign shifted_immed = (container32 >> rotate_imm2) | (container32 << 32 - rotate_imm2);  

//immeditate shift(shifted Rm)
assign shift_imm = shift_operand[11:7];
assign shift = shift_operand[6:5];
//this id done here, becuase >>> not work in conditional assignment
assign arith_right_shifted_reg2 = $signed(reg2) >>> shift_imm;
assign shifted_reg2 =   (shift == 2'b00)? reg2 << shift_imm: //logical shift left
                        (shift == 2'b01)? reg2 >> shift_imm: //logical shift right
                        (shift == 2'b10)? arith_right_shifted_reg2://arithmatic shift right
                        (shift == 2'b11)? (reg2 >> shift_imm) | (reg2 << (32 - shift_imm)): 31'bx;  
                        //rotate right

endmodule