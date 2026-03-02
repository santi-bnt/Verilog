module pract5_w (
    input  [1:0] KEY,
	 input MAX10_CLK1_50,
	 input  [7:0] SW,
    output [0:6] ARDUINO_IO,
    output [0:6] HEX0,
    output [0:6] HEX1,
    output [0:6] HEX2,
    output [0:6] HEX3
);


comparador wraper(.rst(KEY[0]),.clk(MAX10_CLK1_50),.in(SW[7:0]),.out(ARDUINO_IO[0]));

endmodule