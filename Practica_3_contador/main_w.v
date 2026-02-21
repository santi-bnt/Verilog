module main_w(
	 input  [1:0] KEY,
	 input MAX10_CLK1_50,
	 input  [9:0] SW,
    output [0:6] HEX0,
    output [0:6] HEX1,
    output [0:6] HEX2,
    output [0:6] HEX3
);

wire [0:6] D_un,D_de,D_ce,D_mi;

main pract3(.clk(MAX10_CLK1_50),
	 .rst (~KEY[0]),
	 .up_down (SW[9]),
	 .load (KEY[1]),
	 .data_in (SW[6:0]), .D_un(HEX0),.D_de(HEX1),.D_ce(HEX2),.D_mi(HEX3));
	 
endmodule
