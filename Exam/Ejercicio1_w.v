module Ejercicio1_w( /// ESTE ES EL ULTIMO 
    input MAX10_CLK1_50,
    input [1:0] KEY,
    input [7:0] SW,
    output [0:6] HEX0,
    output [0:6] HEX1,
    output [0:6] HEX2,
    output [0:6] HEX3

);

wire [19:0] sum;


Ejercicio1 eje(.clk(MAX10_CLK1_50),.rst(~KEY[0]),.in(SW),.sum(sum),.start(~KEY[1]));

BCD_4display display_inst (
        .bcd_in(sum),
        .D_un(HEX0),
        .D_de(HEX1),
        .D_ce(HEX2),
        .D_mi(HEX3)
    );
    

endmodule