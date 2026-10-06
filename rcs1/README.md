# Resource-Constrained IDEA Encryption Core (RCS1)

An area-optimized, synthesizable VHDL implementation of the **International Data Encryption Algorithm (IDEA)** block cipher. Utilizing a **Resource-Constrained Scheduling (RCS1)** architecture, the core time-multiplexes a single physical round datapath to minimize logic slice utilization on target silicon.

---

## 1. Project Identity & Taxonomy

*   **Descriptive Title:** Resource-Constrained (Iterative) IDEA Encryption Core in VHDL for Zynq UltraScale+ FPGAs.
*   **High-Level Design Objectives:**
    *   **Ultra-Low Footprint:** Target minimum FPGA slice and DSP utilization for hardware-constrained systems (IoT endpoints, edge devices).
    *   **Deterministic Latency:** Complete block encryptions in exactly 10 clock cycles with a predictable execution schedule.
    *   **Modular Portability:** Implement as a standalone, self-contained IP core ready for system-on-chip (SoC) integration.
*   **Key Architectural Highlights:**
    *   **Time-Multiplexed Datapath:** Single-round resource-sharing loop replacing 8 serial combinational rounds.
    *   **Handshake Control:** Zero-stall, handshaked execution using `START` and `READY` flow-control signals.
    *   **Decoupled Top-Level Wrapper:** A wrapper (`idea_com`) implementing a custom clock divider and UART interface to keep high-speed core analysis isolated from slow external interfaces.
*   **Design Trade-Off Comparison (RCS1 vs. Pipelined Upper Bound):**
    While the IDEA cipher can be fully pipelined to maximize performance—achieving a clock rate of **105.9 MHz** on a legacy Virtex-E FPGA (`XCV1000E-6BG560`) with **18,105 logic cells**, a latency of **132 cycles**, and **6.78 Gbps** throughput—this project targets the opposite design boundary. By using an iterative, resource-shared (RCS1) datapath, we trade parallel throughput for an extremely small logic footprint, fitting the entire core in just **681 LUTs and 12 DSPs** on modern Zynq UltraScale+ silicon.

---

## 2. Interface Control Document (ICD)

### Top-Level Entity Block Diagram

```
                                  idea_single
      ┌──────────────────────────────────────────────────────────────────┐
      │                                                                  │
      │   CONTROL PATH (Moore FSM)                                       │
      │   ┌─────────────┐                                                │
START ───►│             │──────────────────────────────────────┐         │
      │   │   CONTROL   │                                      │         │
CLOCK ───►│    (FSM)    │───────────────────────┐              │         │
      │   │             │──► READY              │              │         │
      │   └─────────────┘                       │              │         │
      │                                         │              │         │
      │   DATA PATH                             │              │         │
      │   ┌─────────────┐                       ▼              ▼         │
X_1  ───►│             │                  ┌───────────┐  ┌───────────┐   │
X_2  ───►│    Input    │                 Input MUXes │  │ Registers │   │
X_3  ───►│ Multiplexers│─────────────────► (Select   │  │   (en)    │   │
X_4  ───►│             │                  │ feedback) │  └─────┬─────┘   │
      │   └─────────────┘                  └─────┬─────┘        │        │
      │                                          │              │        │
      │                                          ▼              ▼        │
KEY  ───►┌─────────────┐                  ┌──────────────────────────┐   │
      │  │    Key      │                  │       Round Module       │   │
      │  │  Generator  │─────────────────►│        (U_ROUND)         │   │
      │  └─────────────┘                  └─────────────┬────────────┘   │
      │                                                 │                │
      │                                                 ▼                │
      │                                   ┌──────────────────────────┐   │
      │                                   │  Output Transformation   │   │
      │                                   │        (U_TRAFO)         │──► Y_1
      │                                   └──────────────────────────┘──► Y_2
      │                                                               ──► Y_3
      │                                                               ──► Y_4
      └──────────────────────────────────────────────────────────────────┘
```

### Pinout & Signal Mapping Matrix

