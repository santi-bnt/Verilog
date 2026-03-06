module convertidor #(parameter pwm = 50,
    parameter CLK_FREQ = 50_000_000)(
    input clk,
    input rst,

   input signed [19:0] data_x_reg,
   input signed [19:0] data_y_reg,
   input signed [19:0] data_z_reg,

    output reg out_x,
    output reg out_y,
    output reg out_z
);

wire [19:0] count;
reg  [19:0] comp_x;
reg  [19:0] comp_y;
reg  [19:0] comp_z;

counter countersin(.rst(rst), .clk(clk), .counter(count));

localparam integer min = ((CLK_FREQ/pwm)*3)/100;
localparam integer max = ((CLK_FREQ/pwm)*12)/100;
localparam integer m   = (max-min)/180;

wire [7:0] angle_x;
wire [7:0] angle_y;
wire [7:0] angle_z;


assign angle_x = 90 + (data_x_reg >>> 2); // desplaza el bit 4 a la derecha
assign angle_y = 90 + (data_y_reg >>> 2);
assign angle_z = 90 + (data_z_reg >>> 2);

always @(posedge clk or posedge rst) begin 
    if (rst) begin
        out_x <= 0;
        out_y <= 0;
        out_z <= 0;
    end 
    else begin
			
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

