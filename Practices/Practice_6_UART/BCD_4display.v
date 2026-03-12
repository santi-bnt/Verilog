module BCD_4display #(parameter N_in = 10, N_out = 7)(
    input [N_in -1:0] bcd_in,
    output [N_out -1:0] D_un,D_de,D_ce,D_mi
);

wire [3:0] unidades,decenas,centenas,milares;

assign unidades = bcd_in % 10;
assign decenas = (bcd_in/10) % 10;
assign centenas = (bcd_in/100) % 10;
assign milares = (bcd_in/1000) % 10;

BCD unit(
    .BCD_in(unidades),
    .BCD_out(D_un)
);

BCD decens(
    .BCD_in(decenas),
    .BCD_out(D_de)
);

BCD centens(
    .BCD_in(centenas),
    .BCD_out(D_ce)
);

BCD milars(
    .BCD_in(milares),
    .BCD_out(D_mi)
);

endmodule