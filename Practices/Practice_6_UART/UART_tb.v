module UART_tb();

reg clk;
reg rst;
reg [7:0] data_in;
reg start;

wire tx_out;
wire busy;
wire UART_wire;
wire [7:0] data_out;
wire data_ready;

assign UART_wire = tx_out;

UART_Tx #(
    .BAUD_RATE(9600),
    .CLOCK_FREQ(50_000_000),
    .BITS(8)
) TX_inst (
    .clk(clk),
    .rst(rst),
    .data_in(data_in),
    .start(start),
    .tx_out(tx_out),
    .busy(busy)
);

UART_Rx #(
    .BAUD_RATE(9600),
    .CLOCK_FREQ(50_000_000),
    .BITS(8)
) RX_inst (
    .clk(clk),
    .rst(rst),
    .rx_in(UART_wire),
    .data_out(data_out),
    .data_ready(data_ready)
);

initial begin
    clk = 0;
    rst = 1;
    data_in = 0;
    start = 0;
end

always #10 clk = ~clk;

initial begin
    #100;
    rst = 0;

    send_byte(55);
    send_byte(12);
    send_byte(24);


    #20;
    $finish;
end

task send_byte;
    input [7:0] byte_to_send;
    begin
        @(posedge clk);
        data_in = byte_to_send;
        start = 1;

        @(posedge clk);
        start = 0;

        @(posedge data_ready);
        $display("Enviado=%d , Recibido=%d", byte_to_send, data_out);

        #100;
    end
endtask

initial begin
    $dumpfile("UART_tb.vcd");
    $dumpvars(0, UART_tb);
end

endmodule