`timescale 1ns/1ps
module sensor_filter(
 input wire clk, rst_n,
 input wire overload_sensor, overtemp_sensor, supply_fault_sensor,
 output reg overload_sync, overtemp_sync, supply_fault_sync
);
 reg overload_meta, overtemp_meta, supply_meta;
 always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
   overload_meta<=0; overload_sync<=0;
   overtemp_meta<=0; overtemp_sync<=0;
   supply_meta<=0; supply_fault_sync<=0;
  end else begin
   overload_meta<=overload_sensor; overload_sync<=overload_meta;
   overtemp_meta<=overtemp_sensor; overtemp_sync<=overtemp_meta;
   supply_meta<=supply_fault_sensor; supply_fault_sync<=supply_meta;
  end
 end
endmodule
