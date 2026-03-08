# Practice 1 — Prime Numbers

## Goal
Implement a Verilog system that reads the value of **4 FPGA switches**, interprets it as a binary number (0 to 15), and determines whether it is a **prime number**.  
The result is shown by turning **an LED** on or off.

## What counts as prime in this range?
In the range from 0 to 15, the prime numbers are:

**2, 3, 5, 7, 11, 13**

For any other value (including 0 and 1), the output must be **0**.

## Inputs and Output
- **Input:** `N[3:0]` (binary number from switches)
- **Output:** `out` (1 = prime, 0 = not prime)

## Files
- `num_primos.v`  
  Combinational module that sets `out` high when `N` is prime.

- `num_primos_tb.v`  
  Testbench that tests all values of `N` from 0 to 15, prints results, and generates a `.vcd` waveform file.

## How the module works
The `num_primos` module uses a `case` statement to set:
- `out = 1` when `N` is 2, 3, 5, 7, 11, or 13
- `out = 0` for any other case

## Simulation

###  Icarus Verilog + GTKWave
```bash
iverilog -o sim num_primos.v num_primos_tb.v
vvp sim
gtkwave num_primos_tb.vcd
