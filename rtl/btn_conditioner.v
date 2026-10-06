`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:     Arad Greenshtein
// Module Name:  btn_conditioner
// Project:      Nexys A7 ALU with decimal 7-segment display
// Target:       Digilent Nexys A7-100T (xc7a100tcsg324-1)
// Description:  Push-button conditioner: 2-FF synchronizer + debounce FSM.
//               Outputs exactly one 1-cycle pulse per physical press.
//               - Bounces during press or release are filtered.
//               - A long press produces a single pulse (no auto-repeat).
//
//               FSM states:
//                 IDLE         - released and stable
//                 PRESS_WAIT   - press seen, waiting DEBOUNCE_CYCLES stable cycles
//                 PRESSED      - pressed and stable (pulse issued on entry)
//                 RELEASE_WAIT - release seen, waiting DEBOUNCE_CYCLES stable cycles
//
//               DEBOUNCE_CYCLES = 1,000,000 -> 10 ms at 100 MHz.
//               Use a small value (e.g. 4) in simulation.
//////////////////////////////////////////////////////////////////////////////////

module btn_conditioner #(
    parameter DEBOUNCE_CYCLES = 1000000    // stable cycles required (10 ms @ 100 MHz)
)(
    input      clk,                        // 100 MHz system clock
    input      btn_in,                     // raw, asynchronous button input
    output reg btn_pulse                   // one-cycle pulse per press
    );

    // 2-FF synchronizer registers (reduce metastability risk)
    reg btn_sync1 = 1'b0;
    reg btn_sync2 = 1'b0;

    // FSM state encoding
    localparam [1:0] IDLE         = 2'b00,
                     PRESS_WAIT   = 2'b01,
                     PRESSED      = 2'b10,
                     RELEASE_WAIT = 2'b11;

    reg [1:0] state  = 2'h00;                               // starts in IDLE
    reg [$clog2(DEBOUNCE_CYCLES)-1:0] cnt = 0;              // debounce timer

    // Synchronizer: two flip-flops in series
    always @(posedge clk) begin
        btn_sync1 <= btn_in;
        btn_sync2 <= btn_sync1;
    end

    // Debounce FSM
    always @(posedge clk) begin

        btn_pulse <= 1'b0;                                  // default: no pulse

        case (state)
            IDLE: begin
                if (btn_sync2) begin                        // press detected
                    state <= PRESS_WAIT;
                    cnt <= 0;
                end
            end

            PRESS_WAIT: begin
                if (!btn_sync2) begin                       // bounce: back to IDLE
                    state <= IDLE;
                end else if (cnt == DEBOUNCE_CYCLES-1) begin   // stable press
                    state <= PRESSED;
                    btn_pulse <= 1'b1;                      // the only pulse source
                end else begin                              // still waiting
                    cnt <= cnt + 1'b1;
                end
            end

            PRESSED: begin
                if (!btn_sync2) begin                       // release detected
                    state <= RELEASE_WAIT;
                    cnt <= 0;
                end else begin                              // still held: stay
                    state <= PRESSED;
                end
            end

            RELEASE_WAIT: begin
                if (btn_sync2) begin                        // bounce during release: back to PRESSED, no pulse
                    state <= PRESSED;
                end else if (cnt == DEBOUNCE_CYCLES-1) begin   // released and stable
                    state <= IDLE;
                end else begin                              // still waiting
                    cnt <= cnt + 1'b1;
                end
            end

            default: state <= IDLE;                         // safety (all 4 codes are used)

        endcase
    end

endmodule
