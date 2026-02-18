module BCD_4display_w (
    input [9:0] SW,
    output [0:6] HEX0,
	 output [0:6] HEX1,
	 output [0:6] HEX2,
	 output [0:6] HEX3
);
   
BCD_4display WRAP1 (.bcd_in(SW),.D_un(HEX0),.D_de(HEX1),.D_ce(HEX2),.D_mi(HEX3));


endmodule