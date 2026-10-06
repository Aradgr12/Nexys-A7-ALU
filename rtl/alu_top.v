`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:     Arad Greenshtein
// Module Name:  alu_top
// Project:      Nexys A7 ALU with decimal 7-segment display
// Target:       Digilent Nexys A7-100T (xc7a100tcsg324-1)
// Description:  Top level.
//               SW[2:0]  opcode | SW[8:3] A | SW[14:9] B | SW[15] zero/hold
//               BTNR +1, BTNL -1 on the displayed result
//               LED[15:0] mirror the switches
//               Result shown in decimal (0..4095) on the 7-segment display
//
//               Data path:
//               SW -> Simple_ALU -> (+ adj) -> bin2bcd -> seg_display -> CA..CG, AN, DP
//               BTNR/BTNL -> btn_conditioner -> adjust_ctrl -> adj
//               SW -> sw_change_detect -> adjust_ctrl (reset correction)
//////////////////////////////////////////////////////////////////////////////////

module alu_top(
    input  wire        CLK100MHZ,          // 100 MHz board oscillator
    input  wire [15:0] SW,                 // slide switches
    input  wire        BTNL,               // left button: -1
    input  wire        BTNR,               // right button: +1
    output wire [15:0] LED,                // LEDs mirror the switches
    output wire        CA,                 // segment a (active low)
    output wire        CB,                 // segment b
    output wire        CC,                 // segment c
    output wire        CD,                 // segment d
    output wire        CE,                 // segment e
    output wire        CF,                 // segment f
    output wire        CG,                 // segment g
    output wire [7:0]  AN,                 // digit enables (active low)
    output wire        DP                  // decimal point (active low)
    );

    // Internal nets
    wire [11:0] alu_res;                   // ALU result
    wire [11:0] adj;                       // +/-1 correction
    wire [11:0] result;                    // displayed value
    wire [15:0] bcd;                       // 4 BCD digits
    wire [6:0]  seg;                       // segment pattern {g,f,e,d,c,b,a}
    wire        up_pulse;                  // one pulse per BTNR press
    wire        down_pulse;                // one pulse per BTNL press
    wire        sw_changed;                // one pulse per switch change

    assign LED = SW[15:0];

    // Segment bus to the individual board pins
    assign CA = seg[0];
    assign CB = seg[1];
    assign CC = seg[2];
    assign CD = seg[3];
    assign CE = seg[4];
    assign CF = seg[5];
    assign CG = seg[6];

    // Displayed value = ALU result + accumulated correction (12-bit wrap-around)
    assign result = alu_res + adj;

    Simple_ALU alu_i (
        .op(SW[2:0]),
        .A(SW[8:3]),
        .B(SW[14:9]),
        .zero(SW[15]),
        .alu_res(alu_res)
    );

    // BTNR adds 1, BTNL subtracts 1 (default DEBOUNCE_CYCLES = 10 ms)
    btn_conditioner btnr_i (
        .clk(CLK100MHZ),
        .btn_in(BTNR),
        .btn_pulse(up_pulse)
    );

    btn_conditioner btnl_i (
        .clk(CLK100MHZ),
        .btn_in(BTNL),
        .btn_pulse(down_pulse)
    );

    sw_change_detect sw_change_detect_i (
        .clk(CLK100MHZ),
        .sw(SW),
        .sw_changed(sw_changed)
    );

    adjust_ctrl adjust_ctrl_i (
        .clk(CLK100MHZ),
        .up_pulse(up_pulse),
        .down_pulse(down_pulse),
        .sw_changed(sw_changed),
        .hold(SW[15]),
        .adj(adj)
    );

    bin2bcd bin2bcd_i (
        .Bin(result),
        .Bout(bcd)
    );

    // Default REFRESH_BITS = 19 for the board
    seg_display seg_display_i (
        .clk(CLK100MHZ),
        .bcd(bcd),
        .seg(seg),
        .an(AN),
        .dp(DP)
    );

endmodule
