# Lab 3 – Up/Down Counter with Load and 4×7-Segment Display (MAX10)

This project implements a digital system in Verilog for an **Intel MAX10** FPGA that includes:
- A **clock divider** to slow down the main FPGA clock.
- An **up/down counter** (increment/decrement mode).
- A **load** feature to load a value from switches.
- A module to display the counter value on **four 7-segment displays** (units, tens, hundreds, thousands).

---

## Module Structure

### 1) `clk_divide`
**Goal:** generate a slow clock (`clk_div`) from the FPGA main clock.

- Inputs:
  - `clk`: base clock (e.g., 50 MHz)
  - `rst`: asynchronous reset
- Output:
  - `clk_div`: divided clock

**Parameters:**
- `CLK_FREQ`: base clock frequency (default `50_000_000`)
- `FREQ`: target divided frequency (default ~`5` Hz)

---

### 2) `count`
**Goal:** 8-bit counter with:
- **Reset** → sets the counter to 0
- **Load** (active when `load == 0`) → loads `data_in` (with a maximum limit)
- **Up/Down**:
  - `up_down = 0` increments
  - `up_down = 1` decrements
- **Wrap-around**:
  - When counting up and reaching 100 → wraps to 0
  - When counting down and reaching 0 → wraps to 100
- **Load saturation**:
  - if `data_in > 100`, it loads `100`
  - otherwise it loads `data_in`

**Inputs:**
- `clk`, `rst`
- `up_down`
- `load`
- `data_in[6:0]`

**Output:**
- `counter[7:0]`

---

### 3) `BCD_4display`
**Goal:** convert a binary input number into 4 BCD digits (units, tens, hundreds, thousands) and drive four 7-seg displays.

**Input:**
- `bcd_in` (default 10 bits, connected to the counter value)

**Outputs:**
- `D_un`, `D_de`, `D_ce`, `D_mi` (each is a 7-bit bus for one display)

**How it works:**
- Computes:
  - `units = bcd_in % 10`
  - `tens = (bcd_in / 10) % 10`
  - `hundreds = (bcd_in / 100) % 10`
  - `thousands = (bcd_in / 1000) % 10`
- Each digit is then sent to a `BCD` module to generate the 7-segment pattern.

> Note: the `BCD` module (BCD digit → 7-segment outputs) must be included in the project to compile.

---

### 4) `main`
**Goal:** integrate the full system:
- divides the clock
- runs the counter
- sends the counter value to the 4 displays

**Inputs:**
- `clk`
- `rst`
- `up_down`
- `load`
- `data_in[6:0]`

**Outputs:**
- `D_un`, `D_de`, `D_ce`, `D_mi`

---

### 5) `main_w` (MAX10 Wrapper)
**Goal:** connect `main` to typical MAX10 board pins:
- `MAX10_CLK1_50` as the main clock
- `KEY` as push-buttons
- `SW` as switches
- `HEX0..HEX3` as the 7-segment displays

**Connections used:**
- `clk` → `MAX10_CLK1_50`
- `rst` → `~KEY[0]` (active-low reset button)
- `load` → `KEY[1]`
- `up_down` → `SW[9]`
- `data_in` → `SW[6:0]`
- Displays:
  - `HEX0` = units
  - `HEX1` = tens
  - `HEX2` = hundreds
  - `HEX3` = thousands

---

## Inputs and Control (Quick Summary)

- **Reset**: resets the counter to 0.
- **Load (active-low)**: loads `data_in` into the counter (limited to 100).
- **Up/Down**:
  - `0` → counts up (0 → 100 → 0)
  - `1` → counts down (100 → 0 → 100)

---

## Build Requirements

Make sure your project includes:
- `clk_divide.v`
- `count.v`
- `BCD_4display.v`
- `main.v`
- `main_w.v`
- **`BCD.v`** (4-bit BCD to 7-segment decoder)

---

## Expected Output

The current counter value is shown on the four 7-segment displays:
- HEX0: units
- HEX1: tens
- HEX2: hundreds
- HEX3: thousands

Since the counter is limited to 0–100, you will typically see values from `0000` to `0100`.

---
