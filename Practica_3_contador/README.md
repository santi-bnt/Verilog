# Practica 3 – Contador Up/Down con Load y Display 4x7-Segmentos (MAX10)

Este proyecto implementa un sistema digital en Verilog para una FPGA **Intel MAX10** que incluye:
- Un **divisor de reloj** para bajar la frecuencia del clock principal.
- Un **contador** con modo **incremento/decremento (up/down)**.
- Una función de **carga (load)** para cargar un valor desde switches.
- Un módulo para mostrar el valor del contador en **4 displays de 7 segmentos** (unidades, decenas, centenas y millares).

---

## Estructura de módulos

### 1) `clk_divide`
**Objetivo:** generar un reloj lento (`clk_div`) a partir del reloj principal de la FPGA.

- Entradas:
  - `clk`: reloj base (ej. 50 MHz).
  - `rst`: reset asíncrono.
- Salida:
  - `clk_div`: reloj dividido.

**Parámetros:**
- `CLK_FREQ`: frecuencia del reloj base (por defecto `50_000_000`).
- `FREQ`: frecuencia deseada para el reloj dividido (por defecto `5` Hz aprox).

---

### 2) `count`
**Objetivo:** contador de 8 bits con:
- **Reset** → pone el contador en 0
- **Load** (activo cuando `load == 0`) → carga `data_in` (con límite máximo)
- **Up/Down**:
  - `up_down = 0` incrementa
  - `up_down = 1` decrementa
- **Wrap-around**:
  - Si sube y llega a 100 → vuelve a 0
  - Si baja y llega a 0 → vuelve a 100
- **Saturación al cargar**:
  - si `data_in > 100`, se carga `100`
  - si no, se carga `data_in`

**Entradas:**
- `clk`, `rst`
- `up_down`
- `load`
- `data_in[6:0]`

**Salida:**
- `counter[7:0]`

---

### 3) `BCD_4display`
**Objetivo:** convertir un número binario de entrada a 4 dígitos BCD (unidades, decenas, centenas, millares) y mandarlos a 4 displays.

**Entradas:**
- `bcd_in` (por defecto 10 bits, pero se conecta al `counter`)

**Salidas:**
- `D_un`, `D_de`, `D_ce`, `D_mi` (cada una es un bus de 7 bits para un display)

**Funcionamiento:**
- Calcula:
  - `unidades = bcd_in % 10`
  - `decenas = (bcd_in/10) % 10`
  - `centenas = (bcd_in/100) % 10`
  - `milares = (bcd_in/1000) % 10`
- Luego manda cada dígito a un módulo `BCD` para obtener el patrón de 7 segmentos.

> Nota: el módulo `BCD` (dígito BCD → 7 segmentos) debe existir en tu proyecto para que compile.

---

### 4) `main`
**Objetivo:** integrar el sistema completo:
- divide el reloj
- ejecuta el contador
- manda el valor del contador a los 4 displays

**Entradas:**
- `clk`
- `rst`
- `up_down`
- `load`
- `data_in[6:0]`

**Salidas:**
- `D_un`, `D_de`, `D_ce`, `D_mi`

---

### 5) `main_w` (Wrapper para MAX10)
**Objetivo:** conectar `main` con los pines típicos de la tarjeta MAX10:
- `MAX10_CLK1_50` como reloj principal
- `KEY` como botones
- `SW` como switches
- `HEX0..HEX3` como displays

**Conexiones usadas:**
- `clk` → `MAX10_CLK1_50`
- `rst` → `~KEY[0]` (reset activo en bajo en el botón)
- `load` → `KEY[1]`
- `up_down` → `SW[9]`
- `data_in` → `SW[6:0]`
- Displays:
  - `HEX0` = unidades
  - `HEX1` = decenas
  - `HEX2` = centenas
  - `HEX3` = millares

---

## Entradas y control (resumen rápido)

- **Reset**: reinicia el contador a 0.
- **Load (activo en 0)**: carga el valor de `data_in` (limitado a 100).
- **Up/Down**:
  - `0` → cuenta hacia arriba (0 → 100 → 0)
  - `1` → cuenta hacia abajo (100 → 0 → 100)

---

## Requisitos para compilar

Asegúrate de incluir en tu proyecto:
- `clk_divide.v`
- `count.v`
- `BCD_4display.v`
- `main.v`
- `main_w.v`
- **`BCD.v`** (módulo para convertir 4-bit BCD a 7 segmentos)

---

## Salida esperada

El valor actual del contador se mostrará en los 4 displays de 7 segmentos:
- HEX0: unidades
- HEX1: decenas
- HEX2: centenas
- HEX3: millares

Como el contador se limita a 0–100, normalmente verás valores desde `0000` hasta `0100`.

---
