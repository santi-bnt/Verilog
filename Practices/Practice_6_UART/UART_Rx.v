module UART_Rx #(
    parameter BAUD_RATE  = 9600,
    parameter CLOCK_FREQ = 50_000_000,
    parameter BITS       = 8
)(
    input  wire clk,
    input  wire rst,
    input  wire rx_in,
    output reg  [BITS-1:0] data_out,
    output reg  data_ready
);

localparam IDLE      = 0;
localparam START_BIT = 1;
localparam DATA_BITS = 2;
localparam STOP_BIT  = 3;

localparam integer BAUD_TICK = CLOCK_FREQ / BAUD_RATE;

reg [1:0] state;
reg [3:0] bit_index;
reg [15:0] baud_counter;
reg [BITS-1:0] data_buffer;

// sincronizador
reg rx_sync1, rx_sync2;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        rx_sync1 <= 1;
        rx_sync2 <= 1;
    end else begin
        rx_sync1 <= rx_in;
        rx_sync2 <= rx_sync1;
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state        <= IDLE;
        data_out     <= 0;
        data_ready   <= 0;
        bit_index    <= 0;
        baud_counter <= 0;
        data_buffer  <= 0;
    end else begin
        case (state)
            IDLE: begin
                data_ready <= 0;
                baud_counter <= 0;
                bit_index <= 0;
                if (!rx_sync2) begin
                    state <= START_BIT;
                end
            end

            START_BIT: begin
                if (baud_counter == (BAUD_TICK-1)/2) begin
                    baud_counter <= 0;
                    if (!rx_sync2)
                        state <= DATA_BITS;
                    else
                        state <= IDLE;
                end else begin
                    baud_counter <= baud_counter + 1;
                end
            end

            DATA_BITS: begin
                if (baud_counter < BAUD_TICK-1) begin
                    baud_counter <= baud_counter + 1;
                end else begin
                    baud_counter <= 0;
                    data_buffer[bit_index] <= rx_sync2;

                    if (bit_index < BITS-1)
                        bit_index <= bit_index + 1;
                    else begin
                        bit_index <= 0;
                        state <= STOP_BIT;
                    end
                end
            end

            STOP_BIT: begin
                if (baud_counter < BAUD_TICK-1) begin
                    baud_counter <= baud_counter + 1;
                end else begin
                    baud_counter <= 0;
                    data_out <= data_buffer;
                    data_ready <= 1;
                    state <= IDLE;
                end
            end
        endcase
    end
end

endmodule