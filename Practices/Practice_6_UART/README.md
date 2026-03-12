# Practice 6 - UART in Verilog

This project implements a basic **UART transmitter and receiver** in Verilog, together with a simulation testbench and top-level modules for FPGA testing.

The design uses:

- **50 MHz system clock**
- **9600 baud**
- **8 data bits**
- Standard UART frame format:
  - 1 start bit
  - 8 data bits
  - 1 stop bit

## Project Structure

| File | Description |
|------|-------------|
| `UART_Tx.v` | UART transmitter module |
| `UART_Rx.v` | UART receiver module |
| `UART_tb.v` | Testbench that connects TX and RX together |
| `top_tx.v` | Top module for FPGA transmission |
| `top_rx.v` | Top module for FPGA reception |
| `BCD.v` | Decoder from BCD digit to 7-segment display |
| `BCD_4display.v` | Converts an input value into thousands, hundreds, tens, and units for 4 displays |
| `UART.out` | Compiled simulation output |
| `UART_tb.vcd` | Waveform dump generated during simulation |

## Overview

This practice demonstrates how a UART communication system works at RTL level.

The project is divided into three main parts:

1. **UART transmitter (`UART_Tx`)**
2. **UART receiver (`UART_Rx`)**
3. **Verification through simulation (`UART_tb`)**

It also includes FPGA-ready top modules for sending and receiving bytes using board inputs and outputs.

---

## UART Transmitter

The transmitter module sends one byte serially through the `tx_out` line.

### Inputs
- `clk`: system clock
- `rst`: reset
- `data_in[7:0]`: byte to transmit
- `start`: transmission trigger

### Outputs
- `tx_out`: serial UART output
- `busy`: indicates transmission in progress

### Operation
The transmitter uses a finite state machine with the following states:

- `IDLE`
- `START_BIT`
- `DATA_BITS`
- `STOP_BIT`

When `start` is asserted, the module:
1. Loads `data_in` into an internal buffer
2. Sends a low start bit
3. Sends the 8 data bits LSB first
4. Sends a high stop bit
5. Returns to idle

---

## UART Receiver

The receiver module reconstructs the transmitted byte from the serial input `rx_in`.

### Inputs
- `clk`: system clock
- `rst`: reset
- `rx_in`: serial UART input

### Outputs
- `data_out[7:0]`: received byte
- `data_ready`: goes high when a byte is fully received

### Operation
The receiver includes:
- a **2-stage synchronizer** (`rx_sync1`, `rx_sync2`) to stabilize the asynchronous input
- a state machine with:
  - `IDLE`
  - `START_BIT`
  - `DATA_BITS`
  - `STOP_BIT`

The receiver:
1. Detects the falling edge of the start bit
2. Waits half a baud period to validate the start bit
3. Samples one bit every baud tick
4. Stores the 8 received bits
5. Copies the byte to `data_out`
6. Raises `data_ready`

---

## Simulation

The file `UART_tb.v` verifies the UART system by directly connecting transmitter and receiver:

- `tx_out` is assigned to `UART_wire`
- `UART_wire` is connected to `rx_in`

### Test sequence
The testbench sends these bytes:

- `55`
- `12`
- `24`

After each transmission, it waits for `data_ready` and prints the sent and received values.

It also generates:
- `UART_tb.vcd` for waveform visualization
- `UART.out` as simulation output

---

## How to Run the Simulation

Example with **Icarus Verilog**:

```bash
iverilog -o UART.out UART_tb.v UART_Rx.v UART_Tx.v
vvp UART.out
gtkwave UART_tb.vcd
