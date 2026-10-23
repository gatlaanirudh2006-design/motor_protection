
# Motor Protection - Static Timing Constraints

# Clock definition: 20 ns period (50 MHz)
create_clock -name core_clock -period 20.000 [get_ports clk]

# Clock uncertainty and transition
set_clock_uncertainty 0.200 [get_clocks core_clock]
set_clock_transition 0.100 [get_clocks core_clock]

# Input delays
set_input_delay 2.000 -clock core_clock \
    [get_ports {start_request overload_sensor overtemp_sensor supply_fault_sensor}]

# Reset is asynchronous; do not treat it as an ordinary synchronous data input.
# This input delay is provided for completeness; adjust reset analysis as required.
set_input_delay 2.000 -clock core_clock [get_ports rst_n]

# Output delays
set_output_delay 2.000 -clock core_clock \
    [get_ports {motor_enable overload_warning fault_active lockout_active critical_fault fault_code[*] latched_fault_code[*]}]

# Input transition
set_input_transition 0.100 \
    [get_ports {start_request overload_sensor overtemp_sensor supply_fault_sensor rst_n}]

# Output load (pF; confirm this value against your design requirements)
set_load 5.0 \
    [get_ports {motor_enable overload_warning fault_active lockout_active critical_fault fault_code[*] latched_fault_code[*]}]

