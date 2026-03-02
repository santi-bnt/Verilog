module password_fsm( 
	input [3:0] SW, 
	input [1:0] KEY, 
	input MAX10_CLK1_50,
	input rst, 
	output reg [0:6] HEX0,
	output reg [0:6] HEX1,
	output reg [0:6] HEX2,
	output reg [0:6] HEX3

); 

//Definition

reg[2:0] current_state; //3 bits para 7 estados
reg[3:0] password_load; //en donde se va a guardar el valor de la password, son 4 bits de los 4 digitos 
reg next_state;


//PASSWORD 

parameter[3:0] passw_dig1=4'h2, passw_dig2= 4'h0, passw_dig3=4'h2, passw_dig4=4'h6;

//Botones  
wire reset= ~KEY[1];
wire next_button= (~KEY[0]) & (~next_state); //genera un solo pulso del reloj 

//Clock divider para que la frec esté en 5hz 

wire clk_slow; //reloj con la freuencia de 5hz 

clk_divider DIVISOR_FRECUENCIA (
    .clk(MAX10_CLK1_50),
    .rst(reset),
    .clk_div(clk_slow)
);

//Estados 


parameter IDLE=0, DIG1=1, DIG2=2, DIG3=3, DIG4=4, bad= 5, good=6;

//Displays 
reg[3:0] disp1, disp2, disp3, disp4;

//Proceso de memoria 

always@(posedge clk_slow or posedge reset) 
	begin 
		if(reset) 
			next_state<=0; //Estado predeterminado
		else 
			next_state<= ~KEY[0]; 
	end 
	
//Declaración insana de todos los estados :0 

always@(posedge clk_slow or posedge reset) 
	begin 
		if (reset) 
			begin 
				current_state<= IDLE;
				disp1 <= 0; 
				disp2 <= 0; 
				disp3 <= 0; 
				disp4 <= 0;
			end 
	//basicamente esto que se hace es inicializar los displays y darles por defecto 0000 y mandar el estado al determinado 
		else 
			begin 
				case(current_state) 
					IDLE: 
						begin 
							if(next_button)//==1 
							begin 
								disp1<=SW; 
								
								if(SW== passw_dig1)
									current_state<= DIG1; 
									
								else 
									current_state<= bad; 
							end 
						end 
					DIG1: 
						begin 
							if(next_button)
							begin 
								disp2<=SW; 
								
								if(SW==passw_dig2) 
									current_state<= DIG2;
								
								else 
									current_state<=bad; 
							end 
						end 
					DIG2: 
						begin 
							if(next_button)
							begin 
								disp3<=SW; 
								
								if(SW==passw_dig3) 
									current_state<= DIG3;
								
								else 
									current_state<=bad; 
							end 
						end 
					DIG3: 
						begin 
							if(next_button)
							begin 
								disp4<=SW; 
								
								if(SW==passw_dig4) 
									current_state<= DIG4;
								
								else 
									current_state<=bad; 
							end 
						end 
					DIG4:
						begin 
							current_state<=good;
						end 
					//ahora declaramos los estados que faltan good y bad 
					good: current_state<=good;
					bad: current_state<=bad;
					//como no van a otro estado supongo que deben de declararse a si mismos 
					
					default:current_state<=IDLE; //cualquier otro estado regresa al IDLE 
					
					endcase 
				end 
			end


//Ahora se necesita instancad el BCD module para que se van los digitos

wire[0:6] s1, s2, s3, s4; 
BCD dig_1 (.bcd_in(disp1),.bcd_out(s1));
BCD dig_2 (.bcd_in(disp2),.bcd_out(s2));
BCD dig_3 (.bcd_in(disp3),.bcd_out(s3));
BCD dig_4 (.bcd_in(disp4),.bcd_out(s4));

//Acomodar el good y el bad bonito en los displays :) 

always@(*)
	begin
		case(current_state)
			good:
				begin
					HEX3 = ~7'b1011_110; // g
					HEX2 = ~7'b0011_101; // o
					HEX1 = ~7'b0011_101; // o
					HEX0 = ~7'b0111_101; // d
				end
			bad: 
				begin 
					HEX3 = ~7'b0000_000;
					HEX2 = ~7'b0011_111; // b
					HEX1 = ~7'b1110_111; // A
					HEX0 = ~7'b0111_101; // d
				end
			default:
				begin 
					HEX3= s1; 
					HEX2= s2; 
					HEX1= s3; 
					HEX0= s4; 
				end 
			endcase 
		end 

	
endmodule
