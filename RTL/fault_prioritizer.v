`timescale 1ns/1ps
module fault_prioritizer(
 input wire overload_fault, overtemp_fault, supply_fault,
 output reg critical_fault,
 output reg [2:0] fault_code
);
 // Priority: supply > overtemperature > overload.
 // Codes: 000 none, 001 overload, 010 overtemperature, 011 supply.
 always @* begin
  critical_fault=0; fault_code=3'b000;
  if (supply_fault) begin critical_fault=1; fault_code=3'b011; end
  else if (overtemp_fault) begin critical_fault=1; fault_code=3'b010; end
  else if (overload_fault) begin critical_fault=1; fault_code=3'b001; end
 end
endmodule
