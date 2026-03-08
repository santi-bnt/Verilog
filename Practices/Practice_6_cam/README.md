# CAM Search Using Counter and `memo.hex`

## Overview

This project implements a simple **Content Addressable Memory (CAM)-style search** in Verilog using:

- a memory initialized from `memo.hex`
- a counter to scan memory addresses sequentially
- a CAM module that compares the input search value against the current memory word
- a testbench to verify the design

Unlike a fully parallel CAM, this version does **not** compare against all memory locations at the same time. Instead, it checks **one memory position per clock cycle** using a counter.

This version is useful for understanding:
- memory initialization with `$readmemh`
- sequential search in hardware
- address scanning with a counter
- CAM-like matching behavior over multiple clock cycles

---

## Files

- `cam.v`  
  Main CAM search module

- `counter.v`  
  Address counter used to scan memory positions

- `cam_tb.v`  
  Testbench used to simulate the CAM

- `memo.hex`  
  Memory initialization file containing hexadecimal data

---

## Design Idea

The system works as follows:

1. The memory contents are loaded from `memo.hex`.
2. A counter generates addresses from `0` to `255`.
3. On each clock cycle, the CAM checks the current memory location.
4. If the value stored at that address matches `search_data`, the module asserts `match`.
5. The counter continues scanning memory sequentially.

This means the design checks:

- cycle 1 → compare `search_data` with `mem[0]`
- cycle 2 → compare `search_data` with `mem[1]`
- cycle 3 → compare `search_data` with `mem[2]`
- ...
- cycle 256 → compare `search_data` with `mem[255]`

So this is a **sequential search**, not a parallel search.

---

## Module Descriptions

## 1. `counter.v`

This module generates the address used to scan the memory.

### Purpose
It increments once every clock cycle and cycles through all 256 addresses.

### Example behavior
- after reset: `count = 0`
- next clock: `count = 1`
- next clock: `count = 2`
- ...
- after `255`: it wraps around to `0`

### Typical implementation
```verilog
module counter #(parameter ADDR_WIDTH = 8)(
    input clk,
    input rst,
    output reg [ADDR_WIDTH-1:0] count
);

always @(posedge clk or posedge rst) begin
    if (rst)
        count <= 0;
    else
        count <= count + 1;
end

endmodule