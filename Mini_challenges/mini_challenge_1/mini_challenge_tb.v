module mini_challenge_tb();
    reg  clk,  rst,  in;
    wire  out;

    mini_challenge DUT(.rst(rst),.in(in),.out(out),.clk(clk));

      initial begin
        clk= 0;

    forever 
    #10 clk =~clk;
    end

    initial begin
    
    $display("sim iniciada") ; 
	   rst = 1;
       in  = 0;
		#20;
		rst = 0;   
	 
    repeat(50)
    begin
        in = $random%2;					 // SE GENERA UN NUMERO RANDOM de 1 bit 0-1
		   repeat(40) @(posedge clk);  // Se hacen 40 posedge del clk 
    end


    
    $display("sim finalizada"); 
    $stop;
    $finish;
    end
  


initial begin
    $monitor("clk = %b ,in= %b ,out = %b", clk,in,out);
end

initial begin
    $dumpfile("mini_challenge_tb.vcd");
    $dumpvars(0,mini_challenge_tb);

end
	 
endmodule