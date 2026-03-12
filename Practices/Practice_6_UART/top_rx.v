module top_rx (
    input  wire        MAX10_CLK1_50,
    input  wire [1:0]  KEY,
	 input wire [15:0] ARDUINO_IO,
    output wire [0:6]  HEX0,
    output wire [0:6]  HEX1,
    output wire [0:6]  HEX2,
    output wire [0:6]  HEX3
);

wire data_ready;
wire [7:0] data_out;



UART_Rx #(
    .BAUD_RATE(9600),
    .CLOCK_FREQ(50_000_000),
    .BITS(8)
) RX_inst (
    .clk(MAX10_CLK1_50),
    .rst(!KEY[1]),
    .rx_in(ARDUINO_IO[0]),   
    .data_out(data_out),
    .data_ready(data_ready)
);
BCD_4display DISP_TX (
    .bcd_in(data_out),
    .D_un(HEX0),
    .D_de(HEX1),
    .D_ce(HEX2),
    .D_mi(HEX3)
);

endmodule