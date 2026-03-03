# Mini Challenge — Button Debouncer (Temporal Filter in Verilog)

This mini challenge implements a **software debouncer** in Verilog.  
The goal is to **filter the mechanical bounce** of a push button (a noisy signal with fast, unstable transitions) and generate a clean output that can be safely used in a digital design.

Instead of an RC (hardware) debouncer, this project uses a **temporal filter**:  
the output only changes after the input has remained stable for a required number of clock cycles.

---

## Project Files

- **`mini_challenge.v`**  
  Main module (temporal debouncer).

- **`mini_challenge_w.v`**  
  Wrapper module to integrate the debouncer into a larger top-level design (e.g., FPGA).

- **`mini_challenge_tb.v`**  
  Testbench used to simulate the debouncer behavior with randomized button input.

---

## How the Debouncer Works

### Key idea
A push button may toggle rapidly between `0` and `1` for a short time when pressed or released.  
To avoid interpreting these bounces as multiple presses, we require the signal to be stable for a certain time.

### Core logic (from `mini_challenge.v`)
- `out` is the **debounced output**.
- `cnt` counts how long the input has been consistently different from the current output.
- If the input matches the output (`in == out`), the counter resets to `0`.
- If the input stays different long enough (counter reaches its maximum), the output updates.

---

## Parameters

The module uses:

- `N` (default `4`): counter width  
  This means the input must remain stable for **2^N clock cycles** (approximately) before `out` updates.

Example:
- `N = 4` → requires 16 stable cycles
- `N = 6` → requires 64 stable cycles (stronger filtering)

---

## Simulation (Icarus Verilog)

Compile:

```bash
iverilog mini_challenge_tb.v mini_challenge.v mini_challenge_w.v
