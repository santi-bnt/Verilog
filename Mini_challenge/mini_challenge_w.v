module mini_challenge_w(
    input  MAX10_CLK1_50,
    input  [1:0] KEY,
    output  LEDR);

    
mini_challenge w(.rst(KEY[0]),.in(KEY[1]),.out(LEDR),.clk(MAX10_CLK1_50));

endmodule
