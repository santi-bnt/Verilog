module BCD_4display_tb();
reg [9:0] bcd_in;
wire [6:0] D_un, D_de, D_ce, D_mi;

BCD_4display DUT(.bcd_in(bcd_in),.D_un(D_un),.D_de(D_de),.D_ce(D_ce),.D_mi(D_mi));

initial begin
repeat(50)
begin
    $display("sim iniciada") ;  
    bcd_in = $random%1023;
    #10;
end
$display("sim finalizada"); 
$stop;
$finish;
end


initial begin
    $monitor("BCD_in = %b,D_un= %b, D_de= %b, D_ce= %b, D_mi = %b",bcd_in,D_un, D_de, D_ce, D_mi);
end

initial begin
    $dumpfile("BCD_4display_tb.vcd");
    $dumpvars(0,BCD_4display_tb);

end
endmodule