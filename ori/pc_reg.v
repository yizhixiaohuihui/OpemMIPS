/*
 * @Author: ywh
 * @Description: 给出指令地址
 * @Date: 2024-04-09 16:09:12
 */
 
`include "defines.v"

module pc_reg(
	input	wire							clk, 
	input wire								rst,
	output reg[`InstAddrBus]		pc,	// 要读取的指令地址
	output reg                    			ce // ָ指令存储器使能信号
);

	always @ (posedge clk) begin
		if (rst == `RstEnable) begin
			ce <= `ChipDisable;					// 复位的时候指令存储器禁用
		end 
		else begin
			ce <= `ChipEnable;					// 复位结束后指令存储器使能
		end
	end

	always @ (posedge clk) begin
		if (ce == `ChipDisable) begin
			pc <= 32'h00000000;
		end 
		else begin
	 		pc <= pc + 4'h4;					// pc+4指向下一条指令地址（一条指令32位对应4字节）
		end
	end
endmodule