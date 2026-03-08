module clk_divide #(
    parameter FREQ = 5,
    parameter CLK_FREQ = 50_000_000
)(
    input clk, 
    input rst,
    output reg clk_div
   
);

reg [31:0] count;
localparam constantnum = CLK_FREQ / (2 * FREQ);
    always @(posedge clk or posedge rst) begin
        if (rst == 1)
         count <= 0;
        else if (count == constantnum -1)
            count <= 0;
        else count<= count +1;
    end

     always @(posedge clk or posedge rst) begin
        if (rst == 1)
         clk_div <= 0;
        else if (count == constantnum -1)
            clk_div <= ~clk_div;
        else clk_div <= clk_div;
    end



endmodule