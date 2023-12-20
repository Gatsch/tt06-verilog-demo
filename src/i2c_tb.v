`timescale 1ns/1ns
`include "i2c.v"

module i2c_tb;

	reg rst_i = 1'b0;
	reg clk_i = 1'b0;
	reg scl_i = 1'b0;
	wire scl_o = 1'b0;
	reg sda_i = 1'b0;
	wire sda_o = 1'b0;
	wire [7:0] data;
	wire data_valid;
	wire start;
	wire stop;
	
	i2c 
		#(.ADDRESS(7'h4A))
		i2c_dut (
			.scl_i(scl_i),
			.scl_o(scl_o),
			.sda_i(sda_i),
			.sda_o(sda_o),
			.clk(clk_i),
			.reset(rst_i),
			.data(data),
			.data_valid_o(data_valid),
			.start(start),
			.stop(stop)
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
		#2 rst_i = 1'b1;
		#2 rst_i = 1'b0;
		
		#6 sda_i = 1'b1;
		#20 sda_i = 1'b0; //start
		
		//20 high 40 low 60 high 80 low
		
		//ADDRESS
		#20 sda_i = 1'b1;
		#40 sda_i = 1'b0;
		#40 sda_i = 1'b0;
		#40 sda_i = 1'b1;
		#40 sda_i = 1'b0;
		#40 sda_i = 1'b1;
		#40 sda_i = 1'b0;
		#40 sda_i = 1'b0; //1 read 0 write
		
		#40;
		//BYTE 1
		#40 sda_i = 1'b0;
		#40 sda_i = 1'b1;
		#40 sda_i = 1'b1;
		#40 sda_i = 1'b1;
		#40 sda_i = 1'b0;
		#40 sda_i = 1'b0;
		#40 sda_i = 1'b0;
		#40 sda_i = 1'b1;
		
		#40;
		//BYTE 2
		#40 sda_i = 1'b1;
		#40 sda_i = 1'b0;
		#40 sda_i = 1'b1;
		#40 sda_i = 1'b0;
		#40 sda_i = 1'b1;
		#40 sda_i = 1'b0;
		#40 sda_i = 1'b0;
		#40 sda_i = 1'b0;
		
		#40;
		//NEW START
		#40 sda_i = 1'b1;
		#40 sda_i = 1'b0;
		#40 sda_i = 1'b0;
		#40 sda_i = 1'b1;
		#20 sda_i = 1'b0;
		
		//ADDRESS
		#20 sda_i = 1'b1;
		#40 sda_i = 1'b0;
		#40 sda_i = 1'b0;
		#40 sda_i = 1'b1;
		#40 sda_i = 1'b0;
		#40 sda_i = 1'b1;
		#40 sda_i = 1'b0;
		#40 sda_i = 1'b0;
		
		#40;
		//BYTE1
		#40 sda_i = 1'b1;
		#40 sda_i = 1'b0;
		#40 sda_i = 1'b1;
		#40 sda_i = 1'b0;
		#40 sda_i = 1'b1;
		#40 sda_i = 1'b0;
		#40 sda_i = 1'b0;
		#40 sda_i = 1'b0;
		
		
		#80 $finish;
	end
endmodule
