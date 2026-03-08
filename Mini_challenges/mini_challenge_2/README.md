# mini_challenge2

## Overview

This project implements **Mini Challenge 2**, where an FPGA-based **Pong game** is controlled using data from an **accelerometer** transmitted through **UART**.

The system is divided into two boards:

- **Transmitter board**: reads the accelerometer values, converts them into a usable 8-bit control value, and sends that value through UART.
- **Receiver board**: runs the Pong game, receives the UART data, and uses it to control one of the paddles.

This challenge combines:
- accelerometer interfacing
- synchronous digital design
- UART serial communication
- VGA video generation
- real-time game logic on FPGA

---

## Objective

The goal of this mini challenge is to:

1. Read motion data from the onboard accelerometer.
2. Convert that data into a simplified control signal.
3. Transmit the control signal through UART to another FPGA board.
4. Receive the signal on the second board.
5. Use the received value to move a Pong paddle in real time.

---

## System Architecture

### Board 1: Transmitter
The transmitter board performs the following tasks:

- interfaces with the accelerometer using SPI
- reads the X, Y, and Z axis data
- stores the sampled data in registers
- converts one axis into an 8-bit angle/control value
- sends that value using a UART transmitter

### Board 2: Receiver
The receiver board performs the following tasks:

- receives UART serial data from the transmitter board
- decodes the received byte using a UART receiver
- feeds the received value into the Pong game logic
- updates one paddle position based on the received value
- generates VGA output for the game display

---

## Main Modules

### Transmitter Side

#### `accel`
Top-level module for the transmitter board.

Responsibilities:
- initialize the accelerometer interface
- sample accelerometer outputs
- instantiate the converter
- instantiate the UART transmitter
- send the selected control value to the other FPGA board

#### `spi_control`
Communicates with the onboard accelerometer through SPI and provides axis data.

Outputs:
- `data_x`
- `data_y`
- `data_z`

#### `convertidor`
Converts signed accelerometer values into 8-bit control values.

Example behavior:
- reads `data_x_reg`
- computes an angle-like output such as `angle_x`
- provides a simple byte that can be sent through UART

#### `UART_Tx`
UART transmitter module.

Responsibilities:
- waits for `start`
- serializes the input byte
- sends:
  - start bit
  - 8 data bits
  - stop bit

---

### Receiver Side

#### `top_w`
Wrapper for the FPGA receiver board.

Responsibilities:
- connects physical board pins
- maps DE10-Lite inputs and outputs
- instantiates the game top module
- routes VGA, switches, keys, seven-segment displays, and UART input

#### `top`
Main top module of the Pong game.

Responsibilities:
- instantiate VGA timing
- instantiate render logic
- instantiate ball and paddle modules
- instantiate score logic
- instantiate UART receiver
- pass received UART data into paddle control

#### `UART_Rx`
UART receiver module.

Responsibilities:
- detect start bit
- sample incoming serial data
- reconstruct the received 8-bit value
- raise `data_ready` when a full byte is available

#### `paddle`
Controls the paddles.

In this challenge:
- one paddle can still use button input
- the other paddle is controlled by the UART-received value

#### `ball`
Implements:
- ball movement
- paddle collision
- wall collision
- score updates

#### `vga_sync`
Generates VGA timing signals:
- horizontal sync
- vertical sync
- pixel position
- visible area flag

#### `render`
Draws:
- paddle 1
- paddle 2
- ball
- background
- win screen colors depending on game state

#### `seven_seg`
Displays both player scores on the seven-segment displays.

#### `game_state`
Tracks the current game condition:
- idle/reset
- playing
- player 1 win
- player 2 win

#### `clock_divider`
Generates a slower clock used for game timing updates.

---

## UART Communication

### Transmitted Data
Only **one 8-bit control value** is transmitted.

Instead of sending full raw accelerometer data for all axes, the design sends a simplified byte, usually derived from one axis such as:

- `angle_x`

This keeps the design simpler and easier to debug.

### Why only one byte?
For Pong, only one paddle movement value is needed. Sending a single byte:
- reduces complexity
- simplifies receiver logic
- avoids unnecessary packet formatting
- is enough to control vertical paddle position

---

## Paddle Control Strategy

The original Pong project uses button inputs to move paddles up and down.

For this mini challenge, one paddle is modified so that its vertical position is updated from the UART-received byte.

A simple scaling relation is used to map the received value into the screen height, for example:

- input range: `0 to 255`
- screen movement range: limited valid paddle area

This allows the paddle to move smoothly based on the accelerometer tilt.

---

## Board Connections

### Required UART Connection
The UART connection between boards must include:

- **TX from Board 1** connected to **RX on Board 2**
- **GND from Board 1** connected to **GND on Board 2**

Without a common ground, UART communication may fail.

---

## Reset Behavior

Reset initializes the system to a known state.

### Transmitter reset:
- clears converted outputs
- resets UART transmitter logic

### Receiver reset:
- resets game state
- resets ball and paddle positions
- clears UART receiver outputs

---

## How It Works

### Transmitter flow
1. Accelerometer data is read through SPI.
2. The selected axis is sampled and stored.
3. The value is converted into an 8-bit control byte.
4. UART transmitter sends the byte serially.

### Receiver flow
1. UART receiver listens for incoming serial data.
2. A byte is reconstructed from the serial stream.
3. The received byte is passed into paddle logic.
4. The paddle position is updated.
5. VGA logic displays the updated game state.

---

## Design Notes

- The system uses **synchronous logic** wherever possible.
- UART communication is implemented with separate transmitter and receiver modules.
- The receiver only needs one byte to control the paddle.
- A wrapper module is used on the receiver side to adapt the original Pong project to the FPGA board pins.
- Seven-segment outputs are expanded to 8 bits by disabling the decimal point.

---

## Files and Functional Blocks

Typical project structure:

### Transmitter
- `accel.v`
- `convertidor.v`
- `UART_Tx.v`
- supporting accelerometer modules such as PLL and SPI controller

### Receiver
- `top_w.v`
- `top.v`
- `UART_Rx.v`
- `paddle.v`
- `ball.v`
- `render.v`
- `vga_sync.v`
- `game_state.v`
- `seven_seg.v`
- `clock_divider.v`

---

## Results

This mini challenge demonstrates that:
- sensor data can be acquired from an onboard accelerometer
- the data can be transformed into a compact control signal
- UART can reliably transmit that signal between FPGA boards
- a real-time game can be controlled using motion data from a second board

The final result is a Pong system where one board acts as the motion-based controller and the other board runs the game display.

---

## Conclusion

Mini Challenge 2 integrates multiple digital design concepts into a single FPGA application. By combining accelerometer input, UART communication, and VGA-based game rendering, the project demonstrates how sensor-driven external control can be used in an interactive digital system.

This challenge is a practical example of embedded digital design, modular hardware development, and communication between independent FPGA systems.
