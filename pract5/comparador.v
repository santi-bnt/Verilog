module comparador(
	input clk,
	input rst,
	input [7:0] in,
	output reg out
);

wire [16:0] count;
reg [16:0] comp;


counter countersin(.rst(rst),.clk(clk),.counter(count));

always @(posedge clk or posedge rst) begin 
	if (rst) begin
        
        comp <= 0;
        out  <= 0;
    end else begin
		comp = ((5000/180)*in) + 5000;
    if (count < comp)
	 	out <= 1;
	else
		out <= 0;
	end
	
end



endmodule