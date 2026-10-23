`timescale 1ns/1ps
module overload_monitor #(parameter CONFIRM_CYCLES=3)(
 input wire clk, rst_n, overload_sync,
 output reg overload_warning, overload_fault
);
 localparam COUNT_W=(CONFIRM_CYCLES<2)?1:$clog2(CONFIRM_CYCLES+1);
 reg [COUNT_W-1:0] count;
 always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin count<=0; overload_warning<=0; overload_fault<=0; end
  else begin
   overload_warning <= overload_sync && !overload_fault;
   if (!overload_sync) begin count<=0; overload_fault<=0; end
   else if (count<CONFIRM_CYCLES) begin
    count<=count+1'b1;
    if (count==CONFIRM_CYCLES-1) overload_fault<=1;
   end else overload_fault<=1;
  end
 end
endmodule
