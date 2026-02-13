module num_primos_tb();
reg [3:0] N;
wire out;
integer i ;

num_primos DUT(.N(N),.out(out));


initial begin
    $display("inicia sim");
    
    N = 0;
    for (i = 0; i < 16; i = i + 1) begin
    N = i[3:0];   
    #10;

    end 
   
    
    $display("fin");
    $stop;
    $finish;

end

initial begin
    $monitor("N = %b,out = %b",N,out);

end

initial begin
    $dumpfile("num_primos_tb.vcd");
    $dumpvars(0,num_primos_tb);

end


endmodule
