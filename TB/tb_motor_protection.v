`timescale 1ns/1ps

module tb_motor_protection;

    reg clk = 1'b0;
    always #5 clk = ~clk;

    reg rst_n;
    reg start_request;
    reg overload_sensor;
    reg overtemp_sensor;
    reg supply_fault_sensor;

    wire motor_enable;
    wire overload_warning;
    wire fault_active;
    wire lockout_active;
    wire critical_fault;
    wire [2:0] fault_code;
    wire [2:0] latched_fault_code;

    motor_protection_top #(
        .OVERLOAD_CONFIRM_CYCLES(3),
        .LOCKOUT_CYCLES(4)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .start_request(start_request),
        .overload_sensor(overload_sensor),
        .overtemp_sensor(overtemp_sensor),
        .supply_fault_sensor(supply_fault_sensor),
        .motor_enable(motor_enable),
        .overload_warning(overload_warning),
        .fault_active(fault_active),
        .lockout_active(lockout_active),
        .critical_fault(critical_fault),
        .fault_code(fault_code),
        .latched_fault_code(latched_fault_code)
    );

    task tick;
        begin
            @(posedge clk);
            #1;
        end
    endtask

    task clear_fault_inputs;
        begin
            overload_sensor = 1'b0;
            overtemp_sensor = 1'b0;
            supply_fault_sensor = 1'b0;
        end
    endtask

    task start_motor;
        begin
            start_request = 1'b1;
            repeat (3) tick();

            if (!motor_enable)
                $fatal(1, "FAIL: motor did not start");

            $display("PASS: motor startup");
        end
    endtask

    // Wait for a fault to clear and the controller to recover.
    // start_request stays asserted, so automatic restart is requested.
    task recover;
        integer i;
        reg recovered;
        begin
            clear_fault_inputs();
            recovered = 1'b0;

            for (i = 0; i < 20; i = i + 1) begin
                tick();
                if (motor_enable && !lockout_active &&
                    !fault_active)
                    recovered = 1'b1;
            end

            if (!recovered)
                $fatal(1, "FAIL: automatic recovery did not complete");

            $display("PASS: automatic recovery after fault clearance");
        end
    endtask

    initial begin
        $dumpfile("motor_protection.vcd");
        $dumpvars(0, tb_motor_protection);

        rst_n = 1'b0;
        start_request = 1'b0;
        clear_fault_inputs();

        repeat (3) tick();
        rst_n = 1'b1;
        tick();

        // TEST 1: Normal startup
        start_motor();

        // TEST 2: Persistent overload
        overload_sensor = 1'b1;
        repeat (8) tick();

        if (motor_enable || !fault_active || !lockout_active)
            $fatal(1, "FAIL: overload shutdown");

        if (latched_fault_code != 3'b001)
            $fatal(1, "FAIL: overload fault code");

        $display("PASS: overload shutdown and fault code");
        recover();

        // TEST 3: Overtemperature has priority over overload
        overtemp_sensor = 1'b1;
        overload_sensor = 1'b1;
        repeat (5) tick();

        if (motor_enable || !fault_active)
            $fatal(1, "FAIL: combined fault shutdown");

        if (latched_fault_code != 3'b010)
            $fatal(1, "FAIL: overtemperature priority");

        $display("PASS: overtemperature priority");
        recover();

        // TEST 4: Supply fault has highest priority
        overtemp_sensor = 1'b1;
        supply_fault_sensor = 1'b1;
        repeat (5) tick();

        if (motor_enable || !fault_active)
            $fatal(1, "FAIL: supply fault shutdown");

        if (latched_fault_code != 3'b011)
            $fatal(1, "FAIL: supply fault priority");

        $display("PASS: supply fault priority");

        // TEST 5: Clear fault and remove start request
        // Do not call recover here, because that task keeps
        // start_request asserted to test automatic restart.
        start_request = 1'b0;
        clear_fault_inputs();

        repeat (20) tick();

        if (motor_enable)
            $fatal(1, "FAIL: motor enabled without start request");

        if (fault_active || lockout_active)
            $fatal(1, "FAIL: controller did not return to IDLE");

        $display("PASS: no restart without start request");

        // TEST 6: A new start request should start the motor again
        start_request = 1'b1;
        repeat (3) tick();

        if (!motor_enable)
            $fatal(1, "FAIL: motor did not restart on new request");

        $display("PASS: motor starts on a new request");
        $display("ALL TESTS PASSED");

        $finish;
    end

endmodule

