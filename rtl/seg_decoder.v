`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:     Arad Greenshtein
// Module Name:  seg_decoder
// Project:      Nexys A7 ALU with decimal 7-segment display
// Target:       Digilent Nexys A7-100T (xc7a100tcsg324-1)
// Description:  Combinational BCD digit to 7-segment pattern decoder.
//               Segments are active low (0 = segment on).
//               seg = {g, f, e, d, c, b, a}, seg[0] = a ... seg[6] = g
//               Non-decimal inputs (10..15) turn all segments off.
//////////////////////////////////////////////////////////////////////////////////

module seg_decoder(
    input  wire [3:0] digit,   // decimal digit 0..9
    output reg  [6:0] seg      // active-low segment pattern {g,f,e,d,c,b,a}
    );

    always @(*) begin
        seg = 7'b1111111;                      // default: all segments off
        case (digit)
            4'd0: seg = 7'b1000000;
            4'd1: seg = 7'b1111001;
            4'd2: seg = 7'b0100100;
            4'd3: seg = 7'b0110000;
            4'd4: seg = 7'b0011001;
            4'd5: seg = 7'b0010010;
            4'd6: seg = 7'b0000010;
            4'd7: seg = 7'b1111000;
            4'd8: seg = 7'b0000000;
            4'd9: seg = 7'b0010000;
            default: seg = 7'b1111111;         // 10..15: blank
        endcase
    end

endmodule
