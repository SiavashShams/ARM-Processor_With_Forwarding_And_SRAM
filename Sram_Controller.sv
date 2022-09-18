`timescale 1ns/1ns

module Sram_Controller(
    input clk,
    input rst,

    //From Mem Stage
    input wr_en,
    input rd_en,
    input [31:0] unshifted_address,
    input [31:0] writeData,

    //toNext Stage 
    output reg [31:0] readData,

    //For Freeze Other Stage
    output reg ready,

    inout [15:0] SRAM_DQ,      // SRAM Data Bus 
    output reg[17:0] SRAM_ADDR , // SRAM Address bus 
    output  SRAM_UB_N,         //SRAM high byte Data Mask
    output  SRAM_LB_N,         // SRAM low byte Data Mask
    output reg SRAM_WE_N,         // SRAM write Enable
    output  SRAM_CE_N,         // SRAM chip Enable
    output  SRAM_OE_N          // SRAM output ENable
);	
    
	
	reg [2:0] ns,ps;
    reg [15:0] data;
    reg sramDataBusCtrl;
    wire[31:0] address;
	assign address = unshifted_address << 1;
	assign {SRAM_UB_N,SRAM_LB_N,SRAM_CE_N,SRAM_OE_N} = 4'd0;
	assign SRAM_DQ = (sramDataBusCtrl)?data : {16{1'bz}};// 	
	
	always@(posedge clk,posedge rst)begin
        if(rst)
            ps<=3'd0;
        
        else 
            ps<=ns;
    end
	
	
	always@(ps,wr_en,rd_en)begin
        case (ps)
            3'd0 :ns =(wr_en) ? 3'd1:(rd_en)?3'd3:3'd0;
			3'd1 :ns =3'd2;
			3'd2 :ns =3'd5;
			3'd3 :ns =3'd4;
			3'd4 :ns =3'd5;
			3'd5 :ns =3'd6;
			3'd6 :ns =3'd7;
			3'd7 :ns =3'd0;
		endcase
	end
	
	always @(ps,wr_en,rd_en)
  begin
    {SRAM_WE_N,ready,sramDataBusCtrl} = 3'b110;
    case (ps)
      3'd0: ready = ~(wr_en || rd_en);
      3'd1: begin
                SRAM_WE_N = 1'b0 ;
                data =  writeData[15:0];
                sramDataBusCtrl = wr_en;
                SRAM_ADDR = address;
                ready=1'b0;	
       end
      3'd2:begin
                SRAM_WE_N = 1'b0 ;
                data = writeData[31:16];
                sramDataBusCtrl = wr_en;
                SRAM_ADDR = address+32'd1;  
                ready=1'b0; 
            end
       3'd3: begin 
				SRAM_ADDR = address;
				readData = SRAM_DQ;
				ready=1'b0; 
			end
			
      3'd4:begin
			SRAM_ADDR = address + 32'd1;
			if(rd_en)
				readData = {SRAM_DQ,readData[15:0]};
			//readData = SRAM_DQ;
			ready = 1'b0;
	    end
	  
      3'd5:begin 
			//if(rd_en)
				//readData = {SRAM_DQ,readData[15:0]};
			ready = 1'b0;
			SRAM_WE_N = 1'b1;
	  end
	  
      3'd6:begin 
                ready=1'b0;
            end
      3'd7:begin 
                ready =1'b1;
      end 
    endcase
  end	
endmodule
