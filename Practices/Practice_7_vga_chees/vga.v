module vga(
    input clk,
    input pixel_tick,
    output vga_h_sync,
    output vga_v_sync,
    output reg inDisplayArea,
    output reg [9:0] CounterX=0,
    output reg [9:0] CounterY=0
);

reg vga_HS=0;
reg vga_VS=0;

wire counterXmaxed = (CounterX==799);
wire counterYmaxed = (CounterY==524);

always @(posedge clk) begin
    if (pixel_tick) begin
        if (counterXmaxed)
            CounterX <= 0;
        else
            CounterX <= CounterX + 1;
    end
end

always@(posedge clk) begin
    if (pixel_tick && counterXmaxed) begin
        if (counterYmaxed)
            CounterY <= 0;
        else
            CounterY <= CounterY + 1;
    end
end

always @(posedge clk) begin
    if (pixel_tick) begin
        vga_HS <= (CounterX >= 640 +16) && CounterX < (640 + 16 + 96);
    end
end

always @(posedge clk) begin
    if (pixel_tick) begin
        vga_VS <= (CounterY >= 480 + 10) && CounterY < (480 + 10 + 2);
    end
end

always @(posedge clk) begin
    if (pixel_tick) begin
        inDisplayArea <= (CounterX < 640) && (CounterY < 480);
    end
end

assign vga_h_sync = ~vga_HS;
assign vga_v_sync = ~vga_VS;



endmodule