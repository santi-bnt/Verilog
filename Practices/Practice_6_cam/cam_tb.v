module cam_tb #(
    parameter DATA_WIDTH = 4,
    parameter ADDR_WIDTH = 8
)();

reg clk;
reg rst;
reg search_enable;
reg [DATA_WIDTH-1:0] search_data;
wire match;

cam DUT (
    .clk(clk),
    .rst(rst),
    .search_enable(search_enable),
    .search_data(search_data),
    .match(match)
);


initial begin
    clk = 0;
    forever #10 clk = ~clk;
end

// estímulos
initial begin
    rst = 1;
    search_enable = 0;
    search_data = 0;

    #20;
    rst = 0;
    search_enable = 1;

    repeat(20) begin
        search_data = $random % 16;   
        #20;
    end

    $stop;
    $finish;
end


initial begin
    $monitor("search_data=%h | match=%b", search_data, match);
end


initial begin
    $dumpfile("cam_tb.vcd");
    $dumpvars(0, cam_tb);
end

endmodule