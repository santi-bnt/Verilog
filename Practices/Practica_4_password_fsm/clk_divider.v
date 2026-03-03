module clk_divider #(parameter FREQ= 5)(
	input clk,
	input rst, 
	output reg clk_div
	); 
	
	reg[31:0]count;

parameter CLK_FREQ= 50_000_000;

parameter ConstantNumber= (CLK_FREQ/(2*FREQ));

always@(posedge clk or posedge rst)
begin 
	if(rst==1) 
		count<=32'b0; 
	else if (count==ConstantNumber-1)
		count<=32'b0; 
	else 
		count<=count+1;
end

always@(posedge  clk or posedge rst)// ¡DE LEY!: si en un always usas posegde en el otro también en el otro 
	begin  
	if(rst==1) //checar los reset siempre
		clk_div<=0; 
	else if(count==ConstantNumber-1)
		clk_div<=~clk_div;
end 
endmodule
