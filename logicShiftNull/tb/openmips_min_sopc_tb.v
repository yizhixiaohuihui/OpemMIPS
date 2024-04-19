/*
 * @Author: ywh
 * @Description: test bench
 * @Date: 2024-04-10 16:22:57
 */

`include "../rtl/defines.v"
`timescale 1ns/1ps

module openmips_min_sopc_tb();

  reg CLOCK_50;
  reg rst;
  
       
  initial begin
    CLOCK_50 = 1'b0;
    // cycle is 20ns: 50Mhz
    forever #10 CLOCK_50 = ~CLOCK_50;
  end
      
  initial begin
    rst = `RstEnable;
    
    // min sopc start run
    #195 rst= `RstDisable;
    #1000 $stop;
  end
       
  openmips_min_sopc openmips_min_sopc0(
		.clk(CLOCK_50),
		.rst(rst)	
	);

  initial	begin
	    $fsdbDumpfile("tb.fsdb"); // generate "tb.fsdb"
	    // $fsdbDumpvars(0, openmips_min_sopc_tb,  "+mda"); // dump tb and dut ports, "+mda"->dump mem
	    $fsdbDumpvars(0, openmips_min_sopc_tb); // dump tb and dut ports
      $fsdbDumpMDA( ); // dump mem

end

endmodule