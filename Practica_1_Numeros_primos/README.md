# Practica_1_Numeros_primos

## ¿Qué hace?
Lee un número de 4 bits (0 a 15) y prende un LED si el número es primo.

Primos entre 0 y 15:
**2, 3, 5, 7, 11, 13**



## Entradas y salida
- **N[3:0]** = número (switches)
- **out** = LED (1 si es primo, 0 si no)


## Archivos
- `num_primos.v` → el módulo que decide si es primo
- `num_primos_tb.v` → prueba que recorre N de 0 a 15 y muestra resultados


## Simulación
El testbench:
- pone `N = 0..15`
- imprime `N` y `out`
- genera `num_primos_tb.vcd` (ondas)


## Resultado esperado (rápido)
- Si `N` es **2,3,5,7,11,13** → `out = 1`
- Si no → `out = 0`
