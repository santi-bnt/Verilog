module top_tx (
    input  wire        MAX10_CLK1_50,
    input  wire [1:0]  KEY,
    input  wire [9:0]  SW,
    output wire  [15:0] ARDUINO_IO,
    output wire [0:6]  HEX0,
    output wire [0:6]  HEX1,
    output wire [0:6]  HEX2,
    output wire [0:6]  HEX3
);


wire [7:0] data_tx;
wire busy;
reg start;
reg key_prev;

assign data_tx = SW[7:0];



UART_Tx #(
    .BAUD_RATE(9600),
    .CLOCK_FREQ(50_000_000),
    .BITS(8)
) TX_inst (
    .clk(MAX10_CLK1_50),
    .rst(!KEY[1]),
    .data_in(data_tx),
    .start(!KEY[0]),
    .tx_out(ARDUINO_IO[1]),
    .busy(busy)
);

BCD_4display DISP_TX (
    .bcd_in(data_tx),
    .D_un(HEX0),
    .D_de(HEX1),
    .D_ce(HEX2),
    .D_mi(HEX3)
);

endmodule