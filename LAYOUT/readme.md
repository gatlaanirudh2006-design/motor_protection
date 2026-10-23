# Motor Protection System — RTL-to-GDSII ASIC Design

## Overview

The **Motor Protection System** is a digital hardware project designed to monitor motor operating conditions and detect faults such as overload, overtemperature, and supply faults. The design is implemented using Verilog HDL and follows an RTL-to-GDSII ASIC physical-design flow using OpenLane and the SKY130A PDK.

The project covers RTL design, logic synthesis, floorplanning, placement, clock-tree synthesis, routing, parasitic extraction, and static timing analysis (STA).

## Project Details

| Parameter | Description |
|---|---|
| Project Name | Motor Protection System |
| Top Module | `motor_protection_top` |
| Design Language | Verilog HDL |
| Technology | SKY130A |
| Physical Design Flow | OpenLane |
| Synthesis Tool | Yosys |
| Physical Design Tool | OpenROAD |
| Layout Tools | Magic and KLayout |
| Timing Analysis | OpenSTA |
| Clock Signal | `clk` |
| Clock Period | 20 ns (50 MHz) |

## 1. RTL Design

### Overview

The design monitors sensor inputs and controls motor operation based on detected fault conditions. It includes sensor filtering, overload monitoring, fault prioritization, and motor-control logic.

### Main Modules

- `motor_protection_top.v` — top-level integration module.
- `sensor_filter.v` — filters and synchronizes sensor inputs.
- `overload_monitor.v` — monitors overload conditions.
- `fault_prioritizer.v` — prioritizes detected faults.
- `motor_controller_fsm.v` — controls motor operation using a finite-state machine.
- `tb_motor_protection.v` — testbench for functional verification.

*The filenames above reflect the project modules discussed during development; verify them against your final source directory.*

## 2. Synthesis

### Overview
Synthesis converts the Verilog RTL into a gate-level netlist using the SKY130 HD standard-cell library. Yosys performs logic synthesis and technology mapping.

### Tools Used
- OpenLane
- Yosys
- SKY130A PDK

### Output
- `results/synthesis/motor_protection_top.synthesis.v` — synthesized gate-level netlist.
- `results/synthesis/motor_protection_top.synthesis_cts.v` — post-CTS netlist available in the recorded run.

### Result
The synthesized netlist was generated as part of the OpenLane implementation flow.

## 3. Floorplanning

### Overview
Floorplanning establishes the initial physical-design region by defining the core and die dimensions. It prepares the design for power distribution and standard-cell placement.

### Objectives
- Define the core and die area.
- Establish the physical design region.
- Prepare for power distribution network (PDN) generation.
- Prepare the design for placement.

### Tools Used
- OpenLane
- OpenROAD
- SKY130A PDK
- Magic

### Output
The floorplan DEF and its visualization are stored under:

`results/floorplan/`

### Screenshot
Add your floorplan screenshot as `motor_protection_floorplan.png`.

## 4. Placement

### Overview
Placement assigns physical locations to standard cells inside the floorplan while considering timing, wirelength, and congestion.

### Objectives
- Place standard cells within the core.
- Improve timing and wirelength.
- Reduce congestion.
- Prepare for clock-tree synthesis and routing.

### Tools Used
- OpenLane
- OpenROAD
- SKY130A PDK

### Output
Placement results are stored under:

`results/placement/`

### Screenshot
Add your placement screenshot as `motor_protection_placement.png`.

## 5. Clock-Tree Synthesis (CTS)

### Overview
Clock-tree synthesis builds the clock distribution network to deliver the clock signal to sequential elements. It inserts clock buffers and optimizes clock distribution.

### Tools Used
- OpenLane
- OpenROAD
- SKY130A standard-cell library

### Output
The available post-CTS netlist is:

`results/synthesis/motor_protection_top.synthesis_cts.v`

### Screenshot
Add a CTS visualization if one is available in your run outputs.

## 6. Routing

### Overview
Routing connects the placed standard cells using metal interconnects according to the design's connectivity and physical-design constraints. Parasitic resistance and capacitance are extracted for timing analysis.

### Objectives
- Connect standard-cell pins and signal nets.
- Complete signal routing.
- Extract parasitic resistance and capacitance.
- Prepare the design for post-route timing analysis.

### Tools Used
- OpenLane
- OpenROAD
- SKY130A PDK

### Outputs
- `results/routing/motor_protection_top.def` — routed design DEF.
- `results/routing/motor_protection_top.spef` — extracted parasitic information.
- `results/routing/motor_protection_top.def.png` — routing-stage visualization.

### Screenshot
Add your routing screenshot as `motor_protection_routing.png`.

## 7. Post-Route Static Timing Analysis (STA)

### Overview
Static timing analysis evaluates circuit timing using the clock definition, timing constraints, standard-cell library, and extracted parasitic information.

The post-route STA was run using OpenSTA with the SKY130A typical library, the post-CTS netlist, and the routed SPEF file.

### Timing Configuration
- Clock: `clk`
- Clock period: 20 ns
- Target frequency: 50 MHz

### Recorded Results

| Metric | Recorded Value |
|---|---:|
| Worst Slack Reported | +17.20 ns |
| Total Negative Slack (TNS) | 0.00 ns |

### Interpretation
The current standalone STA run reports positive worst slack and zero total negative slack under the constraints used. These results apply to the analyzed paths and current constraint setup.

**Note:** The timing constraints use assumed input and output delays. SPEF annotation and complete setup and hold coverage should be verified before treating these values as final sign-off results.

### Reports
The generated reports are available under `timing_reports/`:

- `motor_protection_postroute_timing.rpt` — detailed timing paths.
- `motor_protection_postroute_wns.rpt` — worst slack.
- `motor_protection_postroute_tns.rpt` — total negative slack.

## 8. GDSII Layout

### Overview
GDSII is the physical layout representation of the ASIC. It contains geometric information for the implemented standard cells, interconnects, and other layout structures.

### Viewing the Layout
If a GDS file was generated, locate it with:

```bash
find . -type f -name "*.gds"
```

Open the actual generated file using KLayout:

```bash
klayout path/to/motor_protection_top.gds
```

Replace the example path with the path returned by the search command.

### Screenshot
Add a final layout screenshot as `motor_protection_gds.png` if the GDS output is available.

## 9. Physical Verification

Physical verification helps check the layout against manufacturing design rules and verifies connectivity between the layout and the design netlist.

### Checks
- Design Rule Check (DRC)
- Layout Versus Schematic (LVS)
- Antenna-rule checks
- Setup and hold timing analysis

### Status
The run contains routing parasitics and timing reports. Final DRC, LVS, antenna, and complete timing sign-off status should be documented using the corresponding reports from the actual run.

## 10. Tools and Technologies

- **Verilog HDL:** RTL design and module integration.
- **Yosys:** Logic synthesis.
- **OpenLane:** Automated RTL-to-GDSII flow.
- **OpenROAD:** Physical-design implementation.
- **SKY130A PDK:** Open-source process design kit.
- **Magic:** Layout viewing and physical verification.
- **KLayout:** GDSII inspection.
- **OpenSTA:** Static timing analysis.

## Conclusion

The Motor Protection System project demonstrates the implementation of a digital protection circuit using Verilog HDL and an open-source ASIC design flow. It covers synthesis, floorplanning, placement, clock-tree synthesis, routing, parasitic extraction, and static timing analysis.

The project provides practical experience in digital RTL design and physical implementation while highlighting the importance of timing constraints and physical verification before final ASIC sign-off.

