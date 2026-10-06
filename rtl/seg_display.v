`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:     Arad Greenshtein
// Module Name:  seg_display
// Project:      Nexys A7 ALU with decimal 7-segment display
// Target:       Digilent Nexys A7-100T (xc7a100tcsg324-1)
// Description:  4-digit time-multiplexed 7-segment display controller.
//               - A free-running counter selects one digit at a time
//                 (top 2 bits of the counter = digit_sel).
//               - Only one anode is active per slot; the shared segment lines
//                 carry the pattern of that digit.
//               - Leading zeros are blanked (units digit is always shown).
//               - Digits 4..7 and the decimal point are always off.
//               Anodes, segments and DP are active low.
//
//               REFRESH_BITS = 19 at 100 MHz: each digit slot is 2^17 cycles
//               (~1.3 ms), full 4-digit cycle ~5.2 ms (~190 Hz, no flicker).
//               Use a small value (e.g. 4) in simulation.
//////////////////////////////////////////////////////////////////////////////////

module seg_display #(
    parameter REFRESH_BITS = 19            // width of the multiplexing counter
)(
    input  wire        clk,                // 100 MHz system clock
    input  wire [15:0] bcd,                // {thousands, hundreds, tens, units}
    output wire [6:0]  seg,                // active-low segments {g,f,e,d,c,b,a}
    output wire [7:0]  an,                 // active-low digit enables AN[7:0]
    output wire        dp                  // active-low decimal point
);

    // Free-running refresh counter (no reset: initial value from configuration)
    reg [REFRESH_BITS-1:0] cnt = 0;

    always @(posedge clk) begin
        cnt <= cnt + 1'b1;
    end

    // The two slowest-changing bits select the active digit slot
    wire [1:0] digital_sel;
    assign digital_sel = cnt[REFRESH_BITS-1 : REFRESH_BITS-2];

    reg [3:0] digit;        // BCD digit shown in the current slot
    reg [7:0] an_active;    // anode pattern for the current slot (before blanking)
    reg       blank;        // 1 = current digit is a leading zero

    always @(*) begin
        // Defaults (prevent latches)
        digit     = 4'd0;
        an_active = 8'b11111111;
        blank     = 1'b0;

        case (digital_sel)
            2'b00 : begin                          // units: never blanked
                digit     = bcd[3:0];
                an_active = 8'b11111110;
                blank     = 1'b0;
            end

            2'b01 : begin                          // tens: blank if tens..thousands are 0
                digit     = bcd[7:4];
                an_active = 8'b11111101;
                blank     = (bcd[15:4] == 12'd0);
            end

            2'b10 : begin                          // hundreds: blank if hundreds..thousands are 0
                digit     = bcd[11:8];
                an_active = 8'b11111011;
                blank     = (bcd[15:8] == 8'd0);
            end

            2'b11 : begin                          // thousands: blank if 0
                digit     = bcd[15:12];
                an_active = 8'b11110111;
                blank     = (bcd[15:12] ==4'd0);
            end
        endcase
    end

    // Blanked slot: all anodes off
    assign an = blank ? 8'b11111111 : an_active;

    // Digit to segment pattern
    seg_decoder seg_decoder_i (
        .digit(digit),
        .seg(seg)
    );

    // Decimal point always off
    assign dp = 1'b1;

endmodule
