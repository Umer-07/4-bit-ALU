// ============================================================
// Testbench — alu_4bit
// Exhaustive: all A (0-15) × all B (0-15) × all 5 ops
// = 1,280 test cases
// ============================================================

`timescale 1ns/1ps

module alu_4bit_tb;

    // ---- DUT signals ----------------------------------------
    logic [3:0] A, B;
    logic [2:0] op;
    logic [3:0] result;
    logic       carry_out, zero;

    // ---- Pass/fail counters ---------------------------------
    integer pass_count = 0;
    integer fail_count = 0;

    // ---- Instantiate DUT ------------------------------------
    alu_4bit dut (
        .A         (A),
        .B         (B),
        .op        (op),
        .result    (result),
        .carry_out (carry_out),
        .zero      (zero)
    );

    // ---- Operation names for display ------------------------
    function string op_name(input logic [2:0] o);
        case (o)
            3'b000: return "ADD";
            3'b001: return "SUB";
            3'b010: return "AND";
            3'b011: return "OR ";
            3'b100: return "XOR";
            default: return "???";
        endcase
    endfunction

    // ---- Helper: check one output ---------------------------
    task check(
        input string  name,
        input logic   actual,
        input logic   expected
    );
        if (actual !== expected) begin
            $display("  FAIL %s: got %b, expected %b", name, actual, expected);
            fail_count++;
        end else begin
            pass_count++;
        end
    endtask

    // ---- Reference model (pure combinational) ---------------
    logic [4:0] ref_full;
    logic [3:0] ref_result;
    logic       ref_carry, ref_zero;

    task compute_expected;
        case (op)
            3'b000: ref_full = {1'b0,A} + {1'b0,B};
            3'b001: ref_full = {1'b0,A} - {1'b0,B};
            3'b010: ref_full = {1'b0, A & B};
            3'b011: ref_full = {1'b0, A | B};
            3'b100: ref_full = {1'b0, A ^ B};
            default: ref_full = 5'b0;
        endcase
        ref_result = ref_full[3:0];
        ref_carry  = ref_full[4];
        ref_zero   = (ref_result == 4'b0);
    endtask

    // ---- Main exhaustive test loop --------------------------
    integer ia, ib, iop;
    integer first_fail_shown;

    initial begin
        $dumpfile("alu_4bit.vcd");
        $dumpvars(0, alu_4bit_tb);

        $display("=== 4-bit ALU Exhaustive Testbench ===");
        $display("Testing all 16 x 16 x 5 = 1,280 combinations...\n");

        first_fail_shown = 0;

        for (iop = 0; iop < 5; iop++) begin
            op = iop[2:0];
            $display("--- Operation: %s ---", op_name(op));

            for (ia = 0; ia < 16; ia++) begin
                for (ib = 0; ib < 16; ib++) begin
                    A = ia[3:0];
                    B = ib[3:0];
                    #5;  // let combinational logic settle

                    compute_expected;

                    // Only print failures to keep output readable
                    if (result !== ref_result || carry_out !== ref_carry || zero !== ref_zero) begin
                        if (first_fail_shown < 10) begin
                            $display("  FAIL A=%0d B=%0d op=%s | got result=%0d carry=%b zero=%b | exp result=%0d carry=%b zero=%b",
                                ia, ib, op_name(op),
                                result, carry_out, zero,
                                ref_result, ref_carry, ref_zero);
                            first_fail_shown++;
                        end
                        fail_count++;
                    end else begin
                        pass_count++;
                    end
                end
            end
        end

        // ---- Summary ----------------------------------------
        $display("\n=== Results ===");
        $display("PASS: %0d / 1280", pass_count);
        $display("FAIL: %0d / 1280", fail_count);
        if (fail_count == 0)
            $display("ALL TESTS PASSED");
        else
            $display("SOME TESTS FAILED — check output above");

        // ---- Spot-check display for README/waveform ---------
        $display("\n--- Spot checks (printed for waveform verification) ---");
        A = 4'd5; B = 4'd3;
        op = 3'b000; #5;
        $display("ADD  5+3 = %0d (carry=%b zero=%b) [expect 8]",  result, carry_out, zero);
        op = 3'b001; #5;
        $display("SUB  5-3 = %0d (carry=%b zero=%b) [expect 2]",  result, carry_out, zero);
        op = 3'b010; #5;
        $display("AND  5&3 = %0d (carry=%b zero=%b) [expect 1]",  result, carry_out, zero);
        op = 3'b011; #5;
        $display("OR   5|3 = %0d (carry=%b zero=%b) [expect 7]",  result, carry_out, zero);
        op = 3'b100; #5;
        $display("XOR  5^3 = %0d (carry=%b zero=%b) [expect 6]",  result, carry_out, zero);

        $display("\n--- Carry-out test ---");
        A = 4'b1111; B = 4'b0001; op = 3'b000; #5;
        $display("ADD 15+1 = %0d carry=%b zero=%b [expect result=0 carry=1 zero=1]",
                  result, carry_out, zero);

        $display("\n--- Zero flag test ---");
        A = 4'd7; B = 4'd7; op = 3'b001; #5;
        $display("SUB  7-7 = %0d (zero=%b) [expect 0, zero=1]", result, zero);

        $finish;
    end

endmodule
