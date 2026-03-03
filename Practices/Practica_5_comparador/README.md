# MAX10 PWM + 4x 7-Segment Display (Angle Input 0–180) — Verilog Project

This Verilog design for an **Intel MAX10 FPGA** combines:

- A **BCD to 7-segment decoder** (`BCD`)
- A **4-display decimal driver** (`BCD_4display`) to show a number on `HEX3..HEX0`
- A **clock divider** (`clk_divide`) to generate a faster internal clock used for PWM timing
- A **PWM counter** (`counter`) that creates the PWM period ramp
- A **PWM comparator** (`comparador`) that maps an input value to a duty-cycle window (3%–12%)
- A **top module** (`pract5_w`) that connects switches, keys, displays, and PWM output
- A **testbench** (`comparador_tb`) to simulate the full system and generate a `.vcd` waveform

---

## What the project does

- You input a value using `SW[7:0]` (interpreted as an angle/value).
- The design **limits the maximum to 180**:
  - `SW_lim = (SW >= 180) ? 180 : SW;`
- The value `SW_lim` is displayed in decimal on **four 7-segment displays** (`HEX3..HEX0`).
- A PWM signal is generated on **`ARDUINO_IO[0]`**, where the **duty cycle increases linearly** as `SW_lim` goes from `0` to `180`.

This is commonly used for **servo-style PWM control** (0–180 degrees), or any application where a user-controlled value drives PWM width.

---

## Default PWM mapping (important)

Inside `comparador`, the PWM duty window is defined as:

- `min = 3%` of the PWM period  
- `max = 12%` of the PWM period  
- Linear interpolation over `0..180`

So:
- `in = 0`   → duty ≈ **3%**
- `in = 180` → duty ≈ **12%**

The comparator threshold is:
- `comp = min + (in * m)`
and output is:
- `out = (count < comp) ? 1 : 0;`

---

## File / module structure

### `BCD`
Converts one digit (0–9) into a 7-segment pattern.

- **Input:** `BCD_in[3:0]`
- **Output:** `BCD_out[0:6]`

Includes a blank/default pattern (`111_1111`) for invalid digits.

---

### `BCD_4display`
Splits an integer into:
- units, tens, hundreds, thousands  
using `/` and `%`, and drives 4 instances of `BCD`.

- **Input:** `bcd_in` (default width `N_in=10`)
- **Outputs:** `D_un, D_de, D_ce, D_mi`

---

### `clk_divide`
Generates a divided clock `clk_div` from `MAX10_CLK1_50`.

**Corrected constants (your version):**
- `CLK_FREQ = 50_000_000`

`constantnum = CLK_FREQ / (2 * FREQ)`  
`clk_div` toggles every `constantnum` cycles.

> Tip: If you want a slow clock (like 5 Hz), set `FREQ = 5`.  
> In this project, the divider is used to generate a **fast internal clock** for PWM timing (e.g., MHz range), depending on your chosen `FREQ`.

---

### `counter`
Creates the PWM ramp counter.

- Resets to 0 on `rst`
- Counts up until `CLK_FREQ/pwm`, then resets

This defines the PWM period in clock ticks.

---

### `comparador`
Generates PWM by comparing the ramp counter against a computed threshold `comp`.

- Computes `min`, `max`, and slope `m`
- Updates `comp` each clock based on input `in`
- Outputs `out = 1` while `count < comp`

---

### `pract5_w` (Top Module)
Top-level wiring for the MAX10 board.

**Inputs**
- `MAX10_CLK1_50` : 50 MHz clock
- `KEY[1:0]`      : buttons
- `SW[7:0]`       : angle/value input (clamped to 180)

**Outputs**
- `ARDUINO_IO[0]` : PWM output
- `HEX0..HEX3`    : decimal display of `SW_lim`
- `HEX4..HEX5`    : forced off

Reset:
- `rst = ~KEY[0]` (active-low button)

Clock divider:
- Generates `clk_5mhz` (name is just a label; actual freq depends on `FREQ`)

Display bit mapping:
- `D_un[6:0]` is rearranged into `HEX0[0:6]` (and same for HEX1–HEX3)
- `HEXx[7]` is forced to `1` (typically DP/off)

---

## How to use on hardware (MAX10)

1. Compile in Quartus.
2. Set the **top-level entity** to `pract5_w`.
3. Assign pins:
   - `MAX10_CLK1_50` → board clock pin
   - `KEY[0]` → reset button
   - `SW[7:0]` → 8 switches
   - `HEX0..HEX5` → seven-seg pins
   - `ARDUINO_IO[0]` → your chosen Arduino header pin

### Operation
- Change `SW[7:0]` to set the value (0–180 effective).
- Watch the value on `HEX3..HEX0`.
- Measure PWM at `ARDUINO_IO[0]` (oscilloscope / logic analyzer).

---

## Simulation (Testbench)

### `comparador_tb`
The testbench instantiates the **top module** `pract5_w`, generates a clock, applies button pulses, changes `SW`, prints debug messages, and dumps a waveform.

Outputs:
- `comparador_tb.vcd`

### Example (iverilog)
Compile:
```bash
iverilog -g2012 -o sim your_file.v
