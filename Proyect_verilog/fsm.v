module fsm(
    input clk,
    input rst,
    input start,
    input selector,
    input guardar,
    output reg  LEDR
);

reg [25:0] counter;
reg clk_d;

always @(posedge clock_50) begin
    counter <= counter+1;
    clk_d = counter[25];
end

parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3 ;

reg [1:0] state, next_state;
wire x = SW[0];
wire reset = ~KEY[0];

always @(posedge clk_d or posedge reset) begin
    if (reset)
        state <= S0;
    else 
        state <= next_state;
end

always @(*) begin
    case (state)
    S0: 
        if (x== 1)
            next_state = S1;
        else 
            next_state = S0;
    S1: //1
        if (x== 0)
            next_state = S2;
        else 
            next_state = S1;
    S2: //10
        if (x== 1)
            next_state = S3;
        else
            next_state = S0;
    S3: //101
        if (x== 1)
            next_state = S1;
        else
            next_state = S2;
    default:
            next_state = S0;
    endcase
end

always @(*) begin
    LEDR = 0;
    case (state)
        S0: LEDR[0] = 1;
        S1: LEDR[1] = 1;
        S2: LEDR[2] = 1;
        S3: LEDR[3] = 1;
    endcase
    
end
endmodule