# Cycle-Optimized Resource-Shared IDEA Core (RCS2+)

A performance-tuned evolution of [`rcs2`](../rcs2/README.md): the **same operator-level resource-shared datapath** for the **International Data Encryption Algorithm (IDEA)**, but with a rewritten controller that computes each round in **4 active cycles instead of ~7**. RCS2+ keeps the minimum-footprint silicon of RCS2 (one shared multiplier, one adder, one XOR) while recovering a large fraction of the latency lost to resource sharing — the **performance endpoint** of the resource-shared branch in the [IDEA variant family](../README.md).

---

## 1. Design Identity & Objectives

- **Descriptive title:** Cycle-optimized, operator-level resource-shared IDEA encryption core in VHDL.
- **Core idea:** identical shared `datapath` to RCS2; the win is entirely in the **control schedule**.
- **Design objectives:**
  - **Fewest cycles at the shared-datapath area point:** collapse the idle sub-states of the RCS2 round FSM.
  - **Same tiny footprint:** still only **1 multiplier (2 DSP) / 1 adder / 1 XOR** shared across the whole cipher.
  - **Deterministic handshake:** unchanged `START` / `READY` flow control and feedback-register structure.

---

## 2. What Changed vs. RCS2

The datapath, key generator, register banks, muxes and outer `roundcounter` are **unchanged**. The optimization lives in `control.vhd`:

| | `rcs2` control FSM | **`rcs2plus` control FSM** |
| :--- | :--- | :--- |
| States | `S0, S1, S2, S3, S4, S5, S6, S7` | `S0, S2, S4, S6, S7` |
| Active cycles / round | ~7 (`S0 → S6`) | **4** (`S0 → S2 → S4 → S6`) |
| Idle state | `S7` | `S7` |
| Datapath | shared MUL/ADD/XOR | identical |

RCS2's FSM spent several states idling while intermediate results settled. RCS2+ removes `S1`, `S3`, and `S5` and sequences directly `S0 → S2 → S4 → S6 → S7`, driving the same `EN125` / `EN346` / `EN78` enables, `S` / `S_T` operand selects and `RESULT` flag in fewer clocks. The `TRAFO` branch (jump from `S2` straight to `S6` during the output transformation) is preserved.

---

## 3. Interface Control Document (ICD)

### Top-Level Entity (`idea_rcs2plus`)

Port-compatible with `idea_rcs2` — the two cores are drop-in interchangeable:

| Signal | Direction | Width | Description |
| :--- | :---: | :---: | :--- |
| `CLOCK` | `in` | 1 | Master synchronous clock |
| `START` | `in` | 1 | Active-high pulse begins an encryption |
| `READY` | `out` | 1 | High when ciphertext is valid on `Y_1`..`Y_4` |
| `KEY` | `in` | 128 | 128-bit master key |
| `X_1`..`X_4` | `in` | 16 each | 64-bit plaintext (four sub-blocks) |
| `Y_1`..`Y_4` | `out` | 16 each | 64-bit ciphertext (four sub-blocks) |

### Control hierarchy
- **`roundcounter.vhd`** — outer `SLEEP → SETUP → CALC` sequencer and 4-bit round counter; raises `TRAFO` for the output transformation after 8 rounds (identical to RCS2).
- **`control.vhd`** — the slimmed 4-state datapath FSM described above.
- **`datapath.vhd`** — single shared `mulop` / `addop` / `xorop` with `REG125` / `REG346` / `REG78` register banks and `mux4x1` operand selection.

---

## 4. Resource Utilization

From the full board build `idea_com` (core **+ UART interface**), post-synthesis:

| Resource | Used | Available | Util % |
| :--- | :---: | :---: | :---: |
| **Slice LUTs** | 766 | 41,000 | 1.87 % |
| **Slice Registers** | 510 | 82,000 | 0.62 % |
| **F7 Muxes** | 39 | 20,500 | 0.19 % |
| **DSP (DSP48E1)** | 2 | 240 | 0.83 % |
| **Block RAM** | 0 | 135 | 0 % |

RCS2+ occupies essentially the **same area class as RCS2** (~766 LUTs, 2 DSP, 0 BRAM) — confirming that the cycle-count improvement comes *for free* from smarter sequencing, not from extra hardware. The two reports were taken on different target families (RCS2 on a Zynq UltraScale+ class part with DSP48E2, RCS2+ on a 7-series class part with DSP48E1), so compare utilization *percentages* with that in mind.

---

## 5. Verification

Self-checking testbenches validate the slimmed controller, muxes, clocked round, round counter, and the full cipher against the standard IDEA test vector:

```
Key        : 0001 0002 0003 0004 0005 0006 0007 0008
Plaintext  : 1111 2222 4444 8888
Ciphertext : 8AA9 0FEF C0C9 56F6
```

| Testbench | Under test |
| :--- | :--- |
| `tb_control.vhd` | 4-state datapath FSM |
| `tb_roundcounter.vhd` | Outer sequencer + round counter |
| `tb_mux4x1.vhd` | 4-to-1 operand mux |
| `tb_clockedround.vhd` | One clocked, shared round |
| `tb_idea_rcs2plus.vhd` | Full cipher, standard vector |

**Run:** open `rcs2plus.xpr`, set `tb_idea_rcs2plus` as simulation top, **Run Behavioral Simulation**, and confirm the ciphertext on `Y_1..Y_4` — now reached in fewer cycles than RCS2.

---

## 6. Project Structure

```
rcs2plus/
├── rcs2plus.xpr                    # Vivado project file
├── README.md                       # This file
└── rcs2plus.srcs/
    ├── sources_1/new/
    │   ├── idea_rcs2plus.vhd       # Top-level structural core
    │   ├── roundcounter.vhd        # Outer FSM + round counter
    │   ├── control.vhd             # 4-state datapath FSM (the optimization)
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
        └── tb_idea_rcs2plus.vhd
```

---

## 7. Where RCS2+ Sits

| | `rcs1` | `rcs2` | **`rcs2plus`** |
| :--- | :---: | :---: | :---: |
| Sharing granularity | One round | One operator each | One operator each |
| Shared multipliers (DSP) | 12 | 2 | **2** |
| Cycles per round | — (10 total) | ~7 | **4** |
| Relative area | Small | Smallest class | Smallest class |

RCS2+ is the sweet spot of the resource-shared branch: the DSP-frugal datapath of RCS2 with the latency penalty largely bought back by a tighter schedule. See the [family overview](../README.md) for the full four-way comparison.

---

**Author:** Mehmet Arslan · [@htmos6](https://github.com/htmos6)
UART layer based on work by Martin Strasser and Ning Chen.
