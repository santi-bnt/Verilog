module BCD( 
	input [3:0] bcd_in, 
	output reg [0:6] bcd_out //siempre poner el reg al escribirlo en combinacional 
	); 
	
	always @(*) 
	begin 
		case (bcd_in) 
		//4'b0000:
			0: 
				bcd_out= ~7'b1111_110; 
			1: 
				bcd_out= ~7'b0110_000; 
			2: 
				bcd_out= ~7'b1101_101; 
			3: 
				bcd_out= ~7'b1111_001; 
			4: 
				bcd_out= ~7'b0110_011; 
			5: 
				bcd_out= ~7'b1011_011;
			6: 
				bcd_out= ~7'b1011_111; 
			7: 
				bcd_out= ~7'b1110_000; 
			8: 
				bcd_out= ~7'b1111111; 
			9: 
				bcd_out= ~7'b1111_011;
				
	default:bcd_out= ~7'b0000000;
	endcase 
end
			
endmodule 