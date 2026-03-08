module cam #(parameter data_width = 4, parameter add_width = 8)(
    input clk,
    input rst,
    input search_enable,
    input [data_width-1:0] search_data,
    output reg match
);

reg [data_width-1:0] mem [0:(2**add_width)-1];
wire [add_width-1:0] count;

counter contador (
    .clk(clk),
    .rst(rst),
    .count(count)
);

initial begin
    $readmemh("memo.hex", mem);
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        match <= 0;
    end
    else if (search_enable) begin
        if (mem[count] == search_data)
            match <= 1;
        else
            match <= 0;
    end
    else begin
        match <= 0;
    end
end

endmodule