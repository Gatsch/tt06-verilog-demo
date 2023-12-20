`default_nettype none
`include "i2c.v"
`include "led.v"

module i2c_led #(
	parameter ADDRESS = 7'h69,
	parameter LED_CNT = 3
)(
	input wire scl_i,
	output wire scl_o,
	input wire sda_i,
	output wire sda_o,
	output wire led_o,
	input wire clk,
	input wire reset
);

	
	localparam DATAWIDTH = LED_CNT*3*8;


	wire [7:0] data;
	wire data_valid;
	wire start;
	wire stop;
	reg [DATAWIDTH-1:0]leddata;
	
	i2c 
		#(.ADDRESS(ADDRESS))
		i2c_dut (
			.scl_i(scl_i),
			.scl_o(scl_o),
			.sda_i(sda_i),
			.sda_o(sda_o),
			.clk(clk),
			.reset(reset),
			.data(data),
			.data_valid_o(data_valid),
			.start(start),
			.stop(stop)
		);


led 
		#(.LED_CNT(LED_CNT))
		led_dut (
			.data(data),
			.led_o(led_o),
			.clk(clk),
			.reset(reset)
		);

endmodule
