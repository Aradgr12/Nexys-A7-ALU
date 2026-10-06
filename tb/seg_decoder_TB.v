`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:     Arad Greenshtein
// Module Name:  seg_decoder_TB
// Project:      Nexys A7 ALU with decimal 7-segment display
// Description:  Testbench for seg_decoder.
//               All 16 input codes: digits 0..9 vs. the segment table and
//               10..15 (all segments off). seg printed in binary {g..a}.
//////////////////////////////////////////////////////////////////////////////////

module seg_decoder_TB;
    reg [3:0] digit;
    wire [6:0] seg;
    
seg_decoder seg_decoder_TB_DUT(
     
     .digit(digit),
     .seg(seg)
); 

    initial begin
        digit = 4'd0;
        #10;
        $display("digit=%0d, seg=%b, (expected = 1000000)", digit, seg);
        
        digit = 4'd1;
        #10;
        $display("digit=%0d, seg=%b, (expected = 1111001)", digit, seg);  
        
        digit = 4'd2;
        #10;
        $display("digit=%0d, seg=%b, (expected = 0100100)", digit, seg);
        
        digit = 4'd3;
        #10;
        $display("digit=%0d, seg=%b, (expected = 0110000)", digit, seg);
        
        digit = 4'd4;
        #10;
        $display("digit=%0d, seg=%b, (expected = 0011001)", digit, seg);
        
        digit = 4'd5;
        #10;
        $display("digit=%0d, seg=%b, (expected = 0010010)", digit, seg);
        
        digit = 4'd6;
        #10;
        $display("digit=%0d, seg=%b, (expected = 0000010)", digit, seg);
        
        digit = 4'd7;
        #10;
        $display("digit=%0d, seg=%b, (expected = 1111000)", digit, seg);
        
        digit = 4'd8;
        #10;
        $display("digit=%0d, seg=%b, (expected = 0000000)", digit, seg);
        
        digit = 4'd9;
        #10;
        $display("digit=%0d, seg=%b, (expected = 0010000)", digit, seg);
        
        digit = 4'd10;
        #10;
        $display("digit=%0d, seg=%b, (expected = 1111111)", digit, seg);
        
        digit = 4'd11;
        #10;
        $display("digit=%0d, seg=%b, (expected = 1111111)", digit, seg);
        
        digit = 4'd12;
        #10;
        $display("digit=%0d, seg=%b, (expected = 1111111)", digit, seg);
        
        digit = 4'd13;
        #10;
        $display("digit=%0d, seg=%b, (expected = 1111111)", digit, seg);
        
        digit = 4'd14;
        #10;
        $display("digit=%0d, seg=%b, (expected = 1111111)", digit, seg);
        
        digit = 4'd15;
        #10;
        $display("digit=%0d, seg=%b, (expected = 1111111)", digit, seg);
        
        $finish;
        
        end  
    
endmodule
