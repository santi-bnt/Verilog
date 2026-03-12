module top_w(
    input         MAX10_CLK1_50,
    input  [1:0]  KEY,
    input  [9:0]  SW,
    input  [15:0] ARDUINO_IO,

    output [3:0]  VGA_R,
    output [3:0]  VGA_G,
    output [3:0]  VGA_B,
    output        VGA_HS,
    output        VGA_VS,

    output [7:0]  HEX0,
    output [7:0]  HEX1
);


wire [11:0] rgb;
wire hsync, vsync;
wire [6:0] seg1, seg2;


top  wra(
    .clk     (MAX10_CLK1_50),
    .reset   (~KEY[0]),
    .button  (SW[0]),
    .button1 (SW[1]),
    .button2 (SW[2]),
    .button3 (SW[3]),
    .uart_rx (ARDUINO_IO[0]),
    .rgb     (rgb),
    .hsync   (hsync),
    .vsync   (vsync),
    .seg1    (seg1),
    .seg2    (seg2)
);

// VGA
assign VGA_R  = rgb[11:8];
assign VGA_G  = rgb[7:4];
assign VGA_B  = rgb[3:0];
assign VGA_HS = hsync;
assign VGA_VS = vsync;

// Displays de 7 segmentos
assign HEX0 = {1, seg1};
assign HEX1 = {1, seg2};


endmodule