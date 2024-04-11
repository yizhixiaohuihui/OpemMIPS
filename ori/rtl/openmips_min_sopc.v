/*
 * @Author: ywh
 * @Description: 
 * @Date: 2024-04-10 16:00:58
 */

`include "../rtl/defines.v"

module openmips_min_sopc(

	input wire clk,
	input wire rst
	
);

	//openmips <-> ROM
	wire[`InstAddrBus] inst_addr;
	wire[`InstBus] inst;
	wire rom_ce;
 

	openmips openmips0(
			.clk(clk),
			.rst(rst),
		
			.rom_addr_o(inst_addr),
			.rom_data_i(inst),
			.rom_ce_o(rom_ce)
		
		);
	
	inst_rom inst_rom0(
		.addr(inst_addr),
		.inst(inst),
		.ce(rom_ce)	
	);


endmodule