`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:     Arad Greenshtein
// Module Name:  bin2bcd
// Project:      Nexys A7 ALU with decimal 7-segment display
// Target:       Digilent Nexys A7-100T (xc7a100tcsg324-1)
// Description:  Combinational 12-bit binary to 4-digit BCD converter
//               (double-dabble / shift-and-add-3), fully unrolled.
//
//               Bout[15:12] thousands | Bout[11:8] hundreds |
//               Bout[7:4]   tens      | Bout[3:0]  units
//
//               Algorithm, repeated once per input bit (12 times):
//                 1. Add 3 to every BCD digit that is >= 5
//                 2. Shift the whole register left by one bit
//////////////////////////////////////////////////////////////////////////////////

module bin2bcd(
    input  [11:0] Bin,     // binary input, 0 .. 4095
    output [15:0] Bout     // four BCD digits
    );

    // Shift register layout:
    // [27:24] thousands | [23:20] hundreds | [19:16] tens | [15:12] units | [11:0] input
    reg [27:0] count;  // count[11:0] unused after the last shift (intentional)
    integer i;

    always @(*) begin
        count = {16'd0, Bin};                      // BCD area cleared, input in the low bits

        for(i=0 ; i<12; i=i+1) begin
            // Correct each digit before the shift so it cannot exceed 9 after doubling
            if (count[15:12] >=4'd5)               // units
                count[15:12] = count [15:12] + 4'd3;

            if (count[19:16] >=4'd5)               // tens
                count[19:16] = count [19:16] + 4'd3;

            if (count[23:20] >=4'd5)               // hundreds
                count[23:20] = count [23:20] + 4'd3;

            if (count[27:24] >=4'd5)               // thousands
                count[27:24] = count [27:24] + 4'd3;

            count = count << 1;                    // move the next input bit into the BCD area
        end
    end

    // After 12 shifts the BCD digits are in the upper 16 bits
    assign Bout = count[27:12];

endmodule
