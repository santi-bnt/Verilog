module password_fsm_tb(
    
);

 initial begin
    $monitor("SW = %b",SW);
end

initial begin
    $dumpfile("password_fsm_tb.vcd");
    $dumpvars(0,password_fsm_tb);

end
      

endmodule