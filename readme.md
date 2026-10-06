# IDEA Block Cipher — FPGA Implementation Family

[![Algorithm](https://img.shields.io/badge/Cipher-IDEA%2064--bit-blue)](https://en.wikipedia.org/wiki/International_Data_Encryption_Algorithm)
[![Language](https://img.shields.io/badge/HDL-VHDL-green)](https://en.wikipedia.org/wiki/VHDL)
[![Toolchain](https://img.shields.io/badge/EDA-AMD%20Vivado-red)](https://www.xilinx.com/products/design-tools/vivado.html)
[![Status](https://img.shields.io/badge/Verification-Standard%20Vectors%20Passed-success)]()

A family of synthesizable VHDL implementations of the **International Data Encryption Algorithm (IDEA)** block cipher, built to explore the full **area-versus-throughput design space** of the same cryptographic primitive. Four independent Vivado projects share one set of arithmetic building blocks but schedule them in four fundamentally different ways — from a fully unrolled combinational datapath to an aggressively resource-shared iterative core.

Every variant produces **bit-identical ciphertext**; they differ only in how much silicon they occupy and how many clock cycles they take to encrypt a block.

---

## Table of Contents
- [What Is IDEA?](#what-is-idea)
  - [Algorithm Structure](#algorithm-structure)
  - [The Round Datapath](#the-round-datapath)
  - [Key Schedule](#key-schedule)
- [The Common Interface](#the-common-interface)
- [The Four Variants](#the-four-variants)
  - [1. `direct` — Fully Unrolled Combinational Core](#1-direct--fully-unrolled-combinational-core)
  - [2. `rcs1` — Resource-Constrained Iterative Core](#2-rcs1--resource-constrained-iterative-core-rcs1)
  - [3. `rcs2` — Deep Resource-Shared Datapath](#3-rcs2--deep-resource-shared-datapath-rcs2)
  - [4. `rcs2plus` — Cycle-Optimized RCS2](#4-rcs2plus--cycle-optimized-rcs2-rcs2)
- [Comparison at a Glance](#comparison-at-a-glance)
- [Resource & Timing Summary](#resource--timing-summary)
- [Repository Layout](#repository-layout)
- [Shared Building Blocks](#shared-building-blocks)
- [Verification](#verification)
- [Reference Test Vector](#reference-test-vector)
- [Getting Started](#getting-started)
- [Host ↔ FPGA Communication](#host--fpga-communication)
- [Per-Project Documentation](#per-project-documentation)
- [Author](#author)

---

## What Is IDEA?

IDEA is a symmetric-key block cipher that encrypts a **64-bit plaintext block** under a **128-bit key**. The 64-bit block is handled as **four 16-bit sub-blocks** (`X_1`..`X_4`).

### Algorithm Structure

Encryption consists of **8 identical rounds** followed by a final **output transformation** (a half-round):

```
         X_1   X_2   X_3   X_4        (64-bit plaintext, 4 × 16-bit)
          │     │     │     │
          ▼     ▼     ▼     ▼
   ┌──────────────────────────────┐
   │  ROUND 1   (subkeys Z1..Z6)   │
   ├──────────────────────────────┤
   │  ROUND 2   (subkeys Z7..Z12)  │
   │             ...               │
   │  ROUND 8   (subkeys Z43..Z48) │
   ├──────────────────────────────┤
   │  OUTPUT TRANSFORMATION         │
   │            (subkeys Z49..Z52) │
   └──────────────────────────────┘
          │     │     │     │
          ▼     ▼     ▼     ▼
         Y_1   Y_2   Y_3   Y_4        (64-bit ciphertext, 4 × 16-bit)
```

Each round mixes the data with six 16-bit subkeys using three group operations over 16-bit words:

| Symbol | Operation | Module |
| :---: | :--- | :--- |
| `⊕` | Bitwise XOR | `xorop` |
| `⊞` | Addition modulo 2¹⁶ | `addop` |
| `⊙` | Multiplication modulo 2¹⁶ + 1 (with input `0` treated as 2¹⁶) | `mulop` |

The security of IDEA rests on interleaving these three operations from **three different algebraic groups**, which resists linear and differential cryptanalysis.

### The Round Datapath

One round combines the four sub-blocks and six subkeys through a **multiply-add (MA) structure**. In the `direct` core this maps directly to four multipliers, four adders, and six XORs wired via internal nets (`conn1..conn10`):

```
  X1          X2          X3          X4
   │⊙Z1        │⊞Z2        │⊞Z3        │⊙Z4
   ▼           ▼           ▼           ▼
  (a)         (b)         (c)         (d)
   │           │           │           │
   └─────⊕─────┘           └─────⊕─────┘        ← cross-mix (a⊕c, b⊕d)
         │                       │
         │⊙Z5                    │
         ▼                       │
       (MA top) ──────⊞──────────┤⊙Z6
         │                       ▼
         │                    (MA bottom)
   ┌─────┴─── XOR network with a,b,c,d ───┴─────┐
   ▼           ▼           ▼           ▼
  Y1          Y2          Y3          Y4   → next round (with sub-block swap)
```

The **output transformation** (`trafo`) is a final half-round applying the last four subkeys `Z49..Z52` to produce the ciphertext.

### Key Schedule

`keygenerator` expands the 128-bit master key into **52 subkeys** (6 per round × 8 rounds + 4 for the output transformation):

- The first 8 subkeys are taken directly from the 128-bit key register (as eight 16-bit slices).
- The key register is then **rotated left by 25 bits**, and the next 8 subkeys are sliced off.
- This repeats until all 52 subkeys are produced.

The algorithm is fixed; what differs between the four projects is **how the hardware is scheduled** to compute it.

---

## The Common Interface

The three clocked cores (`rcs1`, `rcs2`, `rcs2plus`) expose the **same handshake interface**, so they are drop-in interchangeable. The `direct` core omits the clock and handshake (it is purely combinational).

| Signal | Direction | Width | `direct` | `rcs1/2/2+` | Description |
| :--- | :---: | :---: | :---: | :---: | :--- |
| `CLOCK` | `in` | 1 | — | ✓ | Master synchronous clock |
| `START` | `in` | 1 | — | ✓ | Active-high pulse begins an encryption |
| `READY` | `out` | 1 | — | ✓ | High when ciphertext is valid on `Y_1`..`Y_4` |
| `KEY` | `in` | 128 | ✓ | ✓ | 128-bit master key |
| `X_1`..`X_4` | `in` | 16 each | ✓ | ✓ | 64-bit plaintext (four sub-blocks) |
| `Y_1`..`Y_4` | `out` | 16 each | ✓ | ✓ | 64-bit ciphertext (four sub-blocks) |

**Handshake protocol (clocked cores):**
1. Drive `KEY` and `X_1`..`X_4` with valid data.
2. Apply a single-cycle active-high pulse on `START`.
3. Wait for `READY` to go high.
4. Sample the stable ciphertext on `Y_1`..`Y_4`.

---

## The Four Variants

The projects form a deliberate progression along the area/throughput trade-off curve.

### 1. `direct` — Fully Unrolled Combinational Core

The reference, "textbook" architecture. All 8 rounds and the output transformation are instantiated as **separate physical hardware blocks** wired back-to-back, with the full 52-subkey schedule generated in parallel. There is **no clock and no controller** — plaintext flows through one enormous combinational path to ciphertext.

```
KEY ─► KEY_GENERATOR (process) → 52 subkeys
         │
X_1..X_4 ─► ROUND_1 ─► ROUND_2 ─► ... ─► ROUND_8 ─► TRAFO_0 ─► Y_1..Y_4
            (Z1..Z6)   (Z7..Z12)        (Z43..Z48)  (Z49..Z52)
```

- **Pros:** conceptually simple, one-shot result, maximum theoretical throughput.
- **Cons:** largest area (8× round logic + trafo), very long combinational critical path (≈ 24 multipliers deep).
- **Role:** the functional **golden model** the scheduled variants are validated against.

→ Full detail: [`direct/README.md`](direct/README.md)

### 2. `rcs1` — Resource-Constrained Iterative Core (RCS1)

A **single physical round** is time-multiplexed and looped, replacing the 8 serial rounds with one reused datapath plus feedback registers. A Moore FSM drives the `START`/`READY` handshake and completes a block in **exactly 10 clock cycles**.

```
START ─►┌─────────────┐  READY
CLOCK ─►│ CONTROL FSM │────────────────────────┐
        └──────┬──────┘                         │
X_1..X_4 ─► input muxes ─► U_ROUND ─► feedback regs ─┐
KEY ─────► keygenerator ─────▲──────────────────────┘
                             └─► U_TRAFO ─► Y_1..Y_4
```

- **Footprint (standalone OOC core `idea_single`):** 681 LUTs, 68 FFs, 12 DSP blocks.
- **Timing:** closed at an 18.0 ns clock → **WNS +0.268 ns**, **F_max ≈ 56.4 MHz → ≈ 360 Mbps** on Zynq UltraScale+.
- **Critical path:** three series 16-bit modulo multipliers inside the MA logic (`MULOP1 → XOR → MULOP5 → ADD → MULOP6 → XOR`).
- **Role:** the first step into resource sharing — one round of hardware instead of eight.

→ Full detail: [`rcs1/README.md`](rcs1/README.md)

### 3. `rcs2` — Deep Resource-Shared Datapath (RCS2)

Takes resource sharing one level deeper: within a single round, **one multiplier, one adder and one XOR** are shared across the round's sub-steps using 4-to-1 input muxes and three enable-gated register banks (`REG125` / `REG346` / `REG78`).

A **two-level control hierarchy** orchestrates the schedule:
- **`roundcounter`** — outer 3-state sequencer (`SLEEP → SETUP → CALC`) plus a 4-bit round counter; raises `TRAFO` after 8 rounds, asserts `READY` in `SLEEP`.
- **`control`** — inner Moore FSM over states `S0..S7` driving the register-bank enables (`EN125`/`EN346`/`EN78`), operand selects (`S`, `S_T`) and the `RESULT` flag. A full round walks `S0 → S6` (~7 cycles); `S7` is idle.

- **Goal:** fit the core in **≤ 5 % of the FPGA (≈ 465 LUTs)** so it can sit beside a soft RISC processor as an accelerator.
- **Footprint (full `idea_com` board build incl. UART):** 766 LUTs, 511 registers, **2 DSP**, 0 BRAM — one shared multiplier vs. 12 DSPs in `rcs1`.

→ Full detail: [`rcs2/README.md`](rcs2/README.md)

### 4. `rcs2plus` — Cycle-Optimized RCS2 (RCS2+)

Architecturally **identical datapath** to RCS2, but the controller is rewritten to compute each round in **4 active cycles instead of ~7** by collapsing the idle sub-states — the FSM keeps only `S0 → S2 → S4 → S6` (plus the `S7` idle state), removing `S1`, `S3`, `S5`.

| | `rcs2` control FSM | `rcs2plus` control FSM |
| :--- | :--- | :--- |
| States | `S0 S1 S2 S3 S4 S5 S6 S7` | `S0 S2 S4 S6 S7` |
| Active cycles / round | ~7 | **4** |

- **Footprint (full `idea_com` board build incl. UART):** 766 LUTs, 510 registers, 2 DSP, 0 BRAM — same area class as RCS2.
- **Role:** the performance-tuned endpoint of the resource-shared branch — fewest cycles at the shared-datapath area point. The cycle-count win comes *for free* from smarter sequencing, not extra hardware.

→ Full detail: [`rcs2plus/README.md`](rcs2plus/README.md)

---

## Comparison at a Glance

| | `direct` | `rcs1` | `rcs2` | `rcs2plus` |
| :--- | :---: | :---: | :---: | :---: |
| **Scheduling strategy** | Fully unrolled | One shared round | Shared op-level datapath | Shared op-level datapath |
| **Clocked?** | No (combinational) | Yes | Yes | Yes |
| **Control** | None | Moore FSM | Round counter + 8-state FSM | Round counter + 4-state FSM |
| **Handshake** | — | `START` / `READY` | `START` / `READY` | `START` / `READY` |
| **Relative area** | Largest | Small | Smallest class | Smallest class |
| **Latency per block** | 1 (combinational) | 10 cycles | ~7 cycles/round | **4 cycles/round** |
| **Shared arithmetic** | None (8× round) | 1 round | 1 MUL / 1 ADD / 1 XOR | 1 MUL / 1 ADD / 1 XOR |
| **Design intent** | Golden model | Low footprint | Minimum footprint | Min footprint, fewer cycles |

---

## Resource & Timing Summary

| Variant | Scope | LUTs | Registers | DSP | BRAM | Timing |
| :--- | :--- | :---: | :---: | :---: | :---: | :--- |
| `rcs1` | Standalone OOC (`idea_single`) | 681 | 68 | 12 | 0 | WNS +0.268 ns @ 18 ns → ≈ 56.4 MHz |
| `rcs2` | Full board (`idea_com` + UART) | 766 | 511 | 2 | 0 | — |
| `rcs2plus` | Full board (`idea_com` + UART) | 766 | 510 | 2 | 0 | — |

> **Read the scope column carefully.** `rcs1`'s headline figure is the **standalone out-of-context core**, while `rcs2`/`rcs2plus` numbers are the **full board build including the UART interface** — they are not directly comparable LUT-for-LUT. The meaningful resource-sharing result is the drop from **12 DSPs (one round datapath in `rcs1`)** to **2 DSPs (one shared multiplier in `rcs2`/`rcs2plus`)**. The `rcs2` and `rcs2plus` synthesis reports also target different FPGA families (DSP48E2 vs. DSP48E1), so compare utilization *percentages* with that in mind. `direct` has no published synthesis report — it is the simulation reference model.

---

## Repository Layout

```
IDEA/
├── README.md                     # This file — family overview
│
├── direct/                       # Variant 1: fully unrolled combinational core
│   ├── IDEA.xpr
│   ├── README.md
│   ├── IDEA.srcs/sources_1/new/  # idea, round, trafo, addop, mulop, xorop
│   ├── IDEA.srcs/sim_1/new/      # tb_idea, tb_round, tb_trafo, tb_addop, tb_mulop, tb_xorop
│   └── ref/                      # reference idea.vhd / mulop.vhd
│
├── rcs1/                         # Variant 2: iterative single-round core
│   ├── rcs1.xpr
│   ├── README.md
│   ├── rcs1.srcs/                # idea_single + UART wrapper (idea_com)
│   └── reports/                  # closed OOC timing report
│
├── rcs2/                         # Variant 3: deep resource-shared datapath
│   ├── rcs2.xpr
│   ├── README.md
│   └── rcs2.srcs/                # idea_rcs2, datapath, control, roundcounter, clockedround
│
├── rcs2plus/                     # Variant 4: cycle-optimized RCS2
│   ├── rcs2plus.xpr
│   ├── README.md
│   └── rcs2plus.srcs/            # idea_rcs2plus, datapath, control (4-cycle), roundcounter
│
├── Doc/                          # Reference test vectors, VHDL manual
├── lint/config/                  # VSG (VHDL Style Guide) configuration
└── IdeaTester.jar                # Host-side tester / reference tool
```

---

## Shared Building Blocks

All four projects are composed from the same small library of 16-bit operators, so the arithmetic is identical everywhere and only the surrounding schedule changes:

| Module | Function | Used by |
| :--- | :--- | :--- |
| `xorop.vhd` | 16-bit bitwise XOR | all |
| `addop.vhd` | Addition modulo 2¹⁶ | all |
| `mulop.vhd` | Multiplication modulo 2¹⁶ + 1 (Low-High algorithm; input `0` ≡ 2¹⁶) | all |
| `keygenerator.vhd` | 128-bit → 16-bit subkey schedule (rotation-based) | all |
| `round.vhd` | One full IDEA round, unrolled combinational | `direct` |
| `clockedround.vhd` | One IDEA round, clocked / resource-shared | `rcs2`, `rcs2plus` |
| `trafo.vhd` | Final output transformation (half-round) | `direct`, `rcs1` |
| `register16.vhd` | 16-bit register with clock enable | scheduled cores |
| `mux2x1.vhd`, `mux4x1.vhd` | Datapath operand multiplexers | scheduled cores |
| `control.vhd`, `roundcounter.vhd` | FSM control | `rcs2`, `rcs2plus` |
| `uart.vhd`, `txmit.vhd`, `rxcver.vhd`, `clk_div.vhd` | Serial host interface | scheduled cores |
| `idea_com.vhd`, `idea_com_inner.vhd` | Board-level wrapper + UART command FSM | scheduled cores |

---

## Verification

Each project is validated **bottom-up**: every arithmetic operator has its own self-checking testbench, and a top-level testbench exercises the complete cipher against the standard IDEA test vector using VHDL `assert` statements. A clean behavioral simulation (no `assert` failures) means the vector passed.

| Variant | Top-level TB | Component testbenches |
| :--- | :--- | :--- |
| `direct` | `tb_idea` | `tb_round`, `tb_trafo`, `tb_addop`, `tb_mulop`, `tb_xorop` |
| `rcs1` | `tb_idea_single` | `tb_control`, `tb_keygenerator`, `tb_register16`, `tb_mux2x1` |
| `rcs2` | `tb_idea_rcs2` | `tb_control`, `tb_roundcounter`, `tb_mux4x1`, `tb_clockedround` |
| `rcs2plus` | `tb_idea_rcs2plus` | `tb_control`, `tb_roundcounter`, `tb_mux4x1`, `tb_clockedround` |

For the clocked cores, the testbench also confirms the cycle-accurate `START → READY` handshake.

---

## Reference Test Vector

Every core is checked against the standard IDEA test vector (also in [`Doc/ReferenceTestVectors.pdf`](Doc/ReferenceTestVectors.pdf)):

```
Key        : 0001 0002 0003 0004 0005 0006 0007 0008
Plaintext  : 1111 2222 4444 8888   (X_1 X_2 X_3 X_4)
Ciphertext : 8AA9 0FEF C0C9 56F6   (Y_1 Y_2 Y_3 Y_4)
```

---

## Getting Started

### Prerequisites
- **AMD Vivado** (projects were last built with Vivado 2025.x); the free edition is sufficient.
  The original module headers target **Xilinx Spartan-3E (XC3S500E-FG320)**; timing closure and resource reports were produced on modern Xilinx 7-series / Zynq UltraScale+ parts.
- Windows or Linux host.

### Open any variant
```bash
# Pick a project and open its Vivado project file
vivado direct/IDEA.xpr          # fully unrolled
vivado rcs1/rcs1.xpr            # iterative single round
vivado rcs2/rcs2.xpr            # resource-shared datapath
vivado rcs2plus/rcs2plus.xpr   # cycle-optimized
```

### Run a simulation
1. In the **Sources** pane, open **Simulation Sources** and set the desired testbench as top (e.g. `tb_idea`, `tb_idea_single`, `tb_idea_rcs2`, `tb_idea_rcs2plus`).
2. **Flow Navigator → Simulation → Run Behavioral Simulation**.
3. A pass produces no `assert` failures in the Tcl console; inspect the waveform to watch the `START → READY` handshake and the ciphertext settle on `Y_1`..`Y_4`.

### Synthesize & check resources
**Flow Navigator → Synthesis → Run Synthesis**, then open the **Utilization** and **Timing Summary** reports. The clocked cores can also be measured standalone with an **out-of-context (OOC)** flow to avoid package-pin limits — for example, the `rcs1` flow:

```tcl
close_design -quiet
reset_run synth_1
synth_design -top idea_single -part xczu3eg-sfvc784-1-e -mode out_of_context
opt_design
place_design
route_design
report_timing_summary -file timing_summary_ooc.rpt
```

See each project's README for its exact flow and the critical-path analysis.

---

## Host ↔ FPGA Communication

The scheduled variants (`rcs1`, `rcs2`, `rcs2plus`) include a board-level wrapper, **`idea_com`**, that exposes the core over a **UART serial link** instead of hundreds of parallel pins. A PC can send a key + plaintext and read back ciphertext using only a handful of physical I/O pins:

| Pin | Direction | Role |
| :--- | :---: | :--- |
| `Clk` | in | Board clock |
| `Reset` | in | Synchronous reset |
| `RxD` | in | UART receive (host → FPGA) |
| `TxD` | out | UART transmit (FPGA → host) |
| `LEDs[7:0]` | out | Status / debug |

A clock divider (`clk_div`) isolates the slow serial interface from the fast crypto core, eliminating clock-domain-crossing risk at the wrapper boundary. The companion [`IdeaTester.jar`](IdeaTester.jar) drives this link from the host side.

---

## Per-Project Documentation

Each variant carries its own detailed README with its interface, block diagram, control schedule, verification strategy, and measured resource/timing numbers:

- **[`direct/README.md`](direct/README.md)** — fully unrolled combinational core
- **[`rcs1/README.md`](rcs1/README.md)** — iterative single-round core (RCS1)
- **[`rcs2/README.md`](rcs2/README.md)** — deep resource-shared datapath (RCS2)
- **[`rcs2plus/README.md`](rcs2plus/README.md)** — cycle-optimized RCS2 (RCS2+)

---

## Author

**Mehmet Arslan**

Digital design engineer focused on cryptographic hardware, RTL design in VHDL, FPGA synthesis, and resource-constrained scheduling.

**GitHub:** [@htmos6](https://github.com/htmos6)

The UART communication layer (`idea_com`, `uart`, `txmit`, `rxcver`, `clk_div`) is based on infrastructure by **Martin Strasser** and **Ning Chen**.

---

**Project Status:** Verified against standard IDEA test vectors · timing closed on target silicon.
