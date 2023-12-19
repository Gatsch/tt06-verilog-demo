`default_nettype none

module tt_um_i2c #( parameter MAX_COUNT = 24'd10_000_000 ) (
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

	wire sda_o;
	wire sda_i = uio_in[0];
	assign uio_out[0] = 1'b0;
	assign uio_oe[0] = ~sda_o;
	
	wire scl_o;
	wire scl_i = uio_in[1];
	assign uio_out[1] = 1'b0;
	assign uio_oe[1] = ~scl_o;

    wire reset = ! rst_n;
    
    
    
    i2c 
		#()
		i2c_dut (
			.scl_i(scl_i),
			.scl_o(scl_o),
			.sda_i(sda_i),
			.sda_o(sda_o),
			.clk(clk),
			.reset(reset)
		);
    
  

    

    // instantiate segment display

endmodule
