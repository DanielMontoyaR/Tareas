module FSM(input clk, press, rst, 
				output reg [7:0] err, 
				output reg [7:0] count);

logic [1:0] state, next_state;
reg [5:0] count_cycle;
reg [7:0] count_reg;
reg [7:0] error_reg;


initial begin
	state = 2'b00;
	error_reg = 8'h00;
	count_reg = 8'h00;
	count_cycle = 6'h00;
end




//Actual state logic
always@(posedge clk, posedge rst)
begin
	if (rst) begin//When the reset button is pressed, the FSM will go to the state 00.
		state = 2'b00;
	end
	else state = next_state;
end	


//Next state logic

always@(posedge clk, posedge rst)
begin
	case(state)
		2'b00://Start state
		begin
			if (press) next_state = 2'b10;
			else next_state = 2'b01;
		end
		2'b01://Maintenance button not pressed
		begin
			if (count_cycle == 6'h32) next_state = 2'b11; //Evaluates the count cycle. If it's true, the FSM will enter error 0xFF state
			else begin 
				next_state = 2'b00; //If the count cycle is false, the FSM returns to the start state.
			end
		end
		2'b10://Maintenance button pressed
		begin
			next_state = 2'b00;
		end
		
		2'b11://Error state
		begin
		if (rst) begin//Waits for the manual reset button to be pressed, if it's not the FSM doesn't change the state.
			next_state = 2'b00;
		end else begin
			next_state = 2'b11;
			
		end
		end
		default: next_state = 2'b00;//Default state.
	endcase
end

always @(*) begin//Module that changes the variables used for the machine
	count_cycle =  (!rst)*(state != 2'b10)*(count_cycle + (state == 2'b01));//Resets the count cycle if the maintenance button is pressed
	count_reg = count_reg + (state == 2'b10);//Increases the counter register when the maintenance button is pressed
	error_reg = (state == 2'b11)*8'hFF;//Changes the error register
	count = count_reg;//Updates the maintenance counter.
	err = error_reg;//Updates the error value.
end

endmodule
