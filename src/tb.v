`timescale 1ns/1ns
`include "tt_um_counter.v"

module tb;

	parameter BW = 3;
	reg rst_i = 1'b1;
	reg clk_i = 1'b0;
	wire [BW-1:0] cnt_val;
	
	tt_um_i2c 
		#()
		counter_dut (
			.clk_i(clk_i),
			.rst_i(rst_i),
			.counter_val_o(cnt_val)
		);
		
	always #5 clk_i  = ~clk_i;
	
	initial begin 
		$dumpfile("tb.vcd");
		$dumpvars;
		#50 rst_i = 1'b0;
		#200 $finish;
	end
endmodule
