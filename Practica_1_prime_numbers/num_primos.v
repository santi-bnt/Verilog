module num_primos(
input [3:0] N,
output reg out
);


always @(*)
begin
    case(N)
    2: out = 1;
    3: out = 1;
    5: out = 1;
    7: out = 1;
    11: out = 1;
    13: out = 1;
    default: out = 0;


    endcase
    end
endmodule
