module Condition_Check(
// statusRegister = {N ,Z , C , V} 
	input [3:0]statusRegister,
	input [3:0]cond,
	output out_sel
);
assign out_sel = (cond ==4'b0000) ? statusRegister[2] ://z
				 (cond ==4'b0001) ? !statusRegister[2]://!z
				 (cond ==4'b0010) ? statusRegister[1] ://c
				 (cond ==4'b0011) ? !statusRegister[1]://!c
				 (cond ==4'b0100) ? statusRegister[3] ://N
				 (cond ==4'b0101) ? !statusRegister[3]://!N
				 (cond ==4'b0110) ? statusRegister[0] ://v
				 (cond ==4'b0111) ? !statusRegister[0]://!v
				 (cond ==4'b1000) ? statusRegister[1]&&(!statusRegister[2])://c and !z  // aya in notion dorosete
				 (cond ==4'b1001) ? statusRegister[2]||(!statusRegister[3])://z and !c
				 (cond ==4'b1010) ? statusRegister[3]==statusRegister[0]   :// N==v
				 (cond ==4'b1011) ? statusRegister[3]!=statusRegister[0]   :// N =!v
				 (cond ==4'b1100) ? (statusRegister[2]==1'b0 && statusRegister[0]==statusRegister[3])://z==0 and v==n
				 (cond ==4'b1101) ? (statusRegister[2]==1'b1 || statusRegister[0]!=statusRegister[3])://z==1 or v!=n
				 (cond ==4'b1110) ? 1'b1 : 4'bxxxx ;
				 
				 
endmodule
