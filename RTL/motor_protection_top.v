`timescale 1ns/1ps
module motor_protection_top #(
 parameter OVERLOAD_CONFIRM_CYCLES=3, LOCKOUT_CYCLES=5
)(
 input wire clk, rst_n, start_request,
 input wire overload_sensor, overtemp_sensor, supply_fault_sensor,
 output wire motor_enable, overload_warning, fault_active, lockout_active,
 output wire critical_fault,
 output wire [2:0] fault_code, latched_fault_code
);
 wire overload_sync, overtemp_sync, supply_fault_sync, overload_fault;
 sensor_filter u_sensor_filter(
  .clk(clk), .rst_n(rst_n),
  .overload_sensor(overload_sensor), .overtemp_sensor(overtemp_sensor),
  .supply_fault_sensor(supply_fault_sensor),
  .overload_sync(overload_sync), .overtemp_sync(overtemp_sync),
  .supply_fault_sync(supply_fault_sync)
 );
 overload_monitor #(.CONFIRM_CYCLES(OVERLOAD_CONFIRM_CYCLES)) u_overload_monitor(
  .clk(clk), .rst_n(rst_n), .overload_sync(overload_sync),
  .overload_warning(overload_warning), .overload_fault(overload_fault)
 );
 fault_prioritizer u_fault_prioritizer(
  .overload_fault(overload_fault), .overtemp_fault(overtemp_sync),
  .supply_fault(supply_fault_sync), .critical_fault(critical_fault),
  .fault_code(fault_code)
 );
 motor_controller_fsm #(.LOCKOUT_CYCLES(LOCKOUT_CYCLES)) u_motor_controller_fsm(
  .clk(clk), .rst_n(rst_n), .start_request(start_request),
  .critical_fault(critical_fault), .current_fault_code(fault_code),
  .motor_enable(motor_enable), .fault_active(fault_active),
  .lockout_active(lockout_active), .latched_fault_code(latched_fault_code)
 );
endmodule
