module comparador #(parameter pwm = 50,
    parameter CLK_FREQ = 5_000_000)(
    input clk,
    input rst,
    input [7:0] in,
    output reg out
);

wire [16:0] count;
reg  [16:0] comp;

counter countersin(.rst(rst), .clk(clk), .counter(count));

localparam integer min = ((CLK_FREQ/pwm)*3)/100;
localparam integer max = ((CLK_FREQ/pwm)*12)/100;
localparam integer m   = (max-min)/180;

always @(posedge clk or posedge rst) begin 
    if (rst) begin
        comp <= min;
        out  <= 0;
    end else begin
        comp <= (min + (in * m));   
        if (count < comp)
            out <= 1;
        else
            out <= 0;
    end
end

endmodule
