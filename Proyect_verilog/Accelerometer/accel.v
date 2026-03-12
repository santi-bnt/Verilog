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
   inout 		          		GSENSOR_SDO,
	
	output [3:0] VGA_R,
	output [3:0] VGA_G,
	output [3:0] VGA_B,
	output VGA_HS,
	output VGA_VS

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

clk_divider_parameter #(.FREQ(100)) DIVISOR_REFRESH 
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


wire [7:0] angle_x;
wire [7:0] angle_y;
wire [7:0] angle_z;
wire [7:0] angle_g;

wire out_x;
wire out_y;
wire out_z;
wire out_g;

//PARTE DE LA MEMORIA 


wire selector; 

wire garra; 

wire guardar_dato; 
wire habilitar_contador; 

wire[2:0] addr; 
wire [31:0] data_in; 
wire [31:0] data_out;

wire [7:0] angle_x_mem;
wire [7:0] angle_y_mem;
wire [7:0] angle_z_mem;
wire [7:0] angle_g_mem;

comparador conv(
    .clk(MAX10_CLK1_50),
    .rst(rst_n),
	 
    .data_x_reg(data_x_reg),
    .data_y_reg(data_y_reg),
    .data_z_reg(data_z_reg),
	 
    .angle_x(angle_x),
    .angle_y(angle_y),
    .angle_z(angle_z),
    .angle_g(angle_g),
	 
    .out_x(out_x),
    .out_y(out_y),
    .out_z(out_z),
    .out_g(out_g),
	 
	 	 
    .garra(garra),
	 .selector(selector), 
	 
	 .angle_x_mem(angle_x_mem),
	 .angle_y_mem(angle_y_mem),
	 .angle_z_mem(angle_z_mem),
	 .angle_g_mem(angle_g_mem)
	 
);

//señales de las coordenadas convertidas a grados
assign ARDUINO_IO[0] = out_z;
assign ARDUINO_IO[1] = out_y;
assign ARDUINO_IO[2] = out_x;
assign ARDUINO_IO[3] = out_g;


//asignación de botones y switches
assign garra = SW[1];
assign selector= SW[0];
wire guardar_btn;
wire boton_pulso;

assign guardar_btn = ~KEY[1];

one_shot os_guardar(
    .clk(MAX10_CLK1_50),
    .rst(rst_n),
    .btn(guardar_btn),
    .pulse(boton_pulso)
);

//entrada de datos a la memoria 
assign data_in= {angle_x, angle_y, angle_z, angle_g};



//insanciamos la maquina de estados 

fsm_brazo estados(
	.clk(MAX10_CLK1_50),
	.rst(rst_n),
	.selector(selector),
	.guardar(boton_pulso),
	.guardar_dato(guardar_dato),
	.habilitar_contador(habilitar_contador),
	.state()
);

wire tick_mem;
wire avanzar_addr;
assign avanzar_addr = (selector && tick_mem) || ((!selector) && boton_pulso);


//instanciamos la memoria 
mem memoria_states(
	.rst(rst_n),
	.clk(MAX10_CLK1_50),
	.guardar_dato(guardar_dato),
	.addr(addr),
	.data_in(data_in),
	.data_out(data_out)
);




tick_1hz tick_auto(
    .clk(MAX10_CLK1_50),
    .rst(rst_n),
    .tick(tick_mem)
);

counter_mem contador_memoria( 
	.clk(MAX10_CLK1_50),
	.rst(rst_n),
	.avanzar(avanzar_addr),
	.count(addr)
);

assign angle_x_mem= data_out[31:24];
assign angle_y_mem= data_out[23:16];
assign angle_z_mem= data_out[15:8];
assign angle_g_mem= data_out[7:0];



wire [2:0] pixel;

VGACounterDemo pantalla(
    .MAX10_CLK1_50(MAX10_CLK1_50),
    .angle_x(angle_x),
    .angle_y(angle_y),
    .angle_z(angle_z),
    .angle_g(angle_g),
    .pixel(pixel),
    .hsync_out(VGA_HS),
    .vsync_out(VGA_VS)
);

assign VGA_R = (pixel[2]) ? 4'b1111 : 4'b0000;
assign VGA_G = (pixel[1]) ? 4'b1111 : 4'b0000;
assign VGA_B = (pixel[0]) ? 4'b1111 : 4'b0000;



wire [3:0] unidades_x = addr %10;
wire [3:0] decenas_x = (addr/10)%10;
wire [3:0] centenas_x = addr/100;

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
