# 4-bit ALU — Arithmetic Logic Unit

A combinational Arithmetic Logic Unit built in SystemVerilog. Takes two 4-bit numbers and a 3-bit operation selector, performs the chosen operation, and outputs the result with carry and zero status flags.

Verified with an exhaustive self-checking testbench covering all 1,280 possible input combinations.

[**Live demo →**](./demo/index.html)

---

## Overview

```
     A [3:0] ──┐
               ├──► ALU ──► result [3:0]
     B [3:0] ──┘     │
                      ├──► carry_out
    op [2:0] ─────────┤
                      └──► zero
```

---

## Operations

| op  | Operation | Example (A=5, B=3) | Result |
|-----|-----------|-------------------|--------|
| 000 | ADD       | 0101 + 0011       | 1000 (8) |
| 001 | SUB       | 0101 - 0011       | 0010 (2) |
| 010 | AND       | 0101 & 0011       | 0001 (1) |
| 011 | OR        | 0101 \| 0011      | 0111 (7) |
| 100 | XOR       | 0101 ^ 0011       | 0110 (6) |

---

## Status flags

| Flag | Value | Meaning |
|---|---|---|
| `carry_out` | 1 | Addition overflowed 4 bits (e.g. 15+1 = 0, carry=1) |
| `zero` | 1 | Result is exactly 0000 |

**Example — carry firing:**
```
A = 1111  (15)
B = 0001  (1)
op = ADD

result    = 0000  (wraps around)
carry_out = 1
zero      = 1
```

**Example — zero flag for equality check:**
```
A = 0111  (7)
B = 0111  (7)
op = SUB

result = 0000
zero   = 1     ← A and B were equal
```

---

## Module interface

```sv
module alu_4bit (
    input  logic [3:0] A,          // 4-bit operand A
    input  logic [3:0] B,          // 4-bit operand B
    input  logic [2:0] op,         // operation selector

    output logic [3:0] result,     // 4-bit result
    output logic       carry_out,  // overflow flag
    output logic       zero        // zero flag
);
```

---

## Project structure

```
4-bit-alu/
├── rtl/
│   └── alu_4bit.sv             Main ALU design
├── tb/
│   └── alu_4bit_tb.sv          Exhaustive testbench
├── demo/
│   └── index.html              Browser demo (no install needed)
├── screenshots/
│   └── waveform.png            GTKWave simulation output
├── .gitignore
└── README.md
```

---

## How to run

### Option 1 — Browser (no install)
Open `demo/index.html` in any browser. Toggle bits, pick an operation, and see the result update live.

### Option 2 — EDA Playground (no install)
1. Go to [edaplayground.com](https://edaplayground.com)
2. Paste `alu_4bit.sv` into the Design panel
3. Paste `alu_4bit_tb.sv` into the Testbench panel
4. Select **Icarus Verilog 12.0**, tick **Open EPWave**
5. Click **Run**

### Option 3 — Icarus Verilog (local)
```bash
# Compile
iverilog -g2012 -o sim rtl/alu_4bit.sv tb/alu_4bit_tb.sv

# Simulate
vvp sim

# View waveform
gtkwave alu_4bit.vcd
```

Expected output:
```
=== 4-bit ALU Exhaustive Testbench ===
Testing all 16 x 16 x 5 = 1,280 combinations...

PASS: 1280 / 1280
ALL TESTS PASSED
```

---

## Testbench

The testbench uses a **reference model** — the same five operations are implemented independently inside the testbench. For every input combination, the DUT output is compared against the reference. Any mismatch is a failure.

```
16 values of A  ×  16 values of B  ×  5 operations  =  1,280 test cases
```

This is exhaustive verification — every possible input is tested, not just samples.

---

## Waveform

![Waveform](./screenshots/waveform.png)

*Signals shown: A, B, op, result, carry_out, zero*

---

## Skills demonstrated

- Combinational logic design (`always_comb`)
- Binary arithmetic — addition and subtraction with carry
- Bitwise logic — AND, OR, XOR
- 3-bit operation selector using `case` statement
- Status flag generation — carry and zero
- Reference model / self-checking testbench pattern
- Exhaustive input-space coverage (1,280 test cases)
- VCD waveform generation and GTKWave analysis

## Planned upgrades

- [ ] NOT operation (op `101`)
- [ ] Shift left / shift right (op `110`, `111`)
- [ ] Negative flag (`result[3]`)
- [ ] Signed overflow flag
- [ ] Parameterised width (4-bit → 8-bit → N-bit)
