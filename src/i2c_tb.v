`timescale 1ns/1ns
`include "i2c.v"

module i2c_tb;

	reg rst_i = 1'b0;
	reg clk_i = 1'b0;
	reg scl_i = 1'b0;
	wire scl_o = 1'b0;
	reg sda_i = 1'b0;
	wire sda_o = 1'b0;
	
	i2c 
		i2c_dut (
			.scl_i(scl_i),
			.scl_o(scl_o),
			.sda_i(sda_i),
			.sda_o(sda_o),
			.clk(clk_i),
			.reset(rst_i)
		);
		
	always #1 clk_i  = ~clk_i;
	
	always #20 scl_i = ~scl_i;
	
	initial begin 
		$dumpfile("tb.vcd");
		$dumpvars;
		/*
		#15 scl_i = 1'b1;
		#25 scl_i = 1'b0;
		#15 sda_i = 1'b1;
		#25 sda_i = 1'b0;
		
		#35 scl_i = 1'b1;
		#45 sda_i = 1'b1;
		#55 sda_i = 1'b0;
		#60 $finish;
		*/
		
		#10 sda_i = 1'b1;
		#20 sda_i = 1'b0; //start
		
		//20 high 40 low 60 high 80 low
		
		#20  sda_i = 1'b1;
		#40  sda_i = 1'b0;
		#40  sda_i = 1'b0;
		#40 sda_i = 1'b1;
		#40 sda_i = 1'b0;
		#40 sda_i = 1'b1;
		#40 sda_i = 1'b1;
		#40 sda_i = 1'b0;
		#40 $finish;
	end
endmodule
