//===========================================================================
// accel.v
//
// Template module to get the DE10-Lite's accelerator working very quickly.
//
//
//===========================================================================

module accel (
   //////////// CLOCK //////////
   input 		          		ADC_CLK_10,
   input 		          		MAX10_CLK1_50,
   input 		          		MAX10_CLK2_50,

    output [15:0] ARDUINO_IO,

   //////////// SEG7 //////////
   output		     [7:0]		HEX0,
   output		     [7:0]		HEX1,
   output		     [7:0]		HEX2,
   output		     [7:0]		HEX3,
   output		     [7:0]		HEX4,
   output		     [7:0]		HEX5,

   //////////// KEY //////////
   input 		     [1:0]		KEY,

   //////////// LED //////////
   output		     [9:0]		LEDR,

   //////////// SW //////////
   input 		     [9:0]		SW,

   //////////// Accelerometer ports //////////
   output		          		GSENSOR_CS_N,
   input 		     [2:1]		GSENSOR_INT,
   output		          		GSENSOR_SCLK,
   inout 		          		GSENSOR_SDI,
   inout 		          		GSENSOR_SDO
   );

//===== Declarations
   localparam SPI_CLK_FREQ  = 200;  // SPI Clock (Hz)
   localparam UPDATE_FREQ   = 1;    // Sampling frequency (Hz)

   // clks and reset
   wire reset_n;
   wire clk, spi_clk, spi_clk_out;

   // output data
   wire data_update;
   wire [19:0] data_x, data_y, data_z;

//===== Phase-locked Loop (PLL) instantiation. Code was copied from a module
//      produced by Quartus' IP Catalog tool.
PLL ip_inst (
   .inclk0 ( MAX10_CLK1_50 ),
   .c0 ( clk ),                 // 25 MHz, phase   0 degrees
   .c1 ( spi_clk ),             //  2 MHz, phase   0 degrees
   .c2 ( spi_clk_out )          //  2 MHz, phase 270 degrees
   );

//===== Instantiation of the spi_control module which provides the logic to 
//      interface to the accelerometer.
spi_control #(     // parameters
      .SPI_CLK_FREQ   (SPI_CLK_FREQ),
      .UPDATE_FREQ    (UPDATE_FREQ))
   spi_ctrl (      // port connections
      .reset_n    (reset_n),
      .clk        (clk),
      .spi_clk    (spi_clk),
      .spi_clk_out(spi_clk_out),
      .data_update(data_update),
      .data_x     (data_x),
      .data_y     (data_y),
		.data_z		(data_z),
      .SPI_SDI    (GSENSOR_SDI),
      .SPI_SDO    (GSENSOR_SDO),
      .SPI_CSN    (GSENSOR_CS_N),
      .SPI_CLK    (GSENSOR_SCLK),
      .interrupt  (GSENSOR_INT)
   );

//===== Main block
//      To make the module do something visible, the 16-bit data_x is 
//      displayed on four of the HEX displays in hexadecimal format.

// Pressing KEY0 freezes the accelerometer's output
assign reset_n = KEY[0];

wire rst_n = !reset_n;
wire clk_2_hz;

clk_divide #(.FREQ(2)) DIVISOR_REFRESH 
(
.clk(MAX10_CLK1_50),
.rst(rst_n),
.clk_div(clk_2_hz)
);

reg [19:0] data_x_reg, data_y_reg, data_z_reg;

always @(posedge clk_2_hz)
begin
	data_x_reg <= data_x;
	data_y_reg <= data_y;
	data_z_reg <= data_z;
end

convertidor conv(
    .clk(MAX10_CLK1_50),
    .rst(rst_n),
    .data_x_reg(data_x),
    .data_y_reg(data_y),
    .data_z_reg(data_z),
    .out_x(ARDUINO_IO[0]),
    .out_y(ARDUINO_IO[1]),
    .out_z(ARDUINO_IO[2])
);

wire [3:0] unidades_x = data_x_reg %10;
wire [3:0] decenas_x = (data_x_reg/10)%10;
wire [3:0] centenas_x = data_x_reg /100;

wire [3:0] unidades_y = data_y_reg%10;
wire [3:0] decenas_y = (data_y_reg/10)%10;
wire [3:0] centenas_y = data_y_reg/100;

// 7-segment displays HEX0-3 show data_x in hexadecimal
seg7 s0 (
   .in      (unidades_x),
   .display (HEX0) );

seg7 s1 (
   .in      (decenas_x),
   .display (HEX1) );

seg7 s2 (
   .in      (centenas_x),
   .display (HEX2) );

seg7 s3 (
   .in      (unidades_y),
   .display (HEX3) );

// A few statements just to light some LEDs
seg7 s4 ( .in(decenas_y), .display(HEX4) );
seg7 s5 ( .in(centenas_y), .display(HEX5) );
assign LEDR = data_z_reg[9:0];

endmodule
