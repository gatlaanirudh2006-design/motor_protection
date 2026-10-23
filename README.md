# motor_protection
# ⚡ Motor Protection System — RTL-to-GDSII ASIC Design

## 📌 Overview

The **Motor Protection System** is a digital hardware project designed to monitor motor operating conditions and detect faults such as overload, overtemperature, and supply faults.

The system uses Verilog HDL to implement motor protection logic and follows the **RTL-to-GDSII ASIC design flow** using OpenLane and the SKY130A open-source Process Design Kit (PDK).

The main objective is to detect abnormal operating conditions, generate fault alerts, and control motor operation to improve protection and reliability.

## 🎯 Objectives

- Design a motor protection system using Verilog HDL.
- Detect overload, overtemperature, and supply faults.
- Filter sensor inputs to improve signal reliability.
- Implement fault detection and prioritization.
- Control motor operation using digital control logic.
- Verify functionality through RTL simulation.
- Perform synthesis and physical design using OpenLane.
- Generate physical design outputs for ASIC implementation.
- Analyze timing using OpenSTA.

## 🏗️ System Architecture

The system receives sensor inputs and a motor start request. The protection logic processes these signals, detects faults, and controls whether the motor can operate.

**Main functional blocks:**

1. Sensor filtering
2. Overload monitoring
3. Fault detection
4. Fault prioritization
5. Motor controller
6. Fault status and lockout logic
7. Output status generation

## 🔧 Technologies and Tools

- **HDL:** Verilog
- **RTL Simulation:** Icarus Verilog
- **Waveform Analysis:** GTKWave
- **Logic Synthesis:** Yosys
- **ASIC Physical Design:** OpenLane
- **Physical Design Engine:** OpenROAD
- **Static Timing Analysis:** OpenSTA
- **Process Design Kit:** SKY130A
- **Operating System:** Linux

## 📂 Project Structure

```text
motor_protection/
├── src/
│   ├── motor_protection_top.v
│   ├── sensor_filter.v
│   ├── fault_detector.v
│   ├── motor_controller_fsm.v
│   └── vibration_monitor.v
├── tb/
│   └── tb_motor_protection.v
├── config.tcl
├── motor_protection.sdc
└── README.md
```

*Note: Update the filenames and directory structure to match the actual files in your GitHub repository.*

## ⚙️ Module Description

### 1. Motor Protection Top Module

The top module connects the different functional blocks and coordinates the complete motor protection system.

### 2. Sensor Filter

Processes sensor inputs to reduce the effect of unwanted signal changes before the protection logic uses them.

### 3. Fault Detector

Detects abnormal operating conditions based on the sensor signals and generates fault information.

### 4. Motor Controller FSM

Uses a finite-state machine to control motor operation based on start requests, reset signals, and fault conditions.

### 5. Vibration Monitor

Monitors the vibration-related input logic to support additional motor protection functionality, if enabled in the implemented design.

### 6. Testbench

Provides input stimulus to the design and checks the expected behavior during RTL simulation.

## 🔌 Input and Output Signals

### Inputs

| Signal | Description |
|---|---|
| `clk` | System clock |
| `rst_n` | Active-low reset |
| `start_request` | Request to start the motor |
| `overload_sensor` | Overload detection input |
| `overtemp_sensor` | Overtemperature detection input |
| `supply_fault_sensor` | Supply fault detection input |

### Outputs

| Signal | Description |
|---|---|
| `motor_enable` | Indicates whether motor operation is enabled |
| `overload_warning` | Indicates an overload warning |
| `fault_active` | Indicates an active fault |
| `lockout_active` | Indicates that the system is in lockout |
| `critical_fault` | Indicates a critical fault condition |
| `fault_code[2:0]` | Encoded current fault information |
| `latched_fault_code[2:0]` | Stored fault code |

## 🧪 RTL Simulation and Verification

RTL simulation is used to verify the functional behavior of the design before synthesis and physical implementation.

### Simulation Tools

- Icarus Verilog
- GTKWave

### Compile the RTL

Run the following commands from the directory containing the Verilog source files. Adjust filenames and paths to match your project.

```bash
iverilog -g2012 -s tb_motor_protection \
-o motor_protection_sim \
motor_protection_top.v \
sensor_filter.v \
fault_detector.v \
motor_controller_fsm.v \
tb_motor_protection.v
```

### Run the Simulation

```bash
vvp motor_protection_sim
```

### View the Waveforms

If the testbench generates a VCD waveform file, open it using:

```bash
gtkwave motor_protection.vcd
```

### Verification Scenarios

The testbench can be used to check:

