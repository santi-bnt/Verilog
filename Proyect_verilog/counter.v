module counter#(parameter pwm = 50,
    parameter CLK_FREQ = 50_000_000)(
	input clk,
	input rst,
	output reg [19:0] counter
	
);

clk_divide clock(.rst(rst),.clk(clk_divider));

always @(posedge clk or posedge rst) begin 
    if (rst)
        counter <= 0;
	else if 
			(counter == CLK_FREQ/pwm)
				counter <= 0;
			else 
				counter <= counter +1;
			
end

endmodule

