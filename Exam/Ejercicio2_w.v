module Ejercicio2_w(
    input MAX10_CLK1_50,
    input [1:0] KEY,
    output [0:6] HEX0,
    output [0:6] HEX1,
    output [0:6] HEX2,
    output [0:6] HEX4,
    output [0:6] HEX5

);

wire [19:0] seg;
wire [19:0] mili;

Ejercicio2 eje2(.clk(MAX10_CLK1_50),.rst(~KEY[0]),.seg(seg),.start(~KEY[1]),.mili(mili));

BCD_5display display_inst (
        .bcd_in(mili),
		  .bcd_in_seg(seg),
        .D_un(HEX0),
        .D_de(HEX1),
        .D_ce(HEX2),
        .D_mi(HEX4),
		  .D_mi_s(HEX5)
		  
    );
    

endmodule