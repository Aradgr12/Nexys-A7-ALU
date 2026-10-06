`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:     Arad Greenshtein
// Module Name:  seg_display_TB
// Project:      Nexys A7 ALU with decimal 7-segment display
// Description:  Testbench for seg_display.
//               REFRESH_BITS = 4 (16-cycle refresh). Values 0042, 0305, 0000,
//               4095, 1005 held for one full refresh cycle each.
//               Checked on the waveform: AN rotation, segment patterns,
//               leading-zero blanking, inner zeros kept, DP off.
//////////////////////////////////////////////////////////////////////////////////

module seg_display_TB;

    reg clk = 0;
    reg [15:0] bcd;
    wire [6:0] seg;
    wire [7:0] an;
    wire dp;
    
    always #5 clk = ~clk;
    
    seg_display #(.REFRESH_BITS(4)) seg_display_TB_DUT (
    
        .clk(clk),
        .bcd(bcd),
        .seg(seg),
        .an(an),
        .dp(dp)
    );
    
    initial begin 
        bcd = 16'h0042;
        #160;
        
        bcd = 16'h0305;
        #160;
        
        bcd = 16'h0000;
        #160;
        
        bcd = 16'h4095;
        #160;
        
        bcd = 16'h1005;
        #160;
        
        $finish;
    end
endmodule
