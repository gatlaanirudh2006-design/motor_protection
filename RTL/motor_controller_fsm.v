`timescale 1ns/1ps
module motor_controller_fsm #(parameter LOCKOUT_CYCLES=5)(
 input wire clk, rst_n, start_request, critical_fault,
 input wire [2:0] current_fault_code,
 output reg motor_enable, fault_active, lockout_active,
 output reg [2:0] latched_fault_code
);
 localparam [1:0] IDLE=2'd0, RUNNING=2'd1, LOCKOUT=2'd2;
 localparam LOCK_W=(LOCKOUT_CYCLES<2)?1:$clog2(LOCKOUT_CYCLES+1);
 reg [1:0] state;
 reg [LOCK_W-1:0] lock_count;
 always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
   state<=IDLE; lock_count<=0; motor_enable<=0;
   fault_active<=0; lockout_active<=0; latched_fault_code<=0;
  end else begin
   case(state)
    IDLE: begin
     motor_enable<=0; lockout_active<=0;
     if (start_request && !critical_fault) state<=RUNNING;
    end
    RUNNING: begin
     motor_enable<=1;
     if (critical_fault) begin
      motor_enable<=0; fault_active<=1;
      latched_fault_code<=current_fault_code;
      lock_count<=0; lockout_active<=1; state<=LOCKOUT;
     end
    end
    LOCKOUT: begin
     motor_enable<=0; lockout_active<=1;
     if (lock_count<LOCKOUT_CYCLES) lock_count<=lock_count+1'b1;
     else if (!critical_fault) begin
      fault_active<=0; latched_fault_code<=0;
      lockout_active<=0; lock_count<=0;
      if (start_request) begin motor_enable<=1; state<=RUNNING; end
      else state<=IDLE;
     end
    end
    default: begin state<=IDLE; motor_enable<=0; end
   endcase
  end
 end
endmodule
