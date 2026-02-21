module main(
   input clk,
	input rst,
	input up_down,
	input load,
	input [6:0] data_in,
	output [0:6] D_un,D_de,D_ce,D_mi
);

wire clock;
wire [7:0] counter;


clk_divide  u_clk_div (
    .clk(clk),
    .rst(rst),
    .clk_div(clock)
);

count counter1(.clk(clock),.rst(rst),
	.up_down(up_down),
	.load(load),
	.data_in(data_in),
	 .counter(counter));

BCD_4display  u_4disp (
   .bcd_in(counter),.D_un(D_un),.D_de(D_de),.D_ce(D_ce),.D_mi(D_mi)
);

endmodule