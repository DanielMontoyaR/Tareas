module FSM_tb;

// Parameters
parameter CLK_PERIOD = 10; // Clock period in time units

// Signals
reg clk = 0;        // Clock signal
reg rst = 1;        // Reset signal (active high)
reg press = 0;      // Input signal for button press
wire [7:0] err;     // Output error signal
wire [7:0] count;   // Output count signal

// Instantiate the module under test
FSM dut (
    .clk(clk),
    .press(press),
	 .rst(rst),
    .err(err),
    .count(count)
);

// Clock generation
always #((CLK_PERIOD / 2)) clk = ~clk;

// Stimulus
initial begin
	
	rst=1;
	press = 0;
	#20
	
	rst = 0;
	press = 0;
	#20
	
	rst=0;
	press=1;
	#20
	
	rst= 0;
	press = 0;
	#1100
	
	rst= 1;
	press = 0;
	#20
	
	rst= 0;
	press = 1;
	
end

endmodule
