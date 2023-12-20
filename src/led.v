`default_nettype none

module led #(
	parameter CLK_SPEED = 25_000_000,
	parameter LED_CNT = 3
)(
	input wire [LED_CNT*3*8-1:0]data,
	output wire led_o,
	input wire clk,
	input wire reset
);
	localparam DATAWIDTH = LED_CNT*3*8;
	localparam DATACOUNTWIDTH = $clog2(DATAWIDTH);
	localparam COUNT_PERIOD = $rtoi(CLK_SPEED*0.00000125);
	localparam COUNT_0H =  $rtoi(CLK_SPEED*0.0000004);
	localparam COUNT_1H =  $rtoi(CLK_SPEED*0.0000008);
	localparam COUNTWIDTH = $clog2(COUNT_PERIOD);
	reg [DATACOUNTWIDTH-1:0]datacounter;
	reg [COUNTWIDTH-1:0]counter;

	reg led_out;

	always @(posedge clk) begin
		if (reset) begin
			counter <= 0;
			datacounter <= 0;
		end else begin
			if (counter < COUNT_PERIOD-1) begin
				counter <= counter + 1;
			end else begin
				counter <= 0;
				if (datacounter < DATAWIDTH-1) begin
					datacounter <= datacounter + 1;
				end else begin
					datacounter <= 0;
				end
			end
		end
		
	end
	
	always @(counter) begin
		if (counter < ((data[datacounter])?COUNT_1H:COUNT_0H)) begin
			led_out <= 1'b1;
		end else begin
			led_out <= 1'b0;
		end
	end
	assign led_o = led_out;
endmodule
