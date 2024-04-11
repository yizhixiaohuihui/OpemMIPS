/*
 * @Author: ywh
 * @Description: instruction Romemary
 * @Date: 2024-04-10 15:41:23
 */

`include "../rtl/defines.v"

module inst_rom(

	input wire ce,
	input wire[`InstAddrBus] addr, 
	output reg[`InstBus] inst 
	
);

	reg[`InstBus]  inst_mem[0:`InstMemNum-1];

	// use file "inst_rom.data" to init instRom
	initial $readmemh ( "../other/inst_rom.data", inst_mem );

	always @ (*) begin
		if (ce == `ChipDisable) begin
			inst <= `ZeroWord;
	  	end 
	  	else begin
			// inst_mem Index = addr/4; because address is 32bits->32/8=4
		  	inst <= inst_mem[addr[`InstMemNumLog2+1:2]];
		end
	end

endmodule