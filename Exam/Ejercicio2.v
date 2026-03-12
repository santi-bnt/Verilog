module Ejercicio2(
    input clk,
    input rst,
    input start,
    output reg [19:0] seg,
	 output reg [19:0] mili
);

reg [15:0 ] clk_mili;
always @(posedge clk or posedge rst)begin
    if (rst)begin
        seg <= 0;
		mili <= 0;
        clk_mili <= 0;
		  end
    else begin
        if (start)begin
            if (clk_mili == 1000)begin
                clk_mili <= 0;
                if (mili == 999)begin
                    mili <= 0;
                    if (seg == 99)begin
                        seg <= 0;
								end
                    else begin
                        seg <= seg + 1;
                    end
                end
                else begin
                    mili <= mili + 1;
						  end
            end
            else   begin
                clk_mili <= clk_mili + 1;
            end

        
    end
end
end

endmodule
