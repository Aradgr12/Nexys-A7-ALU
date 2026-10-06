`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:     Arad Greenshtein
// Module Name:  Simple_ALU
// Project:      Nexys A7 ALU with decimal 7-segment display
// Target:       Digilent Nexys A7-100T (xc7a100tcsg324-1)
// Description:  Combinational ALU. Two 6-bit unsigned operands, 3-bit opcode,
//               12-bit unsigned result (zero-extended).
//
//               op   | operation | result range
//               -----+-----------+-------------
//               000  | A + B     | 0 .. 126
//               001  | A * B     | 0 .. 3969
//               010  | A | B     | 0 .. 63
//               011  | A & B     | 0 .. 63
//               100  | A ^ B     | 0 .. 63
//               101  | max(A,B)  | 0 .. 63
//               110  | unused    | 0
//               111  | unused    | 0
//
//               zero = 1 forces the result to 0 regardless of op.
//////////////////////////////////////////////////////////////////////////////////

module Simple_ALU(
    input  wire [2:0]  op,        // operation select
    input  wire [5:0]  A, B,      // unsigned operands
    input  wire        zero,      // force result to 0
    output reg  [11:0] alu_res    // unsigned result
    );

    // Opcodes
    localparam [2:0] ADD = 3'b000,
                     MUL = 3'b001,
                     OR  = 3'b010,
                     AND = 3'b011,
                     XOR = 3'b100,
                     CMP = 3'b101;

    // Operands zero-extended to the result width, so every operation
    // is evaluated in 12 bits (no truncation of the sum or product)
    wire [11:0] A_opd;
    wire [11:0] B_opd;

    assign A_opd = {6'b0, A};
    assign B_opd = {6'b0, B};

    always @(*) begin
        if (zero) begin
            alu_res = 12'd0;
        end else begin
            case(op)
                ADD: alu_res     = A_opd + B_opd;
                MUL: alu_res     = A_opd * B_opd;
                OR:  alu_res     = A_opd | B_opd;
                AND: alu_res     = A_opd & B_opd;
                XOR: alu_res     = A_opd ^ B_opd;
                CMP: alu_res     = (A>=B) ? A_opd : B_opd;   // the larger operand
                default: alu_res = 12'd0;                    // unused opcodes 110, 111
            endcase
        end
    end

endmodule
