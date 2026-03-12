module Ejercicio1(
    input clk, 
    input rst, 
    input [9:0]in,
    output reg [19:0] sum,
    input start
);

reg [9:0] counter ;

always @(posedge clk or posedge rst)begin
    if (rst)begin
        counter <= 0;
        sum <= 0;
    end
    else begin 
        if (start)begin
            if (counter <= in)begin
                counter <= counter + 1;
                sum <= sum + counter;
            end
            else begin
                counter <= counter;
        end
        end
        else begin
            counter <= counter;
    end
end
end

endmodule 