module vga_demo(
    input MAX10_CLK1_50,
    output reg [2:0] pixel,
    output hsync_out,
    output vsync_out
);

wire inDisplayArea;
wire [5:0] CounterX;
wire [5:0] CounterY;

reg pixel_tick=0;
always @(posedge MAX10_CLK1_50) begin
    pixel_tick <= ~pixel_tick;
end

vga hvsync_gen(
    .clk(MAX10_CLK1_50),
    .pixel_tick(pixel_tick),
    .vga_h_sync(hsync_out),
    .vga_v_sync(vsync_out),
    .inDisplayArea(inDisplayArea),
    .CounterX(CounterX),
    .CounterY(CounterY)
);




always @(posedge MAX10_CLK1_50)
	if(inDisplayArea)begin
    if (CounterX[5]^CounterY[5])
        pixel <= 3'b111;
    else
        pixel <= 3'b000;
    end
	 else 
		pixel<= 3'b000;

endmodule