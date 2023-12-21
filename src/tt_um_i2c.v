`default_nettype none

module tt_um_i2c (
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    wire reset = ! rst_n;
	wire sda_o;
	wire sda_i = uio_in[0];
	wire scl_o;
	wire scl_i = uio_in[1];
	wire led_o;
	assign uio_out = 8'b0;
	assign uio_oe[7:2] = 6'b0;
	assign uio_oe[1] = ~sda_o;
	assign uio_oe[0] = ~scl_o;
	assign uo_out[7:1] = 7'b0;
	assign uo_out[0] = led_o;

    
    
    i2c_led 
		#(
		.ADDRESS(7'h4A),
		.LED_CNT(15)
		)
		i2c_led_dut (
			.scl_i(scl_i),
			.scl_o(scl_o),
			.sda_i(sda_i),
			.sda_o(sda_o),
			.led_o(led_o),
			.clk(clk),
			.reset(reset)
		);
   

    

    // instantiate segment display

endmodule
