`default_nettype none
`ifndef __COUNTER__
`define __COUNTER__

module tt_um_counter
#(
	parameter BW = 8
)(
	input clk_i,
	input rst_i,
	output wire [BW-1:0] counter_val_o
);

	reg [BW-1:0] counter_val;
	
	assign counter_val_o = counter_val;
	
	always @(posedge clk_i) begin
		if(rst_i == 1'b1) begin
			counter_val <= {BW{1'b0}};
		end else begin
			counter_val <= counter_val + {{(BW-1){1'b0}}, 1'b1};
		end
	end
	
endmodule
	

`endif
`default_nettype wire
