`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:     Arad Greenshtein
// Module Name:  Simple_ALU_TB
// Project:      Nexys A7 ALU with decimal 7-segment display
// Description:  Testbench for Simple_ALU.
//               Directed tests for all 6 operations, range limits (126, 3969),
//               multiply by 0, CMP with A>B / A<B / A=B, unused opcodes
//               110/111 and the zero input. Prints result vs. expected.
//////////////////////////////////////////////////////////////////////////////////

module Simple_ALU_TB;
    reg [2:0] op;
    reg [5:0] A,B;
    reg       zero;
    wire [11:0] out;
    
    Simple_ALU ALU_TB(
        .A(A),
        .B(B),
        .op(op),
        .zero(zero),
        .alu_res(out)
    );
    initial begin 
        zero = 1'd0;
        op = 3'b000;
        A = 6'b000011;  B = 6'b000010;
        #10;
        $display ("op = ADD, A=%0d, B=%0d, zero=%0d, out=%0d (expected 5)", A, B, zero, out);
        
        zero = 1'd1;
        op = 3'b000;
        A = 6'b000011;  B = 6'b000010;
        #10;
        $display ("op = ADD, A=%0d, B=%0d, zero=%0d, out=%0d (expected 0)", A, B, zero, out);
        
        zero = 1'd0;
        op = 3'b000;
        A = 6'b111111;  B = 6'b111111;
        #10;
        $display ("op = ADD, A=%0d, B=%0d, zero=%0d, out=%0d (expected 126)", A, B, zero, out);
        
        op = 3'b001;
        A = 6'b000100; B =6'b000100;
        #10;
        $display ("op = Multiply, A=%0d, B=%0d, zero=%0d, out=%0d (expected 16)", A, B, zero, out);
        
        op = 3'b001;
        A = 6'b000000; B =6'b000100;
        #10;
        $display ("op = Multiply, A=%0d, B=%0d, zero=%0d, out=%0d (expected 0)", A, B, zero, out);
        
        op = 3'b001;
        A = 6'b111111; B =6'b111111;
        #10;
        $display ("op = Multiply, A=%0d, B=%0d, zero=%0d, out=%0d (expected 3969)", A, B, zero, out);
        
        op = 3'b010;
        A = 6'b000000; B = 6'b101000;
        #10;
        $display ("op = OR, A=%0d, B=%0d, zero=%0d, out=%0d (expected 40)", A, B, zero, out);
        
        op = 3'b010;
        A = 6'b010100; B = 6'b001011;
        #10;
        $display ("op = OR, A=%0d, B=%0d, zero=%0d, out=%0d (expected 31)", A, B, zero, out);
        
        op = 3'b011;
        A = 6'b001010; B = 6'b001000;
        #10;
        $display ("op = AND, A=%0d, B=%0d, zero=%0d, out=%0d (expected 8)", A, B, zero, out);
        
        op = 3'b011;
        A = 6'b011111; B = 6'b010101;
        #10;
        $display ("op = AND, A=%0d, B=%0d, zero=%0d, out=%0d (expected 21)", A, B, zero, out);
        
        op = 3'b100;
        A = 6'b000101; B = 6'b001110;
        #10;
        $display ("op = XOR, A=%0d, B=%0d, zero=%0d, out=%0d (expected 11)", A, B, zero, out);
        
        op = 3'b101;
        A = 6'b000001; B = 6'b000111;
        #10;
        $display ("op = CMP, A=%0d, B=%0d, zero=%0d, out=%0d (expected 7)", A, B, zero, out);
        
        
        op = 3'b101;
        A = 6'b000110; B = 6'b000110;
        #10;
        $display ("op = CMP, A=%0d, B=%0d, zero=%0d, out=%0d (expected 6)", A, B, zero, out);
        
        op = 3'b101;
        A = 6'b001111; B = 6'b000010;
        #10;
        $display ("op = CMP, A=%0d, B=%0d, zero=%0d, out=%0d (expected 15)", A, B, zero, out);
        
        op = 3'b110;
        A = 6'b000101; B = 6'b101000;
        #10;
        $display ("op = NA, A=%0d, B=%0d, zero=%0d, out=%0d (expected 0)", A, B, zero, out);
        
        op = 3'b111;
        A = 6'b101010; B = 6'b010101;
        #10;
        $display ("op = NA, A=%0d, B=%0d, zero=%0d, out=%0d (expected 0)", A, B, zero, out);
        
        $finish;   
      end
   endmodule
