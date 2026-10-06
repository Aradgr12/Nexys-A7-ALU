`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:     Arad Greenshtein
// Module Name:  btn_conditioner_TB
// Project:      Nexys A7 ALU with decimal 7-segment display
// Description:  Testbench for btn_conditioner.
//               DEBOUNCE_CYCLES = 4. Counts output pulses across 5 scenarios:
//               clean press, bouncing press, short glitch, bouncing
//               release, two separate presses (expected total = 5).
//               Note: runs ~1300 ns (set simulation run time to 'all').
//////////////////////////////////////////////////////////////////////////////////

module btn_conditioner_TB;

    // DUT inputs (driven by the TB) and output (driven by the DUT)
    reg  clk    = 1'b0;
    reg  btn_in = 1'b0;
    wire btn_pulse;

    // 100 MHz clock: toggles every 5 ns -> 10 ns period
    always #5 clk = ~clk;

    // Short debounce in simulation: 4 cycles = 40 ns instead of 10 ms
    btn_conditioner #(.DEBOUNCE_CYCLES(4)) dut (
        .clk       (clk),
        .btn_in    (btn_in),
        .btn_pulse (btn_pulse)
    );

    // Count every output pulse (one clock cycle wide)
    integer pulse_count = 0;

    always @(posedge clk)
        if (btn_pulse)
            pulse_count = pulse_count + 1;

    initial begin
        btn_in = 1'b0;
        #100;

        // Scenario 1: clean press, clean release -> +1 pulse
        btn_in = 1'b1;  #100;
        btn_in = 1'b0;  #100;
        $display("Scenario 1 (clean press)          : pulse_count = %0d (expected 1)", pulse_count);

        // Scenario 2: bouncing press, then stable -> +1 pulse
        btn_in = 1'b1;  #10;
        btn_in = 1'b0;  #10;
        btn_in = 1'b1;  #10;
        btn_in = 1'b0;  #10;
        btn_in = 1'b1;  #100;
        btn_in = 1'b0;  #100;
        $display("Scenario 2 (bouncing press)       : pulse_count = %0d (expected 2)", pulse_count);

        // Scenario 3: short glitch only (shorter than debounce) -> no pulse
        btn_in = 1'b1;  #20;
        btn_in = 1'b0;  #100;
        $display("Scenario 3 (short glitch)         : pulse_count = %0d (expected 2)", pulse_count);

        // Scenario 4: clean press, bouncing release -> +1 pulse, release not counted
        btn_in = 1'b1;  #100;
        btn_in = 1'b0;  #10;
        btn_in = 1'b1;  #10;
        btn_in = 1'b0;  #10;
        btn_in = 1'b1;  #10;
        btn_in = 1'b0;  #100;
        $display("Scenario 4 (bouncing release)     : pulse_count = %0d (expected 3)", pulse_count);

        // Scenario 5: two separate clean presses -> +2 pulses
        btn_in = 1'b1;  #100;
        btn_in = 1'b0;  #100;
        btn_in = 1'b1;  #100;
        btn_in = 1'b0;  #100;
        $display("Scenario 5 (two separate presses) : pulse_count = %0d (expected 5)", pulse_count);

        $finish;
    end

endmodule
