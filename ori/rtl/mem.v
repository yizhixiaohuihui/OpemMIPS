/*
 * @Author: ywh
 * @Description: simply sent result in executeStage to writeBackStage; 
 *						because oriInstruction not need access memerary
 * @Date: 2024-04-10 14:31:35
 */

`include "../rtl/defines.v"

module mem(
	input wire							rst,
	
	// message from executeStage
	input wire[`RegAddrBus]     wd_i,
	input wire                    		wreg_i,
	input wire[`RegBus]			   wdata_i,
	
	// result in accessStage
	output reg[`RegAddrBus]     wd_o,
	output reg                   		wreg_o,
	output reg[`RegBus]			   wdata_o
	
);

	
	always @ (*) begin
		if(rst == `RstEnable) begin
			wd_o <= `NOPRegAddr;
			wreg_o <= `WriteDisable;
		  	wdata_o <= `ZeroWord;
		end else begin
		  	wd_o <= wd_i;
			wreg_o <= wreg_i;
			wdata_o <= wdata_i;
		end   
	end      
			
endmodule