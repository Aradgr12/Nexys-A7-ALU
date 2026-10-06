`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:     Arad Greenshtein
// Module Name:  adjust_ctrl
// Project:      Nexys A7 ALU with decimal 7-segment display
// Target:       Digilent Nexys A7-100T (xc7a100tcsg324-1)
// Description:  Holds the +/-1 correction added to the ALU result.
//               Update priority (first match wins, every clock):
//                 1. sw_changed          -> adj = 0
//                 2. hold (SW[15])       -> adj unchanged
//                 3. up_pulse only       -> adj + 1
//                 4. down_pulse only     -> adj - 1
//                 5. both / none         -> adj unchanged
//               12-bit arithmetic wraps around (0 - 1 = 4095, 4095 + 1 = 0).
//////////////////////////////////////////////////////////////////////////////////

module adjust_ctrl (
    input  wire        clk,
    input  wire        up_pulse,     // one-cycle pulse from BTNR
    input  wire        down_pulse,   // one-cycle pulse from BTNL
    input  wire        sw_changed,   // one-cycle pulse when any switch changes
    input  wire        hold,         // SW[15]: freeze the correction
    output wire [11:0] adj           // accumulated correction (mod 4096)
);

    reg [11:0] adj_r = 12'd0;

    // Priority: switch change > hold > single up > single down > no change.
    // 12-bit arithmetic wraps naturally: 0 - 1 = 4095, 4095 + 1 = 0.
    always @(posedge clk) begin
        if (sw_changed)
            adj_r <= 12'd0;
        else if (hold)
            adj_r <= adj_r;
        else if (up_pulse && !down_pulse)
            adj_r <= adj_r + 12'd1;
        else if (down_pulse && !up_pulse)
            adj_r <= adj_r - 12'd1;
        // both pulses together, or no pulse: keep the current value
    end

    assign adj = adj_r;

endmodule
