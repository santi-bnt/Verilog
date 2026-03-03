module mini_challenge #(
    parameter integer N = 4  //define el numero de bits de 1 o 2^N de iteraciones 
)(
    input  clk,
    input  rst,
    input  in,
    output reg  out
);

reg [N-1:0] cnt;    //genero el count para que solo cambie hasta que haga todas las iteraciones

always @(posedge clk) begin
    if (rst) begin  //inicio las variables en 0 cuando el rst cambia 
        out <= 0;
        cnt <= 0;
    end else begin
    if (in == out) begin  // verifica que la entrada no tenga cambios
        cnt <= 0;
    end else begin        // como si es difernte el in y el out
        if (cnt == {N{1'b1}}) begin // Si el counter cumple con 2^N veces 1 es decir N = 4 = b'1111
            out <= in;              // Si se cumple por ese tiempo entonces el output cambia y reinicamos el counter
            cnt <= 0;
        end else begin
            cnt <= cnt + 1'b1;     // Se suma 1 bit al counter 
        end
    end
end
end

endmodule