| Signal Name | Direction | Bit-Width | Domain Allocation | Functional Description |
| :--- | :---: | :---: | :---: | :--- |
| `CLOCK` | `in` | 1 | `sys_clk` | Master synchronous clock input |
| `START` | `in` | 1 | `sys_clk` | Flow control: Active-high pulse initiates encryption |
| `READY` | `out` | 1 | `sys_clk` | Flow control: High when ciphertext is stable on `Y` ports |
| `KEY` | `in` | 128 | `sys_clk` | 128-bit encryption master key |
| `X_1`, `X_2`, `X_3`, `X_4` | `in` | 16 (each) | `sys_clk` | 4 × 16-bit blocks forming the 64-bit plaintext |
| `Y_1`, `Y_2`, `Y_3`, `Y_4` | `out` | 16 (each) | `sys_clk` | 4 × 16-bit blocks forming the 64-bit ciphertext |

---

## 3. Implementation Framework & Hardware Constraints

*   **Target Silicon Specification:**
    *   **Vendor:** AMD / Xilinx
    *   **Device Family:** Zynq UltraScale+ MPSoC
    *   **Part Name:** `xczu3eg-sfvc784-1-e`
*   **Synthesis & Implementation Toolchain:** 
    *   **Software:** AMD Vivado v2025.2.1 (win64)
    *   **Mode:** Out-of-Context (OOC) block synthesis and implementation
