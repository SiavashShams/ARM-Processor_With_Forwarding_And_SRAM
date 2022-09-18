
module ALU (Val1, Val2,EXE_CMD,Cin ,ALU_Res,status);
	input [31:0]Val1;
	input [31:0]Val2;
	input [3:0]EXE_CMD;
	input Cin;
	output [31:0]ALU_Res;
	output [3:0] status;
	
	wire N,Z,C,V;
	assign status = {N,Z,C,V};
	
	assign {C ,ALU_Res} = (EXE_CMD == 4'b0001)? Val2: //Mov
					(EXE_CMD ==4'b1001)? ~Val2 :	  //MVN
					(EXE_CMD ==4'b0010)? {Val1[31], Val1} + {Val2[31], Val2} ://ADD
					(EXE_CMD ==4'b0011)? {Val1[31], Val1} + {Val2[31], Val2} + Cin : //ADC
					(EXE_CMD ==4'b0100)? {Val1[31], Val1} - {Val2[31], Val2} ://SUB
					(EXE_CMD ==4'b0101)? {Val1[31], Val1} - {Val2[31], Val2} - {31'b0, ~Cin} : //SBC
					(EXE_CMD ==4'b0110)? Val1 & Val2 ://AND
					(EXE_CMD ==4'b0111)? Val1 | Val2 ://OR
					(EXE_CMD ==4'b1000)? Val1 ^ Val2 :33'bx ; //STR
	
	assign Z = (ALU_Res == 32'b0);
	assign N = ALU_Res[31];
	assign V = ((EXE_CMD == 4'b0010) | (EXE_CMD == 4'b0011))? 
			(ALU_Res[31] & ~Val1[31] & ~Val2[31]) | (~ALU_Res[31] & Val1[31] & Val2[31])
		  :((EXE_CMD == 4'b0100) | (EXE_CMD == 4'b0101))? 
			(ALU_Res[31] & ~Val1[31] & Val2[31]) | (~ALU_Res[31] & Val1[31] & ~Val2[31])
		  : 1'b0;
		  
		  
		  
endmodule 