module BCD(
input [3:0] BCD_in,
output reg [0:6] BCD_out
);

always @(*) begin
    case (BCD_in)
        4'b0000: BCD_out = 7'b000_0001; 
        4'b0001: BCD_out = 7'b100_1111; 
        4'b0010: BCD_out = 7'b001_0010; 
        4'b0011: BCD_out = 7'b000_0110; 
        4'b0100: BCD_out = 7'b100_1100; 
        4'b0101: BCD_out = 7'b010_0100; 
        4'b0110: BCD_out = 7'b010_0000; 
        4'b0111: BCD_out = 7'b000_1111; 
        4'b1000: BCD_out = 7'b000_0000; 
        4'b1001: BCD_out = 7'b000_0100; 
        4'b1010: BCD_out = 7'b111_1111; 
        default: BCD_out = 7'b111_1111; 
    endcase
end

endmodule