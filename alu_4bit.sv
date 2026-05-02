// ============================================================
// 4-bit ALU — Arithmetic Logic Unit
// Supports: ADD, SUB, AND, OR, XOR
// Flags:    carry_out, zero
// ============================================================

module alu_4bit (
    input  logic [3:0] A,          // 4-bit operand A
    input  logic [3:0] B,          // 4-bit operand B
    input  logic [2:0] op,         // 3-bit operation selector

    output logic [3:0] result,     // 4-bit output
    output logic       carry_out,  // set when addition overflows
    output logic       zero        // set when result == 0
);

    // ----------------------------------------------------------
    // Operation codes
    // ----------------------------------------------------------
    localparam OP_ADD = 3'b000;
    localparam OP_SUB = 3'b001;
    localparam OP_AND = 3'b010;
    localparam OP_OR  = 3'b011;
    localparam OP_XOR = 3'b100;

    // ----------------------------------------------------------
    // Combinational ALU logic
    // ----------------------------------------------------------
    logic [4:0] full_result;  // 5-bit to capture carry

    always_comb begin
        full_result = 5'b0;
        carry_out   = 1'b0;

        case (op)
            OP_ADD: full_result = {1'b0, A} + {1'b0, B};
            OP_SUB: full_result = {1'b0, A} - {1'b0, B};
            OP_AND: full_result = {1'b0, A & B};
            OP_OR:  full_result = {1'b0, A | B};
            OP_XOR: full_result = {1'b0, A ^ B};
            default: full_result = 5'b0;
        endcase

        result    = full_result[3:0];
        carry_out = full_result[4];    // bit 4 = carry
        zero      = (result == 4'b0);  // flag when result is zero
    end

endmodule
