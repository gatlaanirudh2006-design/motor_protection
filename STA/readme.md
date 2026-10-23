
# ⚡ Motor Protection ASIC – Static Timing Analysis (STA)

## 📌 1. Introduction

Static Timing Analysis (STA) is used to verify whether a digital circuit meets its timing requirements without requiring simulation test vectors. It analyzes signal propagation through combinational logic and sequential elements using cell timing models, interconnect delays, and timing constraints.

This project focuses on the timing analysis of a **Motor Protection ASIC** implemented using Verilog HDL, OpenLane, OpenSTA, OpenROAD, Yosys, and the SKY130A standard-cell library.

## 🎯 2. Objectives

- ✅ Evaluate the timing performance of the ASIC implementation.
- 🔍 Identify critical paths and propagation delays.
- ⏱️ Analyze setup, hold, recovery, and removal timing checks.
- 📊 Examine Worst Negative Slack (WNS) and Total Negative Slack (TNS).
- 🛠️ Identify potential timing optimization opportunities.
- 🧪 Verify timing results after physical-design implementation.

## 🧰 3. Tools and Technologies

| Tool / Technology | Purpose |
|---|---|
| 💻 Verilog HDL | RTL design |
| 🔧 OpenLane | RTL-to-GDSII implementation |
| ⚙️ Yosys | Logic synthesis |
| 🏗️ OpenROAD | Physical design |
| ⏱️ OpenSTA | Static timing analysis |
| 🔬 SKY130A PDK | 130 nm process design kit |
| 📚 SKY130 HD | Standard-cell library |
| 📄 SDC | Timing constraints |

## 🏗️ 4. Design Under Analysis

The Motor Protection ASIC is designed to monitor operating conditions and detect faults such as overload and overtemperature.

The design includes RTL modules for sensor filtering, fault detection, fault prioritization, and motor control. The RTL is synthesized into a gate-level netlist and processed through the OpenLane physical-design flow.

STA evaluates timing paths between registers, input ports, and output ports to determine whether the implemented circuit meets its timing constraints.

## ⏱️ 5. Timing Analysis

STA evaluates signal propagation using cell delays, interconnect delays, clock arrival times, and sequential-cell timing requirements.

The analysis includes:

- 📍 Data arrival time and required arrival time.
- 🔄 Minimum-delay and maximum-delay paths.
- ⏳ Setup and hold timing checks.
- 🔐 Recovery and removal checks for asynchronous reset signals.
- 📉 Worst Negative Slack (WNS).
- 📊 Total Negative Slack (TNS).

### 📐 Timing Slack

**Slack = Required Time − Arrival Time**

- ✅ Positive slack: The analyzed timing check passes.
- ⚠️ Zero slack: The path is at its timing limit.
- ❌ Negative slack: The analyzed timing check fails.

## 📋 6. Detailed Timing Path Results

### 🔹 Path 1: Asynchronous Reset Removal Check

| Parameter | Result |
|---|---:|
| Startpoint | `rst_n` |
| Endpoint | `_130_/RESET_B` |
| Path group | `async_default` |
| Path type | Minimum delay |
| Data arrival time | 4.13 ns |
| Data required time | 0.21 ns |
| **Slack** | **+3.92 ns ✅** |

**Observation:** The reset signal passes through an input clock buffer before reaching the flip-flop reset pin. The reported positive slack indicates that this removal check passes under the supplied constraints.

### 🔹 Path 2: Register-to-Register Minimum-Delay Check

| Parameter | Result |
|---|---:|
| Startpoint | `_131_` |
| Endpoint | `_134_` |
| Path group | `clk` |
| Path type | Minimum delay |
| Data arrival time | 0.19 ns |
| Data required time | -0.02 ns |
| **Slack** | **+0.21 ns ✅** |

**Observation:** This path connects two rising-edge-triggered flip-flops. The report identifies the signal `u_sensor_filter.overload_meta` between the registers. The positive slack indicates that the analyzed minimum-delay check passes.

### 🔹 Path 3: Asynchronous Reset Recovery Check

