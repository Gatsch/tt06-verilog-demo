`default_nettype none

module i2c #(
	parameter ADDRESS = 7'h69
)(
	input scl_i,
	output wire scl_o,	//needed?
	input wire sda_i,
	output wire sda_o,
	input wire clk,
	input wire reset
);

	reg scl = 1'b1;
	reg last_scl = 1'b1;
	wire scl_posedge = scl & ~last_scl;
	wire scl_negedge = ~scl & last_scl;
	reg scl_out = 1'b1;
	
	reg sda = 1'b1;
	reg last_sda = 1'b1;
	wire sda_posedge = sda & ~last_sda;
	wire sda_negedge = ~sda & last_sda;
	reg sda_out = 1'b1;
	
	wire start_signal = scl_i & sda_negedge;
	wire stop_signal = scl_i & sda_posedge;
	
	localparam Data_size = 8;
	reg [Data_size-1:0]data;
	reg [3:0]data_cnt = 4'b000;
	
	reg read = 1'b0;
	
	
	localparam Size = 3;
	localparam Idle = 3'b000;
	localparam Address = 3'b001;
	localparam ReadOrWrite = 3'b010;
	localparam PrepAck = 3'b011;
	localparam Ack = 3'b100;
	localparam Write = 3'b101;
	reg [Size-1:0]state = 3'b000;
	reg [Size-1:0]next_state = 3'b000;

	always @(posedge clk) begin
		if (reset) begin
			state <= Idle;
            
        end else begin
        	scl <= scl_i;
        	sda <= sda_i;
        	last_scl <= scl;
    		last_sda <= sda;
    		state <= next_state;
        end
    end
	always @(state or start_signal or scl_posedge or scl_negedge) begin
    	
    	case(state)
			Idle: begin
				if (start_signal) begin
					next_state <= Address;
				end else begin
					next_state <= Idle;
				end
			end
			Address: begin
				if (data_cnt < Data_size-1) begin
					if (scl_posedge) begin
						data <= data<<1;
						data[0] <= sda;
						data_cnt <= data_cnt + 4'b0001;
					end
					next_state <= Address;
				end else begin
					next_state <= ReadOrWrite;
				end
			end
			ReadOrWrite: begin
				if (scl_posedge) begin
					read <= sda;
					data[Data_size-1] <= 0;
					if (data[Data_size-2:0] == ADDRESS) begin
						next_state <= PrepAck;
					end else begin
						next_state <= Idle;
					end
				end else begin
					next_state <= ReadOrWrite;
				end
			end
			PrepAck: begin
					if (scl_negedge) begin
						sda_out <= 1'b0;
						next_state <= Ack;
					end else begin
						next_state <= PrepAck;
					end
				
			end
			Ack: begin
				if (scl_negedge) begin
					sda_out <= 1'b1;
					if (read) begin
						next_state <= Idle;
					end else begin
						next_state <= Write;
					end
				end else begin
					next_state <= Ack;
				end
			end
			Write: begin
				next_state <= Write;
			end
			default:
        		next_state <= Idle;
		endcase
    end
    assign sda_o = sda_out;
    assign scl_o = scl_out;
endmodule
