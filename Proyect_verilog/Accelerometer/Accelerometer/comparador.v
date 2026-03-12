module comparador #(parameter pwm = 50,
    parameter CLK_FREQ = 50_000_000)(
    input clk,
    input rst,

   input signed [19:0] data_x_reg,
   input signed [19:0] data_y_reg,
   input signed [19:0] data_z_reg,
	input garra,
	input selector,
	
	//inputs de memoria 
	input[7:0] angle_x_mem,
	input[7:0] angle_y_mem,
	input[7:0] angle_z_mem,
	input[7:0] angle_g_mem,
	
	
	output [7:0] angle_x,
	output [7:0] angle_y,
	output [7:0] angle_z,
	output [7:0] angle_g,
	 
	 
    output reg out_x,
    output reg out_y,
    output reg out_z,
	 output reg out_g
);

wire [19:0] count;
wire[7:0] angle_x_calc;
wire[7:0] angle_y_calc; 
wire[7:0] angle_z_calc;

reg  [19:0] comp_x;
reg  [19:0] comp_y;
reg  [19:0] comp_z;
reg  [19:0] comp_g;

counter countersin(.rst(rst), .clk(clk), .counter(count));

localparam integer min = ((CLK_FREQ/pwm)*3)/100;
localparam integer max = ((CLK_FREQ/pwm)*12)/100;
localparam integer m   = (max-min)/180;



//conversión de hexadecimal a grados de cada coordanada 
assign angle_x_calc = 90 + (data_x_reg >>> 2);
assign angle_y_calc = 90 + (data_y_reg >>> 2);
assign angle_z_calc = 90 + (data_z_reg >>> 2); 

//compara entre manual y autonomo, de forma que elige cuales datos utilizar, memoria o acelerometro 
//si el selector es = 0 usa el modo manual y si es =1 utiliza el acelerometro

assign angle_x= selector ? angle_x_mem : angle_x_calc; 
assign angle_y= selector ? angle_y_mem : angle_y_calc; 
assign angle_z= selector ? angle_z_mem : angle_z_calc; 
assign angle_g= selector ? angle_g_mem : ((garra == 1) ? 180 : 0); 
 

always @(posedge clk or posedge rst) begin 
    if (rst) begin
        out_x <= 0;
        out_y <= 0;
        out_z <= 0;
        out_g <= 0;
        comp_x <= 0;
        comp_y <= 0;
        comp_z <= 0;
        comp_g <= 0;
		  
		  
    end 
    else begin
	 
		  comp_g <= min + (angle_g * m);
        if (count < comp_g)
            out_g <= 1;
        else
            out_g <= 0;
				
        comp_x <= min + (angle_x * m);
		  if (count < comp_x)
            out_x <= 1;
        else
            out_x <= 0;
				
        comp_y <= min + (angle_y * m);
		   if (count < comp_y)
            out_y <= 1;
        else
            out_y <= 0;
				
        comp_z <= min + (angle_z * m);
		   if (count < comp_z)
            out_z <= 1;
        else
            out_z <= 0;
				

    end
end

endmodule