| Parameter | Result |
|---|---:|
| Startpoint | `rst_n` |
| Endpoint | `_143_/RESET_B` |
| Path group | `async_default` |
| Path type | Maximum delay |
| Data arrival time | 4.59 ns |
| Data required time | 20.40 ns |
| **Slack** | **+15.82 ns ✅** |

**Observation:** The reset signal passes through an input buffer and an additional repeater before reaching the flip-flop reset pin. The reported positive slack indicates that this recovery check passes under the supplied constraints.

### 🔹 Path 4: Fault-Code Output Timing

| Parameter | Result |
|---|---:|
| Startpoint | `_133_` |
| Endpoint | `fault_code[1]` |
| Path group | `clk` |
| Path type | Maximum delay |
| Data arrival time | 1.71 ns |
| Data required time | 16.00 ns |
| **Slack** | **+14.29 ns ✅** |

**Observation:** The path begins at a flip-flop output, passes through an OR gate and an output buffer, and reaches the `fault_code[1]` output port. The reported positive slack indicates that the analyzed output timing path meets its requirement.

## 📊 7. WNS and TNS Results

The supplied report summaries show:

| Timing Metric | Result |
|---|---:|
| Worst Negative Slack (WNS) | 0.00 ns |
| Total Negative Slack (TNS) | 0.00 ns |

**Interpretation:**

- ✅ **WNS = 0.00 ns:** No negative slack is reported in the corresponding summary.
- ✅ **TNS = 0.00 ns:** No accumulated negative slack is reported in the corresponding summary.

These values indicate that the corresponding analysis summary reports no negative slack. However, they do not independently prove that all timing requirements are satisfied across every path and every analysis corner. Confirm the report stage, constraints, and coverage before declaring timing closure.

## 📈 8. Timing Analysis Summary

The four detailed paths supplied for this project have positive slack:

| Timing Check | Slack | Status |
|---|---:|---|
| Reset removal | +3.92 ns | ✅ Pass |
| Register-to-register minimum delay | +0.21 ns | ✅ Pass |
| Reset recovery | +15.82 ns | ✅ Pass |
| Fault-code output maximum delay | +14.29 ns | ✅ Pass |

The smallest reported slack among these four paths is **+0.21 ns**, for the register-to-register minimum-delay check.

This is the smallest slack in the supplied excerpt, not necessarily the worst slack across the entire design. The complete timing reports must be checked to identify the overall critical path.

## 🛠️ 9. Possible Improvements

Even when the displayed paths pass, the following practices help maintain reliable timing performance:

- 🔍 Inspect the complete timing report for critical paths.
- 📄 Verify the clock definition and SDC constraints.
- ⚙️ Review logic depth and synthesis mapping.
- 🔌 Investigate high-fanout nets and signal delays.
- 🏗️ Compare timing before and after placement and routing.
- 🔄 Rerun STA after implementation changes.
- 📊 Track WNS and TNS across design revisions.

## 📁 10. Timing Report Files

The timing reports are available in the OpenLane run directory.

```text
motor_protection/
└── runs/
    └── 21-10_17-58/
        ├── reports/
        │   └── synthesis/
        │       └── 24-opensta_spef_tns.rpt
        └── timing_reports/
            └── [additional timing reports, if generated]
```

The detailed path information should be saved in the corresponding timing report file. Keep the WNS, TNS, and detailed path reports together so the results can be independently verified.

## 🏁 11. Conclusion

The supplied STA results show positive slack for four representative timing checks involving asynchronous reset signals, register-to-register timing, and the `fault_code[1]` output.

The reported summary values of **WNS = 0.00 ns** and **TNS = 0.00 ns** indicate that no negative slack is reported in that summary.

These results provide useful evidence for evaluating the Motor Protection ASIC's timing performance. The complete timing reports and applicable constraints should be verified before concluding that the entire design has achieved timing closure.

---

### 🚀 Project Highlights

- ⚡ Motor fault-monitoring and protection logic
- 💻 Verilog RTL design
- 🔧 OpenLane RTL-to-GDSII flow
- ⏱️ OpenSTA timing analysis
- 🔬 SKY130A standard-cell library
- 📊 Timing-path and slack evaluation
- 🏗️ ASIC physical-design verification