- Reset behavior
- Motor start requests
- Normal operating conditions
- Overload detection
- Overtemperature detection
- Supply fault detection
- Motor shutdown during fault conditions
- Fault status and lockout behavior

Actual verification results should be documented after running the testbench.

## 🔄 RTL-to-GDSII Design Flow

The project follows these major ASIC implementation stages.

### 1. RTL Design

The motor protection logic is described using Verilog HDL and organized into functional modules.

### 2. Functional Verification

The RTL is simulated using Icarus Verilog, and signal transitions are analyzed with GTKWave.

### 3. Logic Synthesis

Yosys converts the RTL into a gate-level netlist using the target standard-cell library.

### 4. Floorplanning

The floorplanning stage defines the initial chip area, core area, and placement constraints.

### 5. Placement

Standard cells are placed within the core while considering timing and physical design constraints.

### 6. Clock Tree Synthesis

The clock distribution network is constructed to deliver the clock signal to sequential elements.

### 7. Routing

Signal and clock connections are routed using the physical design tools.

### 8. Static Timing Analysis

OpenSTA analyzes timing paths using timing constraints, the standard-cell library, and available parasitic information.

### 9. GDSII Generation

The final physical layout can be exported as a GDSII file when the implementation flow completes successfully and the required checks pass.

## ⏱️ Static Timing Analysis

Static Timing Analysis (STA) evaluates whether the design meets its specified timing requirements without requiring input-vector simulation.

The project uses OpenSTA to examine timing paths and timing slack.

### Timing Metrics

- **Worst Negative Slack (WNS):** The worst slack value among the analyzed timing paths.
- **Total Negative Slack (TNS):** The sum of negative slack values for the analyzed paths.
- **Setup Timing:** Checks whether data arrives before the required clock edge.
- **Hold Timing:** Checks whether data remains stable for the required time after the clock edge.
- **Parasitic Analysis:** Uses extracted interconnect information, such as SPEF, to estimate the impact of wiring on timing.

### Post-Route Timing Analysis

The post-route analysis uses the synthesized clock-tree netlist and extracted routing parasitics.

The current standalone analysis reported:

| Metric | Result |
|---|---:|
| Clock period used | 20 ns |
| Worst slack reported | 17.20 ns |
| Total negative slack reported | 0.00 ns |

These values are from the current standalone STA setup with assumed input/output delays. They should not be treated as final signoff results until the timing constraints, parasitic annotation, and setup/hold coverage have been validated.

## 📊 Physical Design Outputs

The OpenLane flow generates intermediate and final files for synthesis and physical implementation.

Important outputs include:

- Synthesized Verilog netlist
- Floorplan DEF and image
- Placement results
- Clock tree synthesis results
- Routed DEF and routing image
- Extracted SPEF parasitics
- Static timing reports
- Final GDSII layout, if successfully generated

These outputs can be inspected to understand the progression from RTL to physical layout.

## 🌟 Key Features

- Digital motor protection logic
- Sensor-based fault monitoring
- Fault status reporting
- Fault prioritization
- Motor enable control
- Lockout status support
- Modular Verilog RTL design
- ASIC synthesis and physical implementation flow
- Timing analysis using OpenSTA

## 🚀 Future Improvements

- Add additional motor fault detection mechanisms.
- Improve sensor filtering and fault response logic.
- Implement configurable fault thresholds where appropriate.
- Expand the testbench to cover more corner cases.
- Validate reset recovery and removal timing.
- Verify parasitic annotation and complete setup/hold timing coverage.
- Perform design-rule and layout-versus-schematic checks.
- Optimize area, power, and timing.
- Validate the final GDSII output before any tapeout submission.

## 📚 Learning Outcomes

Through this project, the following concepts can be explored:

- Verilog RTL design
- Finite-state machines
- Digital fault detection
- RTL simulation and waveform analysis
- Logic synthesis
- Standard-cell-based ASIC implementation
- Floorplanning and placement
- Clock tree synthesis
- Routing and parasitic extraction
- Static timing analysis
- RTL-to-GDSII design methodology

## 👨‍💻 Author

**Anirudh Gatla**

Electronics and Communication Engineering

Interests: VLSI Design, RTL Design, ASIC Physical Design, and Static Timing Analysis.

## 📝 Conclusion

The Motor Protection System demonstrates the development of digital protection logic using Verilog HDL and its implementation through an ASIC design flow.

The project combines RTL design, functional verification, logic synthesis, physical design, and timing analysis using open-source tools and the SKY130A PDK. It provides practical experience with the major stages involved in transforming a digital hardware design into a physical ASIC layout.
