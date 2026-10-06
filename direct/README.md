# Fully Unrolled IDEA Encryption Core (`direct`)

A straight, synthesizable VHDL implementation of the **International Data Encryption Algorithm (IDEA)** in which the entire cipher is realized as **combinational hardware**. All 8 rounds and the final output transformation are instantiated as separate physical blocks and wired back-to-back, with the full 52-subkey schedule generated in parallel. This is the **golden reference model** of the [IDEA variant family](../README.md): no clock, no controller, no resource sharing — the clearest possible mapping of the algorithm onto silicon.

---

## 1. Design Identity

- **Descriptive title:** Fully unrolled (combinational) IDEA 64-bit block-cipher core in VHDL.
- **Architecture:** 8 physically distinct `round` instances followed by one `trafo` (output transformation), fed by a parallel key-generation process.
- **Design objectives:**
  - **Correctness first:** act as the functional reference the scheduled cores (`rcs1`, `rcs2`, `rcs2plus`) are validated against.
  - **Maximum parallelism:** no time-multiplexing — plaintext propagates to ciphertext in a single combinational sweep.
  - **Readability:** one-to-one correspondence between the IDEA data-flow graph and the structural VHDL.
- **Trade-off:** this variant deliberately sits at the **high-area / low-latency** extreme of the family. It spends the most logic (eight copies of the round datapath) to avoid any sequential scheduling.

---

## 2. Interface Control Document (ICD)

### Top-Level Entity

The core is purely data-in / data-out — there is no clock, reset, or handshake.

```
                         idea (Structural)
      ┌───────────────────────────────────────────────────────┐
KEY ─►│  KEY_GENERATOR (process)  → 52 × 16-bit subkeys        │
      │        │                                               │
X_1 ─►│   ┌────▼─────┐   ┌────────┐         ┌────────┐         │
X_2 ─►│   │ ROUND_1  │──►│ ROUND_2│──► ... ─►│ ROUND_8│         │
X_3 ─►│   └──────────┘   └────────┘         └───┬────┘         │
X_4 ─►│     (Z1..Z6)       (Z7..Z12)            │(Z43..Z48)    │
      │                                    ┌────▼─────┐        │
      │                                    │ TRAFO_0  │─► Y_1  │
      │                                    │(Z49..Z52)│─► Y_2  │
      │                                    └──────────┘─► Y_3  │
      │                                                 ─► Y_4 │
      └───────────────────────────────────────────────────────┘
```

### Signal Mapping

| Signal | Direction | Width | Description |
| :--- | :---: | :---: | :--- |
| `KEY` | `in` | 128 | Master encryption key |
| `X_1`..`X_4` | `in` | 16 each | Four 16-bit sub-blocks of the 64-bit plaintext |
| `Y_1`..`Y_4` | `out` | 16 each | Four 16-bit sub-blocks of the 64-bit ciphertext |

Because the design is combinational, `Y` is valid once the input has propagated through the full round chain — there is no ready signal to wait on.

---

## 3. Internal Structure

### Key schedule (`KEY_GENERATOR` process)
Produces all **52 subkeys** (`keys_array(0..51)`) in one combinational process:
- 6 rounds of the loop emit 8 subkeys each from the current 128-bit key register.
- After each group of 8, the key register is **rotated left by 25 bits** (`key_copy(102 downto 0) & key_copy(127 downto 103)`).
- The last 4 subkeys feed the output transformation.

### Round module (`round.vhd`)
One IDEA round built from the shared operators using the **Low-High** multiplier algorithm:
- **4 × `mulop`** (modulo 2¹⁶ + 1 multiply), **4 × `addop`** (modulo 2¹⁶ add), **6 × `xorop`** (bitwise XOR).
- Internal `conn1..conn10` signals wire the multiply-add (MA) structure that mixes the two halves of the block.

### Output transformation (`trafo.vhd`)
The final half-round that applies subkeys `Z49..Z52` and produces the ciphertext `Y_1..Y_4`.

---

## 4. Project Structure

```
direct/
├── IDEA.xpr                         # Vivado project file
├── README.md                        # This file
├── ref/                             # Reference golden sources
│   ├── idea.vhd
│   └── mulop.vhd
└── IDEA.srcs/
    ├── sources_1/new/
    │   ├── idea.vhd                 # Top-level: 8 rounds + trafo + key schedule
    │   ├── round.vhd                # One unrolled IDEA round
    │   ├── trafo.vhd                # Output transformation
    │   ├── mulop.vhd                # Modulo (2^16 + 1) multiplier
    │   ├── addop.vhd                # Modulo 2^16 adder
    │   └── xorop.vhd                # 16-bit XOR
    └── sim_1/new/
        ├── tb_idea.vhd              # Full-cipher testbench
        ├── tb_round.vhd             # Single-round testbench
        ├── tb_trafo.vhd            # Output-transformation testbench
        ├── tb_addop.vhd             # Adder testbench
        ├── tb_mulop.vhd             # Multiplier testbench
        └── tb_xorop.vhd             # XOR testbench
```

---

## 5. Verification

The design is validated bottom-up: each arithmetic operator has its own self-checking testbench, and `tb_idea` exercises the complete cipher against the standard IDEA test vector.

```
Key        : 0001 0002 0003 0004 0005 0006 0007 0008
Plaintext  : 1111 2222 4444 8888   (X_1 X_2 X_3 X_4)
Ciphertext : 8AA9 0FEF C0C9 56F6   (Y_1 Y_2 Y_3 Y_4)
```

### Run it
1. Open `IDEA.xpr` in Vivado.
2. Set `tb_idea` as the simulation top.
3. **Flow Navigator → Simulation → Run Behavioral Simulation** — a clean run (no `assert` failures) confirms the ciphertext matches.

Because there is no clock, the testbench applies the key/plaintext, waits for the combinational path to settle, and checks `Y_1..Y_4` directly.

---

## 6. Role in the Family & Limitations

- **Role:** reference model. The scheduled variants reuse the exact same `mulop` / `addop` / `xorop` operators, so matching `direct`'s output proves their scheduling is correct.
- **Area:** largest of the four — eight independent round datapaths plus the transformation.
- **Timing:** the combinational critical path runs through all 8 rounds in series (≈ 24 multipliers deep), so maximum clock rate in any surrounding synchronous system is low. If high throughput *and* a clock are needed, pipeline this datapath or use the iterative `rcs1` core.
- **No I/O wrapper:** `direct` exposes the raw 128 + 64 input / 64 output ports; for board bring-up over UART use the `idea_com` wrapper in the `rcs*` projects.

See the [family overview](../README.md) for how `direct` compares to `rcs1`, `rcs2`, and `rcs2plus`.

---

**Author:** Mehmet Arslan · [@htmos6](https://github.com/htmos6)
