/*
 * @Author: ywh
 * @Description: execute operation
 * @Date: 2024-04-10 11:06:31
 */

`include "../rtl/defines.v"

module ex(

	input wire										rst,
	
	// message rom decodeStage
	input wire[`AluOpBus]        aluop_i,
	input wire[`AluSelBus]       alusel_i,
	input wire[`RegBus]           reg1_i,
	input wire[`RegBus]           reg2_i,
	input wire[`RegAddrBus]     wd_i,
	input wire                    		wreg_i,

	// execute result
	output reg[`RegAddrBus]     wd_o,
	output reg                    		wreg_o,
	output reg[`RegBus]			   wdata_o
	
);
	// save logic op result
	reg[`RegBus] logicout;

	
	// 1. according aluop_i to operate
	always @ (*) begin
		if(rst == `RstEnable) begin
			logicout <= `ZeroWord;
		end 
		else begin
			case (aluop_i)
				`EXE_OR_OP:			begin
					logicout <= reg1_i | reg2_i;
				end
				default:				begin
					logicout <= `ZeroWord;
				end
			endcase
		end    
	end      


	// 2. according alusel_i to choose an op result as last result
	always @ (*) begin
		wd_o <= wd_i;	// detinationReg's address need write 
		wreg_o <= wreg_i; // write reg enable
		case ( alusel_i ) 
			`EXE_RES_LOGIC:		begin
				wdata_o <= logicout; // save op result
			end
			default:					begin
				wdata_o <= `ZeroWord;
			end
		endcase
	end	

endmodule