/*
 * @Author: ywh
 * @Description: 暂时保存取指阶段取得的指令以及对应的指令地址，并在下一个时钟传递到译码阶段。
 * @Date: 2024-04-09 17:20:34
 * @LastEditors: ywh
 * @LastEditTime: 2024-04-09 17:29:24
 */

`include "../rtl/defines.v"

module if_id(
	input	wire				 		clk,
	input wire							rst,
	input wire[`InstAddrBus]	 if_pc,		  // 取指阶段取得的指令对应的地址
	input wire[`InstBus]       		if_inst,	// 取指阶段取得的指令
	output reg[`InstAddrBus] 	 id_pc,		// 译码阶段的指令对应的地址
	output reg[`InstBus] 			id_inst   // 译码阶段的指令
);

	always @ (posedge clk) begin
		if (rst == `RstEnable) begin
			id_pc <= `ZeroWord;
			id_inst <= `ZeroWord;
	    end 
	    else begin	// 其余时刻向下传递取指阶段的值
		  id_pc <= if_pc;
		  id_inst <= if_inst;
		end
	end
endmodule