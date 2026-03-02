module comparador_tb();

    reg MAX10_CLK1_50;
    reg [1:0] KEY;
    reg [7:0] SW;

    wire [6:0] ARDUINO_IO;
    wire [6:0] HEX0;
    wire [6:0] HEX1;
    wire [6:0] HEX2;
    wire [6:0] HEX3;
   

    pract5_w uut (
        .MAX10_CLK1_50(MAX10_CLK1_50),
        .KEY(KEY),
        .SW(SW),
        .ARDUINO_IO(ARDUINO_IO),
        .HEX0(HEX0),
        .HEX1(HEX1),
        .HEX2(HEX2),
        .HEX3(HEX3)
    );

    initial begin
        MAX10_CLK1_50 = 0;
        forever #10 MAX10_CLK1_50 = ~MAX10_CLK1_50;
    end

    initial begin
        KEY = 2'b11; 
        SW = 10'b0;

        #100;
        KEY[0] = 0; 
        #100;
        KEY[0] = 1; 
        #100;

        $display("Testing 0 degrees...");
        SW = 10'b0000000001;
        #2500; 

        // Test Case 2
        $display("Testing 90 degrees...");
        SW = 10'b0000000010;
        #2500;

        // Test Case 3
        $display("Testing 180 degrees...");
        SW = 10'b0000000100;
        #2500;
        
        $display("Test Complete");
        $stop;
    end

        initial begin
    $monitor("SW = %b",SW);
end

initial begin
    $dumpfile("comparador_tb.vcd");
    $dumpvars(0,comparador_tb);

end
      
endmodule
