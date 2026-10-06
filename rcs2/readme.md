# Deep Resource-Shared IDEA Encryption Core (RCS2)

An area-optimized, synthesizable VHDL implementation of the **International Data Encryption Algorithm (IDEA)** that pushes **Resource-Constrained Scheduling (RCS)** one level deeper than [`rcs1`](../rcs1/README.md). Instead of reusing a whole round, RCS2 shares the cipher down at the **individual-operator level**: a *single* modulo multiplier, a *single* modulo adder and a *single* XOR are time-multiplexed across every sub-step of every round through a muxed datapath and enable-gated register banks.

This is the **minimum-footprint** branch of the [IDEA variant family](../README.md): the design goal is to fit the core inside **≤ 5 % of the FPGA (≈ 465 LUTs)** so it can sit beside a soft RISC processor as a drop-in cryptographic accelerator.

---

## 1. Design Identity & Objectives

- **Descriptive title:** Operator-level resource-shared IDEA encryption core in VHDL.
- **Design objectives:**
  - **Minimum arithmetic:** one physical `mulop`, one `addop`, one `xorop` reused for the entire cipher.
  - **Accelerator-grade footprint:** target ≤ 5 % FPGA utilization alongside a RISC core.
  - **Deterministic handshake:** `START` / `READY` flow control, ciphertext latched into feedback registers.
- **Resource-sharing strategy:**
  - **Resource-Constrained Scheduling (RCS):** split one IDEA round into several clocked sub-steps executed on shared hardware.
  - **Resource Sharing:** the same multiplier/adder/XOR instances serve different parts of the round on different cycles, selected by 4-to-1 input muxes.

---

## 2. Interface Control Document (ICD)

### Top-Level Entity (`idea_rcs2`)

```
                              idea_rcs2 (Structural)
   ┌──────────────────────────────────────────────────────────────────┐
   │  roundcounter (SLEEP→SETUP→CALC)      control (S0..S7 datapath FSM)│
START ─►│      │  INIT / TRAFO / S_i / ROUND        │ EN125/EN346/EN78  │
CLOCK ─►│      ▼                                     ▼  S / S_T / RESULT │
   │  ┌────────────┐   ┌──────────────┐   ┌──────────────────────────┐  │
KEY ──►│ keygenerator│─►│ input mux2x1 │──►│   shared datapath        │  │
X_1 ─►│ (Z1..Z6 per  │   │ (feedback vs │   │ 1×MUL  1×ADD  1×XOR      │  │
X_2 ─►│  round)      │   │  new block)  │   │ + REG125/REG346/REG78    │─►│ Y_1..Y_4
X_3 ─►│              │   └──────────────┘   │ + mux4x1 operand select  │  │
X_4 ─►│              │          ▲           └────────────┬─────────────┘  │
   │  └─────────────┘   R1..R4  │ (register16 feedback)   │  RESULT        │
   │                     ◄──────┴─────────────────────────┘   ──► READY    │
   └──────────────────────────────────────────────────────────────────────┘
```

### Signal Mapping

| Signal | Direction | Width | Description |
| :--- | :---: | :---: | :--- |
| `CLOCK` | `in` | 1 | Master synchronous clock |
| `START` | `in` | 1 | Active-high pulse begins an encryption |
| `READY` | `out` | 1 | High when ciphertext is valid on `Y_1`..`Y_4` |
| `KEY` | `in` | 128 | 128-bit master key |
| `X_1`..`X_4` | `in` | 16 each | 64-bit plaintext (four sub-blocks) |
| `Y_1`..`Y_4` | `out` | 16 each | 64-bit ciphertext (four sub-blocks) |

---

## 3. Control Architecture

RCS2 uses a **two-level control hierarchy**:

### Outer sequencer — `roundcounter.vhd`
A 3-state FSM (`SLEEP → SETUP → CALC`) plus a 4-bit round counter `ROUND_INT`:
- Waits for `START` in `SLEEP` (asserts `READY`).
- `SETUP` pulses `INIT` to load a fresh plaintext block (`S_i = 1` when `ROUND_INT = 0`).
- `CALC` runs the shared datapath; `ROUND_INT` increments each time the datapath pulses `RESULT`.
- After **8 rounds** the counter MSB raises `TRAFO` to select the output-transformation schedule, then returns to `SLEEP`.

### Inner datapath controller — `control.vhd`
A Moore FSM over states **`S0..S7`** that drives one round's worth of micro-operations each `CALC` pass:
- **`EN125` / `EN346` / `EN78`** — clock-enables for the three register banks (REG1/2/5, REG3/4/6, REG7/8).
- **`S` (2 bits)** — selects operands into the shared `mulop`/`addop` via the `mux4x1` network.
- **`S_T` (2 bits)** — alternate operand selection used during the output transformation.
- **`RESULT`** — marks completion of a round, advancing the outer counter.

