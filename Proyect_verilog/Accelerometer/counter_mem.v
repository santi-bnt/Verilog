module counter_mem #(parameter ADDR_WIDTH = 3)(
    input clk,
    input rst,
    input avanzar,
    output reg [ADDR_WIDTH-1:0] count
);

always @(posedge clk or posedge rst) begin
    if (rst)
        count <= 0;
    else if (avanzar)
        count <= count + 1;
end

endmodule