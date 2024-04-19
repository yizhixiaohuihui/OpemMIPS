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
	// save shift op result
	reg[`RegBus] shiftres;

	
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
				`EXE_ORI_OP:			begin
					logicout <= reg1_i | reg2_i;
				end
				`EXE_LUI_OP:			begin
					logicout <= reg1_i | reg2_i;
				end
				`EXE_AND_OP:		begin
					logicout <= reg1_i & reg2_i;
				end
				`EXE_ANDI_OP:		begin
					logicout <= reg1_i & reg2_i;
				end
				`EXE_NOR_OP:		begin
					logicout <= ~(reg1_i |reg2_i);
				end
				`EXE_XOR_OP:		begin
					logicout <= reg1_i ^ reg2_i;
				end
				`EXE_XORI_OP:		begin
					logicout <= reg1_i ^ reg2_i;
				end
				default:				begin
					logicout <= `ZeroWord;
				end
			endcase
		end    
	end      
	always @ (*) begin
		if(rst == `RstEnable) begin
			shiftres <= `ZeroWord;
		end 
		else begin
			case (aluop_i)
				`EXE_SLL_OP:			begin
					shiftres <= reg2_i << reg1_i[4:0] ;
				end
				`EXE_SLLV_OP:			begin
					shiftres <= reg2_i << reg1_i[4:0] ;
				end
				`EXE_SRL_OP:		begin
					shiftres <= reg2_i >> reg1_i[4:0];
				end
				`EXE_SRLV_OP:		begin
					shiftres <= reg2_i >> reg1_i[4:0];
				end
				`EXE_SRA_OP:		begin
					shiftres <= ({32{reg2_i[31]}} << (6'd32-{1'b0, reg1_i[4:0]})) 
									| reg2_i >> reg1_i[4:0];
				end
				`EXE_SRAV_OP:		begin
					shiftres <= ({32{reg2_i[31]}} << (6'd32-{1'b0, reg1_i[4:0]})) 
									| reg2_i >> reg1_i[4:0];
				end
				default:				begin
					shiftres <= `ZeroWord;
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
			`EXE_RES_SHIFT:		begin
	 			wdata_o <= shiftres;
	 		end	 
			default:					begin
				wdata_o <= `ZeroWord;
			end
		endcase
	end	

endmodule