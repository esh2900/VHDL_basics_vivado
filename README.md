# VHDL Basics - Vivado

Repository containing my VHDL learning projects developed using AMD Vivado.

## Learning Projects

1. ## Adder Benchmark: CLA vs Ripple Carry vs VHDL `+`

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


## Basic Functions
- AND gate
- 1-bit full adder
- 4-bit full adder
- Fixed-point 4-bit adder

## Tools

- VHDL
- AMD Vivado
- XSim

## Purpose

This repository documents my progress learning digital logic design,
VHDL, FPGA development and simulation.