/*
 * @Author: ywh
 * @Description: op result in accessStage send to writeBackStage at next clk
 * @Date: 2024-04-10 15:05:28
 */

`include "../rtl/defines.v"

module mem_wb(

	input	wire						clk,
	input wire							rst,
	
	// accessStage result 
	input wire[`RegAddrBus]     mem_wd,
	input wire                    		mem_wreg,
	input wire[`RegBus]			   mem_wdata,

	// message sent to writeBackStage
	output reg[`RegAddrBus]    wb_wd,
	output reg                   	   wb_wreg,
	output reg[`RegBus]			  wb_wdata	       
	
);


	always @ (posedge clk) begin
		if(rst == `RstEnable) begin
			wb_wd <= `NOPRegAddr;
			wb_wreg <= `WriteDisable;
		  wb_wdata <= `ZeroWord;	
		end else begin
			wb_wd <= mem_wd;
			wb_wreg <= mem_wreg;
			wb_wdata <= mem_wdata;
		end    //if
	end      //always
			

endmodule