`default_nettype none

module led #(
	parameter CLK_SPEED = 25_000_000,
	parameter LED_CNT = 3,
	parameter CHANNELS = 3,
	parameter BITPERCHANNEL = 8,
	parameter PERIOD = 0.00000125,
	parameter HIGH0 = 0.0000004,
	parameter HIGH1 = 0.0000008,
	parameter REFRESH_DURATION = 0.00005
)(
	input wire [LED_CNT*CHANNELS*BITPERCHANNEL-1:0]data,
	output wire led_o,
	input wire clk,
	input wire reset
);
	
	
	localparam DATAWIDTH = LED_CNT*CHANNELS*BITPERCHANNEL;
	localparam DATACOUNTWIDTH = $clog2(DATAWIDTH);
	
	localparam REFRESH_PERIOD32 = $rtoi(CLK_SPEED*REFRESH_DURATION);
	localparam COUNT_PERIOD32 = $rtoi(CLK_SPEED*PERIOD);
	localparam COUNT_0H32 =  $rtoi(CLK_SPEED*HIGH0);
	localparam COUNT_1H32 =  $rtoi(CLK_SPEED*HIGH1);
	
	localparam COUNTWIDTH = $clog2(REFRESH_PERIOD32);
	localparam REFRESH_PERIOD = REFRESH_PERIOD32[COUNTWIDTH-1:0];
	localparam COUNT_PERIOD = COUNT_PERIOD32[COUNTWIDTH-1:0];
	localparam COUNT_0H = COUNT_0H32[COUNTWIDTH-1:0];
	localparam COUNT_1H = COUNT_1H32[COUNTWIDTH-1:0];
	
	localparam Refresh = 1'b0;
	localparam Write = 1'b1;
	
	reg [DATACOUNTWIDTH-1:0]datacounter, next_datacounter;
	reg [COUNTWIDTH-1:0]counter, next_counter;
	reg state, next_state;
	reg led_out;

	always @(posedge clk) begin
		if (reset) begin
			state <= 0;
			counter <= 0;
			datacounter <= 0;
		end else begin
			counter <= next_counter;
			datacounter <= next_datacounter;
			state <= next_state;
		end
		
	end
	
	always @(counter or datacounter) begin
		next_counter <= counter;
		next_datacounter <= datacounter;
		next_state <= state;
		led_out <= 1'b0;
		case (state) 
			Refresh: begin
				if (counter < REFRESH_PERIOD) begin
					next_counter <= counter + 1;
				end else begin
					next_counter <= 0;
					next_state <= Write;
				end
			end
			Write: begin
				if (counter < COUNT_PERIOD-1'b1) begin
					next_counter <= counter + 1;
				end else begin
					next_counter <= 0;
					if (datacounter < DATAWIDTH-1'b1) begin
						next_datacounter <= datacounter + 1;
					end else begin
						next_datacounter <= 0;
						next_state <= Refresh;
					end
				end
				if (counter < ((data[datacounter])?COUNT_1H:COUNT_0H)) begin
					led_out <= 1'b1;
				end else begin
					led_out <= 1'b0;
				end
			end
		endcase
	end
	assign led_o = led_out;
endmodule
