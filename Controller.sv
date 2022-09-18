`timescale 1ns/1ns
module Controller(
    input[3:0] opcode,
    input[1:0] mode,
    input S_in,
    output[3:0] alu_command,
    output mem_read, mem_write,wb_enb, B,S_out
);

    assign alu_command =(opcode == 4'b1101)? 4'b0001: //move
                        (opcode == 4'b1111)? 4'b1001: //move not
                        (opcode == 4'b0100)? 4'b0010: //add
                        (opcode == 4'b0101)? 4'b0011: //add with carry
                        (opcode == 4'b0010)? 4'b0100: //subtraction
                        (opcode == 4'b0110)? 4'b0101: //subtraction with carry
                        (opcode == 4'b0000)? 4'b0110: //and
                        (opcode == 4'b1100)? 4'b0111: //or
                        (opcode == 4'b0001)? 4'b1000: //exclusive or
                        (opcode == 4'b1010)? 4'b0100: //compare
                        (opcode == 4'b1000)? 4'b0110: //test
                        (opcode == 4'b0100 && mode == 2'b01)? 4'b0010: //load reg
                        (opcode == 4'b0100 && mode == 2'b01)? 4'b0010:4'bxxxx; //store reg


    assign  S_out = (mode == 2'b00)? S_in: 1'b0; //if arithmatic: propagate, if not : zero

    assign mem_read = (opcode == 4'b0100 && mode == 2'b01 && S_in == 1'b1)? 1'b1:1'b0;//load reg

    assign mem_write = (opcode == 4'b0100 && mode == 2'b01 && S_in == 1'b0)? 1'b1:1'b0;//store reg

    assign B = (mode == 2'b10)? 1'b1:1'b0;

    assign wb_enb = (opcode == 4'b1010 || opcode == 4'b1000 || mem_write || B)? 1'b0:1'b1; //cmp or test or store reg or branch

endmodule