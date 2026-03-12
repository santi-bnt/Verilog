module UART_Tx #(parameter BAUD_RATE = 9600, parameter CLOCK_FREQ = 50000000,BITS = 8)(
    input wire clk,
    input wire rst,
    input wire [BITS-1:0] data_in,
    input wire start,
    output reg tx_out,
    output reg busy
);
localparam IDLE = 2'b00, START_BIT = 2'b01, DATA_BITS = 2'b10, STOP_BIT = 2'b11;
reg [1:0] state;

reg [3:0] bit_index;
reg [15:0] baud_counter;    
reg [BITS-1:0] data_buffer;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        tx_out <= 1'b1; // Línea inactiva
        busy <= 0;
        bit_index <= 0;
        baud_counter <= 0;
    end else begin
        case (state)
            IDLE: begin
                tx_out <= 1'b1; // Línea inactiva
                busy <= 0;
                if (start) begin
                    data_buffer <= data_in;
                    state <= START_BIT;
                    busy <= 1;
                end
            end
            START_BIT: begin
                tx_out <= 1'b0; // Bit de inicio
                if (baud_counter < CLOCK_FREQ / BAUD_RATE - 1) begin
                    baud_counter <= baud_counter + 1;
                end else begin
                    baud_counter <= 0;
                    state <= DATA_BITS;
                    bit_index <= 0;
                end
            end
            DATA_BITS: begin
                tx_out <= data_buffer[bit_index]; // Enviar bits de datos
                if (baud_counter < CLOCK_FREQ / BAUD_RATE - 1) begin
                    baud_counter <= baud_counter + 1;
                end else begin
                    baud_counter <= 0;
                    if (bit_index < BITS - 1) begin
                        bit_index <= bit_index + 1;
                    end else begin
                        state <= STOP_BIT;
                    end
                end
            end
            STOP_BIT: begin
                tx_out <= 1'b1; // Bit de parada
                if (baud_counter < CLOCK_FREQ / BAUD_RATE - 1) begin
                    baud_counter <= baud_counter + 1;
                end else begin
                    baud_counter <= 0;
                    state <= IDLE; // Volver a IDLE después del bit de parada
                end
            end
        endcase
    end
end

endmodule