`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:     Arad Greenshtein
// Module Name:  sw_change_detect
// Project:      Nexys A7 ALU with decimal 7-segment display
// Target:       Digilent Nexys A7-100T (xc7a100tcsg324-1)
// Description:  Outputs a one-cycle pulse whenever any of the 16 switches changes
//               (current value compared with the value one clock earlier).
//               Note: switches are not synchronized (documented design risk);
//               a rare metastable sample can miss or duplicate a reset of the
//               correction value. The ALU datapath itself is unaffected.
//////////////////////////////////////////////////////////////////////////////////

module sw_change_detect (
    input  wire        clk,                // 100 MHz system clock
    input  wire [15:0] sw,                 // slide switches
    output wire        sw_changed          // one-cycle pulse on any change
);

    // Switch values from the previous clock cycle
    reg [15:0] sw_prev = 16'd0;

    always @(posedge clk) begin
        sw_prev <= sw;
    end

    // High for one cycle whenever any switch differs from the previous cycle
    assign sw_changed = (sw != sw_prev);

endmodule
