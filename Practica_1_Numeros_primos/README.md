# Práctica 1 — Números primos 

## Objetivo
Implementar un sistema en Verilog que lea el valor de **4 switches** de la FPGA, interprete su valor como un número binario (0 a 15) y determine si es **número primo**.  
El resultado se mostrará encendiendo un **LED**.


## ¿Qué se considera primo en este rango?
En el rango de 0 a 15, los números primos son:

**2, 3, 5, 7, 11, 13**

Para cualquier otro valor (incluyendo 0 y 1), la salida debe ser **0**.



## Entradas y salida
- **Entrada:** `N[3:0]` (número en binario desde switches)
- **Salida:** `out` (1 = es primo, 0 = no es primo)


## Archivos
- `num_primos.v`  
  Módulo combinacional que activa `out` cuando `N` es primo.

- `num_primos_tb.v`  
  Testbench que prueba todos los valores de `N` de 0 a 15, imprime resultados y genera un archivo de ondas `.vcd`.


## ¿Cómo funciona el módulo?
El módulo `num_primos` usa un `case` para poner:
- `out = 1` cuando `N` es 2, 3, 5, 7, 11 o 13
- `out = 0` en cualquier otro caso


## Simulación

### Opción A: Icarus Verilog + GTKWave
```bash
iverilog -o sim num_primos.v num_primos_tb.v
vvp sim
gtkwave num_primos_tb.vcd
