# VHDL Basics - Vivado

## Purpose

This repository documents my progress learning digital logic design,
VHDL, FPGA and ASIC development and simulation.

## Tools

- VHDL
- AMD Vivado
- XSim

## Learning Projects

## 1.  Adder Benchmark: CLA vs Ripple Carry vs VHDL `+`

Three 32-bit adders were implemented and compared:

* Hierarchical Carry Lookahead Adder (CLA), using 8-bit blocks
* Ripple Carry Adder
* Standard VHDL addition using `A + B`

All three implementations provide:

* 32-bit result
* unsigned carry-out
* signed overflow flag

A common testbench was used to verify that all implementations produced identical results for normal additions, unsigned carry, signed overflow, and negative values.

For timing comparison, each adder was placed between input and output registers and implemented on the same target:

```text
FPGA:   Artix-7 xc7a200tfbg676-2
Width:  32 bits
Clock:  100 MHz
Vivado: 2026.1
```

### Results

| Metric          |      CLA |   Ripple |   VHDL `A+B` |
| --------------- | -------: | -------: | -----------: |
| Data Path Delay | 7.450 ns | 8.240 ns | **3.191 ns** |
| Logic Levels    |       13 |       16 |       **10** |
| LUTs            |       53 |       47 |       **33** |
| Registers       |       98 |       98 |           98 |
| CARRY4          |        0 |        0 |        **9** |

The CLA was about **9.6% faster than the manually implemented Ripple Carry Adder**, showing the advantage of reducing carry propagation depth.
However, the standard VHDL `A+B` implementation was significantly faster and used fewer LUTs. The Vivado synthesizer mapped the arithmetic operation to the Artix-7 dedicated `CARRY4` resources, while the manual CLA and Ripple implementations were mainly mapped to LUT logic.

### Conclusion

The manual CLA outperformed the manual Ripple Carry Adder, as expected from its reduced carry propagation depth.

However, on an FPGA, explicitly describing a sophisticated arithmetic architecture does not necessarily produce the fastest hardware. Using the high-level VHDL `+` operator allowed Vivado to recognize the intended arithmetic operation and efficiently map it to the FPGA's dedicated carry-chain hardware.

For practical FPGA designs, using:

```vhdl
R <= A + B;
```

can therefore be more efficient than manually implementing the adder architecture, while manual implementations remain useful for understanding digital design and carry propagation.


## 2. UART TX/RX RTL Implementation

UART 8N1 transmitter and receiver implemented in VHDL.

### UART TX

The transmitter was designed to send 8-bit data using:

- 1 start bit
- 8 data bits, LSB first
- 1 stop bit
- Configurable clock frequency and baud rate

### Simulation Overview

The waveform below shows:

- Two consecutive UART transmissions
- `busy` behavior during transmission
- `done` pulse at the end of each frame
- Bit progression through `current_bit`
- Reset returning the transmitter to the idle state

![UART TX Simulation](VHDL_basics_vivado.srcs/source_1/Project%202/Reports/uart_tx_simulation.png)

### Frame Detail

The transmitted test byte was:

`10011010`

UART transmission order:

`START → D0 → D1 → D2 → D3 → D4 → D5 → D6 → D7 → STOP`

Since UART transmits LSB first:

`0 | 0 1 0 1 1 0 0 1 | 1`

### Reset Behavior

When reset is asserted:

- `tx` returns to logic `1` (UART idle)
- `busy` returns to `0`
- internal counters are reset

### UART RX

The UART receiver was implemented as an explicit finite-state machine (FSM) with the following states:

`IDLE → START_CHECK → DATA_STREAM → STOP_CHECK`

The receiver:

- Detects a possible start bit while in `IDLE`
- Validates the start bit near its midpoint
- Samples the 8 data bits at the configured baud rate
- Reconstructs the received byte in LSB-first order
- Checks the stop bit
- Generates a one-clock-cycle `data_valid` pulse when a valid frame is received
- Generates `framing_error` if the stop bit is invalid
- Uses a two-flip-flop synchronizer (`rx_meta` and `rx_sync`) to reduce metastability risk on the asynchronous RX input

### RX Testbench Overview

Since checking the RX behavior is a bit more complicated than checking the TX module, a Testbench was developed to simulate a group of edge cases.

The complete 500 µs simulation validates the main RX behaviors, including:

- Reception of a valid UART frame
- Detection of an invalid stop bit through `framing_error`
- Rejection of a false start condition
- Reception of consecutive frames
- Reset behavior

![UART RX Full Testbench](VHDL_basics_vivado.srcs/source_1/Project%202/Reports/uart_rx_full_simulation.png)

### Valid Frame Detail

The waveform below shows a detailed view of a valid UART 8N1 reception.

During this frame:

- The FSM transitions through `START_CHECK`, `DATA_STREAM`, and `STOP_CHECK`
- `bit_index` progresses from 0 to 7
- `message_out` is reconstructed bit by bit
- The final received byte is `10011010` (`0x9A`)
- A valid stop bit generates a one-clock-cycle `data_valid` pulse
- The receiver then returns to the `IDLE` state

![UART RX Simulation](VHDL_basics_vivado.srcs/source_1/Project%202/Reports/uart_rx_simulation.png)


## Basic Functions

*(Miscellaneous entities used for learning concepts)*

* AND gate
* 1-bit full adder
* 4-bit full adder
* 4-bit fixed-point adder
* Traffic light FSM
