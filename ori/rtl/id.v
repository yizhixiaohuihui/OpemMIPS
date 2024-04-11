/*
 * @Author: ywh
 * @Description: decode instructions 
 * @Date: 2024-04-09 22:59:26
 */

`include "../rtl/defines.v"

module id(

	input wire								 rst,
	input wire[`InstAddrBus]		  pc_i,
	input wire[`InstBus]          		 inst_i,

	// readed regfile's data
	input wire[`RegBus]           		reg1_data_i,
	input wire[`RegBus]           		reg2_data_i,

	// ouput to Regfile's message
	output reg                    			reg1_read_o,	// Regfile reg1's ReadEnable
	output reg                    			reg2_read_o,    // Regfile reg2's ReadEnable
	output reg[`RegAddrBus]       	reg1_addr_o,
	output reg[`RegAddrBus]       	reg2_addr_o, 	      
	
	// sent Execution stage message
	output reg[`AluOpBus]         	  aluop_o,
	output reg[`AluSelBus]        	  alusel_o,
	output reg[`RegBus]           	   reg1_o,
	output reg[`RegBus]           	   reg2_o,
	output reg[`RegAddrBus]       	wd_o,
	output reg                    		    wreg_o
);
	// instructions code
    wire[5:0] op = inst_i[31:26]; // ori: judge 26-31bit can judge ori instruction
    wire[4:0] op2 = inst_i[10:6];
    wire[5:0] op3 = inst_i[5:0];
    wire[4:0] op4 = inst_i[20:16];

	// store immediate num that execute instructions need
    reg[`RegBus]	imm;

	// instruction is valid or not
    reg instvalid;
  
	// 1. decode instructions
	always @ (*) begin	
		if (rst == `RstEnable) begin
			aluop_o <= `EXE_NOP_OP;
			alusel_o <= `EXE_RES_NOP;
			wd_o <= `NOPRegAddr;
			wreg_o <= `WriteDisable;
			instvalid <= `InstValid;
			reg1_read_o <= 1'b0;
			reg2_read_o <= 1'b0;
			reg1_addr_o <= `NOPRegAddr;
			reg2_addr_o <= `NOPRegAddr;
			imm <= 32'h0;			
	    end 
		else begin
			aluop_o <= `EXE_NOP_OP;
			alusel_o <= `EXE_RES_NOP;
			wd_o <= inst_i[15:11];
			wreg_o <= `WriteDisable;
			instvalid <= `InstInvalid;	   
			reg1_read_o <= 1'b0;
			reg2_read_o <= 1'b0;
			reg1_addr_o <= inst_i[25:21];	// rs register's address
			reg2_addr_o <= inst_i[20:16];	// rt register's address
			imm <= `ZeroWord;			
		    case (op)
		  		`EXE_ORI:			begin   // judge is ori ins 
		  			wreg_o <= `WriteEnable;		// ori need write in destination register
					aluop_o <= `EXE_OR_OP;	// aiuop is or operation
		  			alusel_o <= `EXE_RES_LOGIC; // logic operation
					reg1_read_o <= 1'b1;	// only need read rs
					reg2_read_o <= 1'b0;	// immediate num not need read from reg
					imm <= {16'h0, inst_i[15:0]}; // extend immediate num to unsinged 32 bits		
					wd_o <= inst_i[20:16]; // rt: destination register's address to write 
					instvalid <= `InstValid;	
		  		end 							 
		    	default:			begin
		    	end
		  endcase		  //case op			
		end       //if
	end         //always
	
	// 2. choose source num2
	always @ (*) begin
		if(rst == `RstEnable) begin
			reg1_o <= `ZeroWord;
	  	end 
		else if(reg1_read_o == 1'b1) begin
	  		reg1_o <= reg1_data_i; // rs
	  	end 
		else if(reg1_read_o == 1'b0) begin
	  		reg1_o <= imm;
	  	end 
		else begin
	    	reg1_o <= `ZeroWord;
	  	end
	end
	
	// 3. choose source num2 
	always @ (*) begin
		if(rst == `RstEnable) begin
			reg2_o <= `ZeroWord;
	  	end 
		else if(reg2_read_o == 1'b1) begin
	  		reg2_o <= reg2_data_i;	// rt
	  	end 
		else if(reg2_read_o == 1'b0) begin
	  		reg2_o <= imm;
	  	end 
		else begin
	    	reg2_o <= `ZeroWord;
	  	end
	end

endmodule