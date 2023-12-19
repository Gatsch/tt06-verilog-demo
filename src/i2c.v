`default_nettype none

module i2c (
	input scl_i,
	output wire scl_o,	//needed?
	input wire sda_i,
	output wire sda_o,
	input wire clk,
	input wire reset
);

	reg last_scl_i;
	wire scl_posedge = scl_i & ~last_scl_i;
		
	reg last_sda_i;
	wire sda_posedge = sda_i & ~last_sda_i;
	wire sda_negedge = ~sda_i & last_sda_i;
	
	wire start_signal = scl_i & sda_negedge;
	wire stop_signal = scl_i & sda_posedge;
	
	localparam Data_size = 8;
	reg [Data_size-1:0]data;
	reg [2:0]data_cnt = 3'b000;
	
	
	localparam Size = 2;
	localparam Idle = 2'b00;
	localparam Start = 2'b01;
	localparam Address = 2'b11;
	localparam Done = 2'b10;
	reg [Size-1:0]state;
	reg [Size-1:0]next_state;

	always @(posedge clk) begin
		if (reset) begin
			state <= Start;
            
        end else begin
        	last_scl_i <= scl_i;
    		last_sda_i <= sda_i;
    		state <= next_state;
        end
    end
	always @(posedge clk) begin
        next_state <= Idle;
    	
    	case(state)
			Idle: begin
				if (start_signal) begin
					next_state <= Address;
				end else begin
					next_state <= Idle;
				end
			end
			Address: begin
				if (data_cnt < Data_size) begin
					if (scl_posedge) begin
						data <= data<<1;
						data[0] <= sda_i;
						next_state <= Address;
					end
				end else begin
					next_state <= Idle;
				end
			end
			default:;
		endcase
    end
endmodule
