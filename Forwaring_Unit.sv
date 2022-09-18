module Forwarding_Unit (
    input forward_enb,
    input[3:0] src1_exe,src2_exe,dest_mem, dest_wb,
    input wb_enb_mem, wb_enb_wb,
    output reg[1:0] sel_src1, sel_src2
);

    always @(*) begin
        sel_src1 <= 2'b00;
        sel_src2 <= 2'b00;
        
        if (forward_enb) begin
            //Data dependancy of mem_stage & exe_stage for src1
            if (wb_enb_mem && (dest_mem == src1_exe))
                sel_src1 <= 2'b01;
            //Data dependancy of wb_stage & exe_stage for src1
            else if (wb_enb_wb && (dest_wb == src1_exe))
                sel_src1 <= 2'b10;

            //Data dependancy of mem_stage & exe_stage for src2
            if (wb_enb_mem && (dest_mem == src2_exe))
                sel_src2 <= 2'b01;
            //Data dependancy of wb_stage & exe_stage for src2
            else if (wb_enb_wb && (dest_wb == src2_exe))
                sel_src2 <= 2'b10;

        end
        
    end

endmodule