A full round walks `S0 → S6` (≈ 7 cycles); `S7` is the idle state. The cycle-optimized sibling [`rcs2plus`](../rcs2plus/README.md) collapses this to 4 active states.

### Shared datapath — `datapath.vhd`
- **1 × `mulop`**, **1 × `addop`**, plus XOR gates, fed by four `mux4x1` operand selectors.
- **Register banks** `REG125`, `REG346`, `REG78` (built from `register16`) hold the intermediate multiply-add results between sub-steps, each enabled independently so one shared ALU can serve the whole round.

---

## 4. Target & Toolchain

- **Vendor / family:** AMD / Xilinx (module headers target Spartan-3E `XC3S500E-FG320`; reports produced on a modern Zynq UltraScale+ class device).
- **Tool:** AMD Vivado.
- **Build modes:** behavioral simulation + full `idea_com` board synthesis with the UART wrapper.

---

## 5. Resource Utilization

Measured from the full board build `idea_com` (core **+ UART interface**), post-synthesis:

| Resource | Used | Available | Util % |
| :--- | :---: | :---: | :---: |
| **CLB LUTs** | 766 | 70,560 | 1.09 % |
| **CLB Registers** | 511 | 141,120 | 0.36 % |
| **F7 Muxes** | 49 | 35,280 | 0.14 % |
| **DSP (DSP48E2)** | 2 | 360 | 0.56 % |
| **Block RAM** | 0 | 216 | 0 % |

> Note the measurement scope: these figures include the UART communication layer, whereas `rcs1`'s headline 681-LUT / 12-DSP number is the **standalone out-of-context core**. The resource-sharing win of RCS2 shows up as **2 DSPs** (one shared multiplier) versus the 12 DSPs of the single-round `rcs1` datapath.

---

## 6. Verification

Self-checking testbenches validate the controller, muxes, clocked round, round counter, and the full cipher against the standard IDEA test vector:

```
Key        : 0001 0002 0003 0004 0005 0006 0007 0008
Plaintext  : 1111 2222 4444 8888
Ciphertext : 8AA9 0FEF C0C9 56F6
```

| Testbench | Under test |
| :--- | :--- |
| `tb_control.vhd` | Datapath FSM (`S0..S7`) |
| `tb_roundcounter.vhd` | Outer sequencer + round counter |
| `tb_mux4x1.vhd` | 4-to-1 operand mux |
| `tb_clockedround.vhd` | One clocked, shared round |
| `tb_idea_rcs2.vhd` | Full cipher, standard vector |

**Run:** open `rcs2.xpr`, set `tb_idea_rcs2` as simulation top, **Run Behavioral Simulation**, and confirm the `START → READY` handshake with the expected ciphertext on `Y_1..Y_4`.

---

## 7. Project Structure

```
rcs2/
├── rcs2.xpr                        # Vivado project file
├── README.md                       # This file
└── rcs2.srcs/
    ├── sources_1/new/
    │   ├── idea_rcs2.vhd           # Top-level structural core
    │   ├── roundcounter.vhd        # Outer FSM + round counter
    │   ├── control.vhd             # Inner datapath FSM (S0..S7)
    │   ├── datapath.vhd            # Shared MUL/ADD/XOR + register banks
    │   ├── clockedround.vhd        # Clocked, resource-shared round
    │   ├── keygenerator.vhd        # Per-round subkey generator
    │   ├── mux2x1.vhd / mux4x1.vhd # Datapath multiplexers
    │   ├── register16.vhd          # 16-bit register with enable
    │   ├── mulop / addop / xorop   # Shared 16-bit operators
    │   ├── idea_com*.vhd           # Board wrapper + UART command FSM
    │   └── uart / txmit / rxcver / clk_div
    └── sim_1/new/
        ├── tb_control.vhd
        ├── tb_roundcounter.vhd
        ├── tb_mux4x1.vhd
        ├── tb_clockedround.vhd
        └── tb_idea_rcs2.vhd
```

---

## 8. Where RCS2 Sits

| | `rcs1` | **`rcs2`** | `rcs2plus` |
| :--- | :---: | :---: | :---: |
| Sharing granularity | One round | One operator each | One operator each |
| Shared multipliers (DSP) | 12 | **2** | 2 |
| Cycles per round | — (10 total) | **~7** | 4 |

RCS2 trades cycles for silicon: by sharing a single multiplier it slashes DSP usage versus `rcs1`, at the cost of more clock cycles per round. The [`rcs2plus`](../rcs2plus/README.md) variant keeps this tiny datapath but rewrites the controller to finish each round in **4 cycles**. See the [family overview](../README.md) for the full comparison.

---

**Author:** Mehmet Arslan · [@htmos6](https://github.com/htmos6)
UART layer based on work by Martin Strasser and Ning Chen.
