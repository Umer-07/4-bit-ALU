# 4-bit ALU

A SystemVerilog combinational Arithmetic Logic Unit supporting five operations with carry and zero status flags.

---

## Operations

| op   | Operation  | Example (A=5, B=3)     |
|------|------------|------------------------|
| 000  | ADD        | 0101 + 0011 = **1000** |
| 001  | SUB        | 0101 - 0011 = **0010** |
| 010  | AND        | 0101 & 0011 = **0001** |
| 011  | OR         | 0101 \| 0011 = **0111** |
| 100  | XOR        | 0101 ^ 0011 = **0110** |

## Flags

| Flag        | Meaning                                       |
|-------------|-----------------------------------------------|
| `carry_out` | Set when ADD overflows 4 bits (e.g. 15+1=0, carry=1) |
| `zero`      | Set when result equals 0000                   |

---

## Project structure

```
4-bit-alu/
├── rtl/
│   └── alu_4bit.sv         Main ALU design
├── tb/
│   └── alu_4bit_tb.sv      Exhaustive testbench (1,280 cases)
├── screenshots/
│   └── waveform.png        GTKWave screenshot (add after sim)
└── README.md
```

---

## How to run (Icarus Verilog)

```bash
iverilog -g2012 -o sim \
  rtl/alu_4bit.sv \
  tb/alu_4bit_tb.sv

vvp sim
```

Expected output:
```
=== 4-bit ALU Exhaustive Testbench ===
Testing all 16 x 16 x 5 = 1,280 combinations...
PASS: 1280 / 1280
ALL TESTS PASSED
```

### View waveform

```bash
gtkwave alu_4bit.vcd
```

Add signals: `A`, `B`, `op`, `result`, `carry_out`, `zero`. Zoom to the spot-check section to see each operation firing in sequence.

### Run on EDA Playground

1. Go to https://edaplayground.com
2. Paste `alu_4bit.sv` into the Design panel
3. Paste `alu_4bit_tb.sv` into the Testbench panel
4. Select Icarus Verilog 12.0, tick Open EPWave
5. Click Run

---

## Skills demonstrated

- Combinational logic design (`always_comb`)
- Binary arithmetic (addition, subtraction with carry)
- Bitwise logic (AND, OR, XOR)
- Status flags (carry, zero)
- 3-bit operation selector / case statement
- Exhaustive testbench — 1,280 test cases
- Reference model verification pattern
- VCD waveform generation

---

## Resume bullet

> Designed and verified a 4-bit Arithmetic Logic Unit in SystemVerilog, supporting arithmetic and bitwise operations with zero/carry flags and exhaustive testbench validation across all 1,280 input combinations.

---

## Extending the project

| Upgrade | What you learn |
|---|---|
| 8-bit ALU | Parameterised width |
| NOT, shift left/right | More opcodes |
| Overflow flag (signed) | Signed arithmetic |
| Negative flag | Two's complement |
| Connect to traffic light | Multi-module design |
