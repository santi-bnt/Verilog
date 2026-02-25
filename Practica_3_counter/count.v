module count(
	input clk,
	input rst,
	input up_down,
	input load,
	input [6:0] data_in,
	output reg [7:0] counter,
	output reg [7:0] save
);

always @(posedge clk or posedge rst) begin 
    if (rst)
        counter <= 0;
	 else if (load == 0 && data_in == 1)begin
				save <= counter;	
				counter <= save;
			end
		
	 else if (load == 0)begin
				counter <= save;
				end
	
			
	 else if (up_down == 1) 
	 
				begin 
				if (counter <= 0)
            counter <= 100;
				else
            counter <= counter - 1;
				end
	
	else if 
			(counter == 100)
				counter <= 0;
			else 
				counter <= counter +1;
			
end

endmodule
