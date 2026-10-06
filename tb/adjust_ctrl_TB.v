`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:     Arad Greenshtein
// Module Name:  adjust_ctrl_TB
// Project:      Nexys A7 ALU with decimal 7-segment display
// Description:  Testbench for adjust_ctrl + sw_change_detect.
//               Self-checking (PASS/FAIL). Accumulation, both buttons together,
//               reset on switch change, wrap-around 0 <-> 4095, hold via
//               SW[15], and switch change winning over a press in the
//               same cycle.
//////////////////////////////////////////////////////////////////////////////////

module adjust_ctrl_TB;

    // Inputs driven by the TB
    reg         clk        = 1'b0;
    reg  [15:0] sw         = 16'd0;
    reg         up_pulse   = 1'b0;
    reg         down_pulse = 1'b0;

    // Outputs driven by the DUTs
    wire        sw_changed;
    wire [11:0] adj;

    // 100 MHz clock
    always #5 clk = ~clk;

    // Switch change detector feeds the adjust controller
    sw_change_detect u_scd (
        .clk        (clk),
        .sw         (sw),
        .sw_changed (sw_changed)
    );

    adjust_ctrl dut (
        .clk        (clk),
        .up_pulse   (up_pulse),
        .down_pulse (down_pulse),
        .sw_changed (sw_changed),
        .hold       (sw[15]),
        .adj        (adj)
    );

    integer errors = 0;

    // Inputs change on the falling edge so they are stable at the rising edge
    task press_up;
        begin
            @(negedge clk) up_pulse = 1'b1;
            @(negedge clk) up_pulse = 1'b0;
        end
    endtask

    task press_down;
        begin
            @(negedge clk) down_pulse = 1'b1;
            @(negedge clk) down_pulse = 1'b0;
        end
    endtask

    task press_both;
        begin
            @(negedge clk) begin up_pulse = 1'b1; down_pulse = 1'b1; end
            @(negedge clk) begin up_pulse = 1'b0; down_pulse = 1'b0; end
        end
    endtask

    task set_sw (input [15:0] value);
        begin
            @(negedge clk) sw = value;
            @(negedge clk);              // let the change pulse reach adjust_ctrl
        end
    endtask

    task check (input integer id, input [11:0] expected);
        begin
            @(negedge clk);
            if (adj !== expected) begin
                $display("Test %0d FAIL: adj = %0d, expected %0d", id, adj, expected);
                errors = errors + 1;
            end else
                $display("Test %0d PASS: adj = %0d", id, adj);
        end
    endtask

    initial begin
        repeat (3) @(negedge clk);

        // 1. Three up presses accumulate: 0 -> 3
        press_up; press_up; press_up;
        check(1, 12'd3);

        // 2. One down press: 3 -> 2
        press_down;
        check(2, 12'd2);

        // 3. Both buttons in the same cycle: no change
        press_both;
        check(3, 12'd2);

        // 4. Switch change resets the correction: 2 -> 0
        set_sw(16'h0001);
        check(4, 12'd0);

        // 5. Down from 0 wraps to 4095
        press_down;
        check(5, 12'd4095);

        // 6. Up from 4095 wraps to 0
        press_up;
        check(6, 12'd0);

        // 7. SW[15] on: buttons are ignored
        set_sw(16'h8001);
        press_up; press_up;
        check(7, 12'd0);

        // 8. SW[15] off (a switch change) then one up press: 0 -> 1
        set_sw(16'h0001);
        press_up;
        check(8, 12'd1);

        // 9. Switch change and up press in the same cycle: reset wins
        press_up;                                          // 1 -> 2
        @(negedge clk) begin sw = 16'h0003; up_pulse = 1'b1; end
        @(negedge clk) up_pulse = 1'b0;
        check(9, 12'd0);

        if (errors == 0) $display("ALL TESTS PASSED");
        else             $display("%0d TEST(S) FAILED", errors);

        $finish;
    end

endmodule
