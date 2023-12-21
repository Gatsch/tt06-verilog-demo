`timescale 1ns/1ns
`include "i2c_led.v"

module i2c_tb;

	reg rst_i = 1'b0;
	reg clk_i = 1'b0;
	reg scl_i = 1'b0;
	wire scl_o;
	reg sda_i = 1'b0;
	wire sda_o;
	wire led_o;
	
	localparam I2CCYCLE = 10000;
	localparam I2CHALFCYCLE = I2CCYCLE/2;
	
	i2c_led 
		#(
		.ADDRESS(7'h4A),
		.LED_CNT(3)
		)
		i2c_led_dut (
			.scl_i(scl_i),
			.scl_o(scl_o),
			.sda_i(sda_i),
			.sda_o(sda_o),
			.led_o(led_o),
			.clk(clk_i),
			.reset(rst_i)
		);
		
	always #20 clk_i  = ~clk_i;
	
	always #I2CHALFCYCLE scl_i = ~scl_i;
	
	initial begin 
		$dumpfile("tb.vcd");
		$dumpvars;
		i2c_led_dut.leddata = 0;
		
		#50 rst_i = 1'b1;
		#50 rst_i = 1'b0;
		
		#2400 sda_i = 1'b1;
		#I2CHALFCYCLE sda_i = 1'b0; //start
		
		//ADDRESS
		#I2CHALFCYCLE sda_i = 1'b1;
		#I2CCYCLE sda_i = 1'b0;
		#I2CCYCLE sda_i = 1'b0;
		#I2CCYCLE sda_i = 1'b1;
		#I2CCYCLE sda_i = 1'b0;
		#I2CCYCLE sda_i = 1'b1;
		#I2CCYCLE sda_i = 1'b0;
		#I2CCYCLE sda_i = 1'b0; //1 read 0 write
		
		#I2CCYCLE;
		//BYTE 1
		#I2CCYCLE sda_i = 1'b0;
		#I2CCYCLE sda_i = 1'b1;
		#I2CCYCLE sda_i = 1'b1;
		#I2CCYCLE sda_i = 1'b1;
		#I2CCYCLE sda_i = 1'b0;
		#I2CCYCLE sda_i = 1'b0;
		#I2CCYCLE sda_i = 1'b0;
		#I2CCYCLE sda_i = 1'b1;
		
		#I2CCYCLE;
		//BYTE 2
		#I2CCYCLE sda_i = 1'b1;
		#I2CCYCLE sda_i = 1'b0;
		#I2CCYCLE sda_i = 1'b1;
		#I2CCYCLE sda_i = 1'b0;
		#I2CCYCLE sda_i = 1'b0;
		#I2CCYCLE sda_i = 1'b0;
		#I2CCYCLE sda_i = 1'b1;
		#I2CCYCLE sda_i = 1'b1;
		
		#I2CCYCLE;
		//BYTE 3
		#I2CCYCLE sda_i = 1'b0;
		#I2CCYCLE sda_i = 1'b1;
		#I2CCYCLE sda_i = 1'b1;
		#I2CCYCLE sda_i = 1'b1;
		#I2CCYCLE sda_i = 1'b1;
		#I2CCYCLE sda_i = 1'b0;
		#I2CCYCLE sda_i = 1'b0;
		#I2CCYCLE sda_i = 1'b0;
		
		#I2CCYCLE;
		#I2CCYCLE;
		#I2CHALFCYCLE sda_i = 1'b1; //stop
		#I2CHALFCYCLE sda_i = 1'b0;
		
		#200000 $finish;
	end
endmodule