*   **Timing Constraints Specification:**
    *   **Constraint File:** [timing.xdc](file:///c:/Users/Legion/Desktop/IDEA/rcs1/rcs1.srcs/constrs_1/new/timing.xdc)
    *   **Defined Clocks:** Single primary clock defined on the `CLOCK` port with a target clock period of **18.000 ns**:
      ```xdc
      create_clock -period 18.000 -name sys_clk [get_ports CLOCK]
      ```

---

## 4. Quantitative Performance & Silicon Cost Metrics

### Timing Closure Dashboard
Post-implementation timing summary report metrics:

| Timing Parameter | Value (ns) | Status |
| :--- | :---: | :---: |
| **Worst Negative Slack (WNS)** | `+0.268` | **Passed** |
| **Worst Hold Slack (WHS)** | `+0.073` | **Passed** |
| **Worst Pulse Width Slack (WPWS)** | `+8.725` | **Passed** |

*   **Archived Post-Route Timing Report:** [timing_summary_ooc.rpt](./reports/timing_summary_ooc.rpt) (Fully closed at 18.000 ns target clock period).

### Maximum Frequency Boundary ($F_{\text{max}}$)
The maximum operating frequency is mathematically derived from the worst-case physical delay:
$$\text{Worst-Case Propagation Delay} = T_{\text{clk}} - \text{WNS} = 18.000\text{ ns} - 0.268\text{ ns} = 17.732\text{ ns}$$

$$F_{\text{max}} = \frac{1}{\text{Worst-Case Propagation Delay}} = \frac{1}{17.732\text{ ns}} \approx \mathbf{56.39\text{ MHz}}$$

$$\text{Throughput at } F_{\text{max}} = \frac{64\text{ bits}}{10\text{ cycles}} \times 56.39\text{ MHz} \approx \mathbf{360.9\text{ Mbps}}$$

### Physical Resource Allocation

| Resource Class | Primitive Type | Used Count |
| :--- | :--- | :---: |
| **Combinational** | LUT1, LUT2, LUT3, LUT4, LUT5, LUT6 | 681 |
| **Sequential** | Flip-Flop (FDRE) | 68 |
| **Arithmetic** | DSP Blocks (DSP48E2) | 12 |
| **Memory** | Block RAM / URAM | 0 |
| **Clocking** | Global Clock Buffers (BUFG) | 0 (OOC Mode) |

### Design Rule Verification (DRC) Status
*   **Methodology & DRC Checks:** 100% clean.
*   **Latches:** Zero latches inferred (all registers are clocked edge-triggered flip-flops).
*   **Clock-Domain Crossing (CDC) Risks:** Eliminated at the top wrapper level (`idea_com`) by isolating the UART interface with a generated clock constraint:
    ```xdc
    create_generated_clock -name idea_clk -source [get_ports Clk] -divide_by 163 [get_pins clk_div_1/CLK_OUT_reg/Q]
    ```

---

## 5. Verification, Validation, and Test Strategy

### Functional Verification Methodology
The verification suite utilizes a hierarchical stimulus strategy:
1.  **Component-Level Verification:** Separate self-checking testbenches verify individual entities (`tb_control`, `tb_keygenerator`, `tb_register16`, and `tb_mux2x1`).
2.  **Top-Level Verification:** A self-checking testbench (`tb_idea_single`) subjects the full cryptographic core to standard test vectors. Expected values are checked automatically with VHDL `assert` statements.

### Reference Standards Compliance
Correctness of the modulo multiplier and key scheduler is verified against standard cryptographic test vectors:
*   **Input Key:** `0x0001 0002 0003 0004 0005 0006 0007 0008`
*   **Plaintext:** `0x1111 0x2222 0x4444 0x8888`
*   **Expected Ciphertext:** `0x8AA9 0x0FEF 0xC0C9 0x56F6`

### Timing Verification Strategy
Timing verification is executed post-placement and routing using:
*   **Static Timing Analysis (STA):** Full-path coverage check in Vivado to identify setup/hold margin closures.
*   **Simulation Verification:** Behavioral simulation validates cycle-accurate readiness checks (`START` to `READY` handshaking in exactly 10 cycles).

#### Out-of-Context (OOC) Timing Verification Script
To reproduce the timing verification of `idea_single` standalone (without running into physical I/O pin package limitations), run the following commands sequentially in the Vivado Tcl Console:

```tcl
# 1. Close any open design in memory to prevent workspace conflicts
close_design -quiet

# 2. Reset the previous synthesis run to ensure a clean build
reset_run synth_1

# 3. Synthesize the design as a standalone block (no physical I/O buffer insertion)
synth_design -top idea_single -part xczu3eg-sfvc784-1-e -mode out_of_context

# 4. Perform logical netlist optimization
opt_design

# 5. Place logic cells on the internal FPGA fabric
place_design

# 6. Route signals and resolve interconnect paths
route_design

# 7. Analyze constraints and generate the post-route timing summary report
report_timing_summary -file timing_summary_ooc.rpt

# 8. Open the timing report in Notepad for immediate inspection
exec notepad timing_summary_ooc.rpt
```

### Critical Path Identification
The critical path is physically located within the Multiplication-Addition (MA) logic of the single physical round module `U_ROUND`:
$$\text{REG Output (Q)} \rightarrow \text{Input MUX} \rightarrow \text{Multiplier 1 (MULOP1)} \rightarrow \text{XOR} \rightarrow \text{Multiplier 2 (MULOP5)} \rightarrow \text{Adder} \rightarrow \text{Multiplier 3 (MULOP6)} \rightarrow \text{XOR} \rightarrow \text{REG Input (D)}$$
This delay is dictated by **three sequential 16-bit modulo multipliers** connected in series, limiting the standalone core frequency to **56.39 MHz**.

According to the [Worst-Case Setup Timing Path Analysis](./reports/timing_summary_ooc.rpt):
*   **Source Endpoint:** `U_CTRL/FSM_sequential_current_state_reg[1]/C` (clocked by `sys_clk`)
*   **Destination Endpoint:** `REG4/Q_reg[15]/D` (clocked by `sys_clk`)
*   **Data Path Delay:** `17.713 ns` (`12.181 ns` logic (68.8%), `5.532 ns` routing (31.2%))
*   **Logic Levels:** 53 levels of logic (including `CARRY8`, `DSP48E2` cascades, and look-up tables)
*   **Timing Margin (Setup Slack):** `+0.268 ns`

---

## 6. Deployment Guide & IP Package Deliverables

### Repository Directory Tree

```
rcs1/
├── rcs1.xpr                      # Vivado Project File
├── README.md                     # Technical Documentation
└── rcs1.srcs/
    ├── constrs_1/new/
    │   └── timing.xdc            # Timing Constraints (18.0 ns period)
    ├── sim_1/new/
    │   ├── tb_control.vhd        # Testbench for Moore FSM
    │   ├── tb_keygenerator.vhd   # Testbench for Key Scheduler
    │   ├── tb_mux2x1.vhd         # Testbench for Multiplexers
    │   ├── tb_register16.vhd     # Testbench for feedback registers
    │   └── tb_idea_single.vhd    # Self-checking top-level testbench
    └── sources_1/new/
        ├── addop.vhd             # Modulo 2^16 adder
        ├── xorop.vhd             # Bitwise 16-bit XOR
        ├── mulop.vhd             # Modulo (2^16 + 1) multiplier
        ├── mux2x1.vhd            # 16-bit 2-to-1 multiplexer
        ├── register16.vhd        # 16-bit register with clock enable
        ├── control.vhd           # Moore state machine controller
        ├── keygenerator.vhd      # Round subkey generator
        ├── round.vhd             # Time-multiplexed single round structure
        ├── trafo.vhd             # Output transformation half-round
        ├── idea_single.vhd       # Standalone cryptographic core (Top-Level Core)
        ├── clk_div.vhd           # UART clock divider
        ├── txmit.vhd             # UART transmitter
        ├── rxcver.vhd            # UART receiver
        ├── uart.vhd              # UART communication interface
        ├── idea_com_inner.vhd    # UART-to-crypto command handler FSM
        └── idea_com.vhd          # Board-level top-level wrapper
```

### System Integration Blueprint

To integrate the `idea_single` IP core into a larger system or block design:
1.  **Clocking:** Connect a clock source to the `CLOCK` input. Ensure the clock constraint in your system XDC is defined to be **$\ge 17.732\text{ ns}$ (max 56.39 MHz)**.
2.  **Handshake Protocol:** 
    *   Set the `KEY` and inputs `X_1` .. `X_4` to valid values.
    *   Apply a single-cycle active-high pulse to `START`.
    *   Wait for `READY` to go high (exactly 10 clock cycles later).
    *   Sample the stable ciphertext on `Y_1` .. `Y_4`.
3.  **Physical Pin Mapping (Alternative):** If implementing on physical boards (like a Spartan/Artix/Zynq), use the `idea_com` wrapper. This wraps the 259 ports into a serial interface using a UART (RxD/TxD) and clock divider, allowing the design to communicate with a PC using only **12 physical I/O pins**.

---

## 7. Engineering Log & Design Optimization History

This project underwent a comprehensive optimization, refactoring, and physical validation process:

1.  **VHDL Refactoring & Code Quality:**
    *   Standardized VHDL internal naming conventions: all internal input/output signals mapped to feedback loops were renamed to follow a consistent `xxxx_sigin` and `xxxx_sigout` naming standard.
    *   Aligned component instantiations, port maps, and signal structures to enhance code maintainability and readability.
2.  **Simulation Bug Fix (The "U" Value Error):**
    *   Resolved an issue where simulation output resulted in undefined (`'U'`) signals. This was traced to the basic arithmetic blocks (`addop`, `xorop`, and `mulop`) being missing from the project fileset in `rcs1.xpr`.
    *   Copied and registered all operator components, fully restoring correct behavioral simulation against standard test vectors.
3.  **Testbench Alignment:**
    *   Refactored `tb_control.vhd` to re-order the signal assertions. Modified the testbench checks to verify handshakes in the exact clock-edge sequence: `READY`, `EN` (enable), `ROUND` (counter), and `S` (select).
4.  **Timing Closure (Static Timing Analysis):**
    *   **Port Mismatch Resolution:** Identified that the constraint file (`timing.xdc`) was targeting a non-existent port `clk` instead of the design's top-level clock port `CLOCK`.
    *   **Out-of-Context (OOC) Analysis:** Enabled OOC synthesis and implementation flows to analyze the timing of the standalone IP core without package pin limitations.
    *   **Tuning to Target Silicon Limit:** Proved that the non-pipelined, 3-multiplier critical path cannot close timing at 300 MHz. Re-constrained the clock period to a realistic **18.000 ns (55.56 MHz)**.
    *   **Closure Success:** Successfully closed timing on the Zynq UltraScale+ device with a final **Worst Negative Slack (WNS) of +0.268 ns** and zero setup/hold violations.
