# VGA Pattern Generator

## Overview

This project contains two Verilog modules that work together to generate a simple VGA video output. The design creates a visible pattern on the screen using standard VGA timing for a **640x480 @ 60 Hz** display.

The two files are:

- `vga.v` → generates VGA synchronization signals and pixel coordinates
- `vga_demo.v` → uses those coordinates to draw a checkerboard-style pattern

This is a simple and useful starting point for learning how VGA works in FPGA-based designs.

---

## File Descriptions

## 1. `vga.v`

This module is responsible for generating the VGA timing signals and tracking the current pixel position on the screen.

### Inputs

- `clk`  
  Main FPGA clock.

- `pixel_tick`  
  Slower pixel enable signal used to update VGA timing at the pixel rate.

### Outputs

- `vga_h_sync`  
  Horizontal sync signal for the VGA monitor.

- `vga_v_sync`  
  Vertical sync signal for the VGA monitor.

- `inDisplayArea`  
  High when the current pixel is inside the visible 640x480 region.

- `CounterX`  
  Current horizontal pixel counter.

- `CounterY`  
  Current vertical pixel counter.

### What it does

This module implements standard VGA timing using horizontal and vertical counters.

#### Horizontal timing
The horizontal counter goes from `0` to `799`, which includes:

- 640 visible pixels
- 16 front porch pixels
- 96 sync pulse pixels
- 48 back porch pixels

Total: **800 counts per line**

#### Vertical timing
The vertical counter goes from `0` to `524`, which includes:

- 480 visible lines
- 10 front porch lines
- 2 sync pulse lines
- 33 back porch lines

Total: **525 lines per frame**

### Internal behavior

- `CounterX` increments on each `pixel_tick`
- when `CounterX` reaches the end of a line, it resets to zero
- `CounterY` increments once per completed line
- horizontal and vertical sync signals are generated according to VGA timing
- `inDisplayArea` becomes high only when:
  - `CounterX < 640`
  - `CounterY < 480`

### Notes

The sync outputs are inverted at the end because VGA sync signals are active low.

```verilog
assign vga_h_sync = ~vga_HS;
assign vga_v_sync = ~vga_VS;