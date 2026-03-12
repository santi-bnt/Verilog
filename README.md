# Verilog

Collection of Verilog projects, laboratory practices, mini challenges, and FPGA-based digital designs developed for simulation and hardware implementation.

This repository includes combinational and sequential logic, finite state machines, UART communication, VGA video generation, PWM control, accelerometer-based systems, and complete FPGA projects built mainly for Intel MAX 10 / DE10-Lite boards.

---

## Overview

This repository is organized into three main sections:

- **Mini_challenges**  
  Shorter integrated projects that combine multiple digital design topics.

- **Practices**  
  Step-by-step laboratory exercises covering important Verilog and FPGA concepts.

- **Proyect_verilog**  
  A larger final-style project focused on a robotic arm controller using an accelerometer.

The repository mixes:

- RTL modules
- testbenches
- waveform files
- FPGA wrappers
- Quartus project files
- hardware-oriented top modules

---

## Repository Structure

```text
Verilog/
├── Mini_challenges/
│   ├── mini_challenge_1/
│   └── mini_challenge_2/
├── Practices/
│   ├── Practice_1_prime_numbers/
│   ├── Practice_2_BCD4display/
│   ├── Practice_3_counter/
│   ├── Practice_4_password_fsm/
│   ├── Practice_5_comparator/
│   ├── Practice_6_UART/
│   └── Practice_7_vga_chees/
└── Proyect_verilog/
    └── Accelerometer/
       
```

---

## Contents

## Mini Challenges

### Mini Challenge 1 — Button Debouncer
Implements a temporal debouncer in Verilog to clean noisy mechanical push-button signals.

Main ideas:
- stable-input filtering
- counter-based debouncing
- FPGA wrapper integration
- simulation with waveform generation

Typical files:
- `mini_challenge.v`
- `mini_challenge_w.v`
- `mini_challenge_tb.v`

---

### Mini Challenge 2 — Pong Controlled by Accelerometer through UART
A two-board FPGA system where one board reads accelerometer data and sends a control byte over UART, while the second board runs a Pong game and uses the received value to move a paddle.

Main ideas:
- accelerometer interfacing
- UART transmission and reception
- VGA video generation
- real-time game logic on FPGA

This challenge combines:
- sensor input
- serial communication
- game rendering
- FPGA hardware integration

---

## Practices

### Practice 1 — Prime Number Detector
A combinational Verilog design that reads a 4-bit input value and determines whether the number is prime in the range 0 to 15.

Concepts:
- combinational logic
- `case` statements
- simple FPGA switch-to-LED mapping
- full testbench validation

Typical files:
- `num_primos.v`
- `num_primos_tb.v`

---

### Practice 2 — BCD to 4-Digit 7-Segment Display
Converts a binary value into decimal digits and drives four 7-segment displays through a BCD decoder.

Concepts:
- BCD decoding
- decimal digit extraction
- 7-segment display driving
- optional FPGA wrapper
- randomized simulation

Typical files:
- `BCD.v`
- `BCD_4display.v`
- `BCD_4display_tb.v`
- `BCD_4display_w.v`

---

### Practice 3 — Up/Down Counter with Load and 4 Displays
Implements a counter system for FPGA with load control, direction control, and display output.

Concepts:
- clock division
- sequential logic
- up/down counter design
- bounded counting
- seven-segment display integration

Typical files:
- `clk_divide.v`
- `count.v`
- `main.v`
- `main_tb.v`
- `main_w.v`

---

### Practice 4 — Password FSM Lock
A finite state machine that validates a 4-digit password entered from switches and buttons and shows the result on 7-segment displays.

Concepts:
- finite state machines
- input sequencing
- password validation
- active-low FPGA buttons
- display-based status feedback

Typical files:
- `clk_divider.v`
- `BCD.v`
- `password_fsm.v`
- `password_fsm_tb.v`

---

### Practice 5 — PWM Comparator with 4 Displays
Maps an input value, typically interpreted as an angle from 0 to 180, into a PWM output suitable for servo-style control and displays the value on 7-segment displays.

Concepts:
- PWM generation
- comparator-based pulse width control
- input limiting
- angle-to-duty mapping
- FPGA output control

Typical files:
- `comparador.v`
- `counter.v`
- `clk_divide.v`
- `BCD.v`
- `BCD_4display.v`
- `comparador_tb.v`
- `pract5_w.v`

---

### Practice 6 — UART Transmitter and Receiver
Implements a basic UART communication system with independent transmitter and receiver modules, simulation, and top modules for FPGA testing.

Concepts:
- serial communication
- baud-rate timing
- finite state machines
- asynchronous input synchronization
- transmitter/receiver verification

Typical files:
- `UART_Tx.v`
- `UART_Rx.v`
- `UART_tb.v`
- `top_tx.v`
- `top_rx.v`

---

### Practice 7 — VGA Pattern Generator
Introduces VGA timing and drawing logic through a pattern generator that produces a checkerboard-style image for a 640x480 display.

Concepts:
- VGA synchronization
- pixel coordinate generation
- visible-area logic
- simple graphics rendering on FPGA

Typical files:
- `vga.v`
- `vga_demo.v`

---

## Main Project

### Robotic Arm Controller with Accelerometer
The main project in this repository is an FPGA-based robotic arm controller that uses an accelerometer as the input source.

The system:
- reads accelerometer data
- converts motion into angle values
- generates PWM signals for multiple outputs
- supports position storage and playback
- includes VGA and display support

Main visible files in the project folder:
- `accel.v`
- `comparador.v`
- `counter.v`
- `counter_mem.v`
- `clk_divider_parameter.v`
- Quartus project files such as `.qpf`, `.qsf`, and `.tcl`

This project represents a larger system integration effort combining:
- sensor interfacing
- PWM control
- memory
- counters
- display systems
- FPGA hardware mapping

---

## Topics Covered

Across the repository, the projects cover:

- combinational logic
- sequential logic
- counters
- finite state machines
- debouncing
- BCD and 7-segment displays
- PWM generation
- UART communication
- VGA timing and rendering
- accelerometer interfacing
- FPGA top-level integration
- testbench-based verification

---

## Tools and Workflow

These projects are intended to be used with tools such as:

- **Quartus Prime** for FPGA synthesis and board implementation
- **Icarus Verilog** for simulation
- **GTKWave** for waveform visualization

Many folders include:
- `.v` source files
- `_tb.v` testbenches
- `.vcd` waveform files
- `.out` simulation outputs
- FPGA wrapper modules

---

## How to Simulate

A typical simulation flow with Icarus Verilog is:

```bash
iverilog -o sim module.v module_tb.v
vvp sim
gtkwave module_tb.vcd
```
