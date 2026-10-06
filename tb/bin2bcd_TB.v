`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:     Arad Greenshtein
// Module Name:  bin2bcd_TB
// Project:      Nexys A7 ALU with decimal 7-segment display
// Description:  Testbench for bin2bcd.
//               12 directed values: 0, 5, 9, 10, 25, 99, 100, 999, 1000, 1005,
//               3969, 4095. Bout is printed in hex so it reads as the
//               decimal digits (compare with the expected value).
//////////////////////////////////////////////////////////////////////////////////

module bin2bcd_TB;

reg [11:0] Bin; 
wire [15:0] Bout;

bin2bcd bin2bcd_TB_DUT(

    .Bin(Bin),
    .Bout(Bout)
);

    initial begin
        Bin = 12'd0;
        #10;
        $display ("Bin=%0d, Bout=%h, (expected 0000)", Bin, Bout);
        
        Bin = 12'd5;
        #10;
        $display ("Bin=%0d, Bout=%h, (expected 0005)", Bin, Bout);
        
        Bin = 12'd9;
        #10;
        $display ("Bin=%0d, Bout=%h, (expected 0009)", Bin, Bout);
        
        Bin = 12'd10;
        #10;
        $display ("Bin=%0d, Bout=%h, (expected 0010)", Bin, Bout);
        
        Bin = 12'd25;
        #10;
        $display ("Bin=%0d, Bout=%h, (expected 0025)", Bin, Bout);
        
        Bin = 12'd99;
        #10;
        $display ("Bin=%0d, Bout=%h, (expected 0099)", Bin, Bout);
        
        Bin = 12'd100;
        #10;
        $display ("Bin=%0d, Bout=%h, (expected 0100)", Bin, Bout);
        
        Bin = 12'd999;
        #10;
        $display ("Bin=%0d, Bout=%h, (expected 0999)", Bin, Bout);
        
        Bin = 12'd1000;
        #10;
        $display ("Bin=%0d, Bout=%h, (expected 1000)", Bin, Bout);
        
        Bin = 12'd1005;
        #10;
        $display ("Bin=%0d, Bout=%h, (expected 1005)", Bin, Bout);
        
        Bin = 12'd3969;
        #10;
        $display ("Bin=%0d, Bout=%h, (expected 3969)", Bin, Bout);
        
        Bin = 12'd4095;
        #10;
        $display ("Bin=%0d, Bout=%h, (expected 4095)", Bin, Bout);
        
        $finish;
        
        end 
            
endmodule
