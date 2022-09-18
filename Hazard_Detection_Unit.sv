module Hazard_Detection_Unit (
    input forward_enb,
    input[3:0] src1, src2,
    input two_src,
    input mem_read_mem, mem_read_wb,
    input[3:0] exe_dest, mem_dest,
    input exe_wb_en,mem_wb_en,
    output reg hazard
);

    always@(*) begin

        if(forward_enb) 
            //hazard accurs just for LOAD Reg instructions which is in Mem Stage and has dependancy
            //      with Exe Stage 
            hazard <= mem_read_mem && ((exe_dest == src1) || (two_src && exe_dest == src2));

        else
            //1. hazard accurs for Data dependancy of ID Stage and ExE Stage
            //2. hazard accurs for Data dependancy of ID Stage and Mem Stage
            hazard <= (exe_wb_en && ((exe_dest == src1) || (two_src && exe_dest == src2))) || 
                        (mem_wb_en && ((mem_dest == src1) || (two_src && mem_dest == src2)));
    end
endmodule
