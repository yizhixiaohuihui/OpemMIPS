/*
 * @Author: ywh
 * @Description: meantime two registers' read operation and a register's write operation
 * @Date: 2024-04-09 22:17:00
 */

`include "../rtl/defines.v"

module regfile(

	input	wire									clk,
	input wire										rst,

	// write port
	input wire										we,
	input wire[`RegAddrBus]					waddr,
	input wire[`RegBus]						   wdata,
	
	// read port 1
	input wire										re1,
	input wire[`RegAddrBus]			  		raddr1,
	output reg[`RegBus]           			  rdata1,
	
	// read port 2
	input wire										re2,
	input wire[`RegAddrBus]			  		raddr2,
	output reg[`RegBus]           			  rdata2
	
);
	// 1. define 32's 32bits registers
	reg[`RegBus]  regs[0:`RegNum-1];

	// 2. write operation
	always @ (posedge clk) begin
		if (rst == `RstDisable) begin
			// we enable and write operation destination register != 0
			if((we == `WriteEnable) && (waddr != `RegNumLog2'h0)) begin
				regs[waddr] <= wdata;
			end
		end
	end
	
	// Notice: read operation is Combinatorial logic
	// 3. read port1's read operation
	always @ (*) begin
		if(rst == `RstEnable) begin
			  rdata1 <= `ZeroWord;
	  	end 
		else if(raddr1 == `RegNumLog2'h0) begin
	  		rdata1 <= `ZeroWord;
	  	end 
		// if read port1 want read register is same as the register to write
	  	else if((raddr1 == waddr) && (we == `WriteEnable) && (re1 == `ReadEnable)) begin
	  	  rdata1 <= wdata;
	  	end 
		else if(re1 == `ReadEnable) begin
	      rdata1 <= regs[raddr1];
	  	end 
		// if read port1 can't be used
		else begin
	      rdata1 <= `ZeroWord;
	  	end
	end

	// 4. read port2's read operation
	always @ (*) begin
		if(rst == `RstEnable) begin
			  rdata2 <= `ZeroWord;
	  	end 
		else if(raddr2 == `RegNumLog2'h0) begin
	  		rdata2 <= `ZeroWord;
	  	end 
		else if((raddr2 == waddr) && (we == `WriteEnable) && (re2 == `ReadEnable)) begin
	  	  rdata2 <= wdata;
	  	end 
		else if(re2 == `ReadEnable) begin
	      rdata2 <= regs[raddr2];
	  	end 
		else begin
	      rdata2 <= `ZeroWord;
	  	end
	end

endmodule