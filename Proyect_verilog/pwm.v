module pract5_w (
    input MAX10_CLK1_50,
    input [1:0] KEY,
    input [7:0] SW,
    output [15:0] ARDUINO_IO,
    output [7:0] HEX0,
    output [7:0] HEX1,
    output [7:0] HEX2,
    output [7:0] HEX3,
    output [7:0] HEX4,
    output [7:0] HEX5
);

   wire rst = ~KEY[0];       
	wire clk_5mhz;
	wire [7:0] SW_lim = (SW >= 180) ? 180 : SW; //imitamos para que lo maximo sea 180 usando "?" para asignar 180 a SW
	wire [6:0] D_un, D_de, D_ce, D_mi;

clk_divide u_div(
  .clk(MAX10_CLK1_50),
  .rst(rst),
  .clk_div(clk_5mhz)
);

convertidor u_comp(
  .clk(clk_5mhz),
  .rst(rst),
  .in(SW_lim),
  .out((ARDUINO_IO[0]))
);
 
 
    
    BCD_4display display_inst (
        .bcd_in(SW_lim),
        .D_un(D_un),
        .D_de(D_de),
        .D_ce(D_ce),
        .D_mi(D_mi)
    );
    
    assign HEX0[0] = D_un[6];
    assign HEX0[1] = D_un[5];
    assign HEX0[2] = D_un[4];
    assign HEX0[3] = D_un[3];
    assign HEX0[4] = D_un[2];
    assign HEX0[5] = D_un[1];
    assign HEX0[6] = D_un[0];
    assign HEX0[7] = 1; 

    assign HEX1[0] = D_de[6];
    assign HEX1[1] = D_de[5];
    assign HEX1[2] = D_de[4];
    assign HEX1[3] = D_de[3];
    assign HEX1[4] = D_de[2];
    assign HEX1[5] = D_de[1];
    assign HEX1[6] = D_de[0];
    assign HEX1[7] = 1; 
    
    assign HEX2[0] = D_ce[6];
    assign HEX2[1] = D_ce[5];
    assign HEX2[2] = D_ce[4];
    assign HEX2[3] = D_ce[3];
    assign HEX2[4] = D_ce[2];
    assign HEX2[5] = D_ce[1];
    assign HEX2[6] = D_ce[0];
    assign HEX2[7] = 1; 
    
    assign HEX3[0] = D_mi[6];
    assign HEX3[1] = D_mi[5];
    assign HEX3[2] = D_mi[4];
    assign HEX3[3] = D_mi[3];
    assign HEX3[4] = D_mi[2];
    assign HEX3[5] = D_mi[1];
    assign HEX3[6] = D_mi[0];
    assign HEX3[7] = 1; // offfff
    
    assign HEX4 = 8'hFF; 
    assign HEX5 = 8'hFF; 

endmodule