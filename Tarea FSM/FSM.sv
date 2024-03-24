module FSM(input clk, press, rst, 
				output reg [7:0] err, 
				output reg [7:0] count);

logic [1:0] state, next_state;
reg [1:0] count_cycle;
reg [7:0] count_reg;
reg [7:0] error_reg;


initial begin
	state = 2'b00;
	error_reg = 8'h00;
	count_reg = 8'h00;
	count_cycle = 2'b00;
end




//Actual state logic
always@(posedge clk, posedge rst)
begin
	if (rst) begin
		state = 2'b00;
	end
	else state = next_state;
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
				next_state = 2'b00;
			end
		end
		2'b10:
		begin
			next_state = 2'b00;
		end
		
		2'b11:
		begin
		if (rst) begin
			next_state = 2'b00;
		end else begin
			next_state = 2'b11;
			
		end
		end
		default: next_state = 2'b00;
	endcase
end

always @(*) begin
	count = count_reg;
	err = error_reg;
	count_cycle =  (state == 2'b10)*(count_cycle + (state == 2'b01));
	count_reg = count_reg+(state == 2'b10);
	error_reg = (state==2'b11)*8'hFF;
end

endmodule
