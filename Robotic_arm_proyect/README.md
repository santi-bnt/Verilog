# Robotic Arm Controller with Accelerometer on FPGA

This project implements a robotic arm controller in Verilog using an accelerometer as the main input device. The system reads motion data from the accelerometer, converts it into angle values, and generates PWM signals to control the robotic arm joints and gripper.

The design is intended for an Intel MAX 10 / DE10-Lite FPGA board and was developed in Quartus Prime.

---

## Overview

The robotic arm can be controlled in two different ways:

- **Live mode**: the arm follows the current movement of the accelerometer
- **Playback mode**: the arm reproduces positions that were previously stored in memory

The project also includes:

- PWM control outputs for the robotic arm
- Position storage in memory
- Automatic playback of saved positions
- 7-segment display output
- VGA visualization
- LED-based debugging

This makes the project a complete embedded digital system that combines sensor input, memory, control logic, display logic, and actuator outputs.

---

## Main Features

- Accelerometer-based motion control
- 4 PWM outputs for robotic arm control
- Memory for saving arm positions
- Playback of saved movement states
- Manual gripper control
- VGA signal generation
- 7-segment display feedback
- Address counter for stored states
- FPGA implementation in Verilog

---

## How It Works

The system reads accelerometer data from the X, Y, and Z axes through an SPI-based interface. Those values are sampled and converted into angle values that represent the desired position of the robotic arm.

Each axis is mapped into an 8-bit angle value. These values are then used to generate PWM pulses for servo-style control signals.

The arm has four outputs:

- **X axis**
- **Y axis**
- **Z axis**
- **Gripper**

The user can choose whether the arm should:

1. Follow the accelerometer directly
2. Move according to positions stored in memory

---

## System Architecture

The project is organized around the `accel` top module, which integrates the following blocks:

- PLL for internal clock generation
- SPI controller for accelerometer communication
- Angle conversion and PWM generation
- State memory
- Address counter
- Button pulse conditioning
- VGA display
- 7-segment display logic

At a high level, the data flow is:

1. The accelerometer provides `data_x`, `data_y`, and `data_z`
2. Values are sampled and stored in registers
3. Data is converted to angle values
4. A mode selector chooses between:
   - live accelerometer data
   - memory-stored angles
5. PWM signals are generated
6. Outputs are sent to the robotic arm
7. Current information is also shown on displays

---

## Top Module

The top-level entity of the project is:

```text
accel
```

This module connects all major parts of the system and maps them to the FPGA board peripherals.

---

## Main Modules

### `accel.v`

Top-level module of the project.

Responsibilities:

- Connects the accelerometer interface
- Samples sensor data
- Instantiates the angle and PWM conversion module
- Controls memory and playback
- Drives VGA output
- Drives 7-segment displays
- Assigns the PWM outputs to FPGA pins

### `comparador.v`

This module converts the sampled accelerometer data into angle values and generates PWM outputs.

It:

- Computes angles for X, Y, and Z
- Selects between live angles and memory angles
- Controls the gripper angle
- Generates four PWM output signals

### `counter.v`

Counter used as the PWM timing base.

It continuously counts from 0 up to the PWM period limit and then resets, allowing pulse width comparison for servo control.

### `counter_mem.v`

Memory address counter.

It increments the address used to store or replay robotic arm positions.

### `clk_divider_parameter.v`

Parameterized clock divider.

Used to generate slower clocks for refresh or control timing.

---

## Inputs and Outputs

### Inputs

#### Clocks
- `ADC_CLK_10`
- `MAX10_CLK1_50`
- `MAX10_CLK2_50`

#### Buttons
- `KEY[0]` -> reset / system reference
- `KEY[1]` -> save current position

#### Switches
- `SW[0]` -> mode selector
- `SW[1]` -> gripper control
- `SW[9:2]` -> available for future extensions

#### Accelerometer interface
- `GSENSOR_CS_N`
- `GSENSOR_SCLK`
- `GSENSOR_SDI`
- `GSENSOR_SDO`
- `G_SENSOR_INT`

### Outputs

#### Robotic arm PWM outputs
- `ARDUINO_IO[0]` -> PWM for Z axis
- `ARDUINO_IO[1]` -> PWM for Y axis
- `ARDUINO_IO[2]` -> PWM for X axis
- `ARDUINO_IO[3]` -> PWM for gripper

#### Displays
- `HEX0`
- `HEX1`
- `HEX2`
- `HEX3`
- `HEX4`
- `HEX5`

#### LEDs
- `LEDR[9:0]`

#### VGA
- `VGA_R`
- `VGA_G`
- `VGA_B`
- `VGA_HS`
- `VGA_VS`

---

## Memory Operation

The design stores one robotic arm position as a 32-bit word:

```text
{angle_x, angle_y, angle_z, angle_g}
```

Each angle uses 8 bits.

The memory address is controlled by a 3-bit counter, which allows the system to store up to 8 positions.

This makes it possible to save a movement sequence and reproduce it later.

---

## Control Modes

### Live Mode

In this mode, the robotic arm follows the current orientation of the accelerometer in real time.

### Playback Mode

In this mode, the system reads previously stored positions from memory and sends them to the robotic arm automatically.

---

## PWM Generation

The PWM generation is based on a counter and a pulse-width comparison method.

Each angle value is translated into a pulse width suitable for servo-style control. This allows the robotic arm joints to move according to the calculated or stored angles.

---

## Display and Debug Support

The project includes visual feedback through multiple outputs:

- **7-segment displays** for numeric monitoring
- **LEDs** for debug visualization
- **VGA output** for angle or motion display

This helps during testing, calibration, and demonstration of the project.

---

## FPGA Platform

This project is designed for:

- Intel MAX 10
- DE10-Lite FPGA board
- Quartus Prime

---

## Dependencies

The top-level design references several additional modules and IP blocks, including:

- `PLL`
- `spi_control`
- `one_shot`
- `fsm_brazo`
- `mem`
- `tick_1hz`
- `VGACounterDemo`
- `seg7`

Make sure these files or generated IP blocks are included in the Quartus project before compiling.

---

## Applications

This project can be used as a base for:

- FPGA robotic arm control
- Motion-controlled embedded systems
- Accelerometer-to-servo digital interfaces
- Mechatronics demonstrations
- Position recording and playback systems

