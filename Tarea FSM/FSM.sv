module FSM(input clk, press, rst, 
							 output reg [7:0] err, 
							 output reg [7:0] count);

logic [1:0] state, next_state;
reg [1:0] count_cycle;
reg [7:0] count_reg;


initial begin
	state = 2'b00;
	err = 8'h00;
	count_reg = 8'h00;
	count_cycle = 2'b00;
end


//Actual state logic
always@(posedge clk, posedge rst)
begin
	state = next_state;
end	


//Next state logic

always@(posedge clk, posedge rst)
begin
	case(state)
		2'b00:
		begin
			if (press) next_state = 2'b10;
			else next_state = 2'b01;
		end
		2'b01:
		begin
			if (count_cycle == 2'b11) next_state = 2'b11;
			else begin 
				count_cycle <= count_cycle + 1;
				next_state = 2'b00;
				end
		end
		
		2'b10:
		begin
			count_cycle = 2'b00;
			count_reg <= count_reg + 1;
			next_state = 2'b00;
		end
		
		2'b11:
		begin
			if (rst) begin
				err = 8'h00;
				next_state = 2'b00;
			end else begin
				err = 8'hFF;
				next_state = 2'b11;
			end 
		end
		default: next_state = 2'b00;
	endcase
end

always @(*) begin
	count = count_reg;
end

endmodule
		