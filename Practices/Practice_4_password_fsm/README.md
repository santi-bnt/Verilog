# Password FSM Lock (MAX10) — Clock Divider + BCD + Testbench (Verilog)

This project implements a simple **4-digit password lock** on an **Intel MAX10 FPGA** using Verilog.  
It includes:

- `clk_divider`: divides the 50 MHz board clock to a slow clock (default **5 Hz**).
- `BCD`: converts a 4-bit digit (0–9) into a **7-segment** output pattern.
- `password_fsm`: a **finite state machine** that validates a 4-digit password entered via switches and confirmed with a button.
- `password_fsm_tb`: a **complete testbench** that drives the design, generates a waveform (`.vcd`), and prints activity to the console.

---

## How it works

1. You set a digit using `SW[3:0]`.
2. You press the **NEXT** button (`KEY[0]`) to capture that digit.
3. The FSM compares each captured digit to the stored password:
   - Default password: **2-0-2-6** (`4'h2, 4'h0, 4'h2, 4'h6`)
4. If any digit is wrong → the FSM enters **bad** and stays there.
5. If all four digits match → the FSM enters **good** and stays there.
6. Displays:
   - **good** → shows `"good"` on `HEX3..HEX0`
   - **bad** → shows `"bAd"` (one display blank)

Reset (`KEY[1]`) returns the FSM to `IDLE` and clears the displays.

---

## Project structure

- `clk_divider.v`
- `BCD.v`
- `password_fsm.v`
- `password_fsm_tb.v`

(You can keep them in one file or separate files—both work as long as Quartus/iverilog compiles them.)

---

## Modules

### `clk_divider #(parameter FREQ=5)`
Generates a slow clock `clk_div` from the 50 MHz clock.

- **Parameter**
  - `FREQ` (Hz): default `5`
- **Inputs**
  - `clk` : base clock (50 MHz)
  - `rst` : async reset
- **Output**
  - `clk_div` : divided clock

Internally uses:
- `CLK_FREQ = 50_000_000`
- `ConstantNumber = CLK_FREQ/(2*FREQ)`

---

### `BCD`
BCD (0–9) → 7-segment decoder.

- **Input**: `bcd_in[3:0]`
- **Output**: `bcd_out[0:6]`

The code uses `~7'b...` patterns (active-low segments), matching typical MAX10 display wiring.

---

### `password_fsm`
Main lock controller (FSM).

- **Inputs**
  - `SW[3:0]` digit
  - `KEY[1:0]` buttons  
    - `KEY[1]` reset (active-low)
    - `KEY[0]` next/confirm (active-low)
  - `MAX10_CLK1_50` 50 MHz clock
- **Outputs**
  - `HEX0..HEX3` 7-segment displays

#### States
`IDLE → DIG1 → DIG2 → DIG3 → DIG4 → good`  
Any mismatch goes to `bad`.

---

## Default password

The password is hardcoded as:

- **2 0 2 6**

In code:
```verilog
parameter[3:0] passw_dig1=4'h2, passw_dig2=4'h0, passw_dig3=4'h2, passw_dig4=4'h6;
