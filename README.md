# RTL Module Library — Verilog Design & Verification

A structured library of 15+ synthesisable RTL modules written in Verilog,
covering fundamental digital design building blocks from basic flip-flops to
protocol-level controllers. Every module includes a self-checking testbench
and simulation instructions.

---

## Author

C.V. Rushil
B.E. Electronics & Communication Engineering — Osmania University (2022–2026)
VLSI Physical Design Intern — MosChip Technologies Ltd. (2025)

---

## Repository Structure

rtl-module-library/
├── 01_dff/                 ← D Flip-Flop (sync & async reset, enable)
├── 02_mux_decoder/         ← 4:1 MUX, 3:8 Decoder
├── 03_adders/              ← Half adder, Full adder, RCA, CLA
├── 04_counters/            ← Up, Down, Ring, Johnson, Loadable
├── 05_shift_registers/     ← SISO, SIPO, PISO, PIPO, Universal
├── 06_sequence_detector/   ← FSM: 1011 detector (Moore + Mealy)
├── 07_sync_fifo/           ← Synchronous FIFO with full/empty/count
├── 08_async_fifo/          ← Dual-clock FIFO with Gray code CDC
├── 09_arbiter/             ← Fixed priority + Round-robin arbiter
├── 10_uart/                ← UART TX + RX (8N1, configurable baud rate)
└── README.md

---

## Module Overview

| #  | Module             | Type          | Key Concepts                                  |
|----|--------------------|---------------|-----------------------------------------------|
| 01 | D Flip-Flop        | Sequential    | Sync/async reset, clock enable, active-low    |
| 02 | MUX & Decoder      | Combinational | 4:1 MUX tree, 3:8 one-hot decode, enable      |
| 03 | Adders             | Combinational | Ripple carry vs CLA, generate/propagate       |
| 04 | Counters           | Sequential    | Ring, Johnson, loadable, overflow flag        |
| 05 | Shift Registers    | Sequential    | Serial/parallel conversion, universal SR      |
| 06 | Sequence Detector  | FSM           | Moore vs Mealy, overlapping vs non-overlapping|
| 07 | Synchronous FIFO   | Memory        | Pointer wrap, full/empty, simultaneous R/W    |
| 08 | Asynchronous FIFO  | CDC           | Gray code, 2-FF synchronizer, dual-clock      |
| 09 | Arbiter            | Control       | 2's complement trick, round-robin mask        |
| 10 | UART               | Protocol      | 8N1 format, baud generation, RX oversampling  |

---

## How to Simulate

Option 1 — EDA Playground (No Installation)
1. Go to edaplayground.com
2. Paste the .v file contents
3. Select Icarus Verilog 12.0
4. Tick Open EPWave after run
5. Click Run

Option 2 — Icarus Verilog (Local)
  iverilog -o sim.out module.v tb.v
  vvp sim.out
  gtkwave dump.vcd

---

## Design Principles Followed

- Three always block style for all FSMs (state register, next-state, output)
- Active-low reset (rst_n) — industry standard for ASIC flows
- No latches — every combinational always block has a default case
- Parameterised modules — WIDTH and DEPTH configurable
- Self-checking testbenches with error counters
- Waveform dumps via $dumpfile and $dumpvars in every testbench

---

## Tools Used

- Icarus Verilog — RTL simulation
- EDA Playground — browser-based simulation
- GTKWave — waveform viewer
- Cadence Genus — logic synthesis (MosChip internship)

---

## Learning Path

Basic:        01 → 02 → 03 → 04 → 05
Intermediate: 06 → 07 → 08 → 09 → 10
Coming soon:  SPI Master, I2C Master, ALU, RISC-V Processor
