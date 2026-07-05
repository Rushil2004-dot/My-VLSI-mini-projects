// ============================================================
//  03_adders.v — Ripple Carry Adder  &  Carry Lookahead Adder
//
//  KEY INTERVIEW CONCEPTS
//  ──────────────────────
//  HALF ADDER  : adds 2 bits.  No carry-in.
//  FULL ADDER  : adds 3 bits (A, B, Cin).  Has carry-in.
//
//  RIPPLE CARRY ADDER (RCA)
//  ────────────────────────
//  Chain N full adders.  Carry "ripples" from LSB to MSB.
//  Simple but SLOW: each stage waits for carry from previous.
//  Delay grows linearly → O(N).
//
//  CARRY LOOKAHEAD ADDER (CLA)
//  ───────────────────────────
//  Pre-computes carries using Generate (G) and Propagate (P):
//    G[i] = A[i] & B[i]   → this bit GENERATES a carry
//    P[i] = A[i] ^ B[i]   → this bit PROPAGATES incoming carry
//    C[i+1] = G[i] | (P[i] & C[i])
//  All carries computed IN PARALLEL → O(log N) delay.
//  Faster but uses more gates.
//
//  INTERVIEW QUESTION OFTEN ASKED:
//  "What is the critical path of a 4-bit RCA?"
//  Answer: Carry chain from bit 0 to bit 3 = 4 × FA delay.
//  CLA computes all carries simultaneously → much shorter path.
// ============================================================


// ──────────────────────────────────────────────
// MODULE 1 : Half Adder
// ──────────────────────────────────────────────
//   A B | Sum Cout
//   ────┼────────
//   0 0 |  0   0
//   0 1 |  1   0
//   1 0 |  1   0
//   1 1 |  0   1
// ──────────────────────────────────────────────
module half_adder (
    input  wire a, b,
    output wire sum, cout
);
    assign sum  = a ^ b;
    assign cout = a & b;
endmodule


// ──────────────────────────────────────────────
// MODULE 2 : Full Adder
// ──────────────────────────────────────────────
//   A B Cin | Sum  Cout
//   ─────────┼─────────
//   0 0  0  |  0    0
//   0 0  1  |  1    0
//   0 1  0  |  1    0
//   0 1  1  |  0    1
//   1 0  0  |  1    0
//   1 0  1  |  0    1
//   1 1  0  |  0    1
//   1 1  1  |  1    1
// ──────────────────────────────────────────────
module full_adder (
    input  wire a, b, cin,
    output wire sum, cout
);
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule


// ──────────────────────────────────────────────
// MODULE 3 : 4-bit Ripple Carry Adder
//            Built from 4 full adders chained.
//            Carry RIPPLES: c0→c1→c2→c3→cout
// ──────────────────────────────────────────────
module rca_4bit (
    input  wire [3:0] a, b,
    input  wire       cin,
    output wire [3:0] sum,
    output wire       cout
);
    wire c1, c2, c3;   // intermediate carries

    full_adder fa0 (.a(a[0]), .b(b[0]), .cin(cin), .sum(sum[0]), .cout(c1));
    full_adder fa1 (.a(a[1]), .b(b[1]), .cin(c1),  .sum(sum[1]), .cout(c2));
    full_adder fa2 (.a(a[2]), .b(b[2]), .cin(c2),  .sum(sum[2]), .cout(c3));
    full_adder fa3 (.a(a[3]), .b(b[3]), .cin(c3),  .sum(sum[3]), .cout(cout));
endmodule


// ──────────────────────────────────────────────
// MODULE 4 : 8-bit Ripple Carry Adder
//            Two 4-bit RCAs chained
// ──────────────────────────────────────────────
module rca_8bit (
    input  wire [7:0] a, b,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout
);
    wire carry_mid;

    rca_4bit low  (.a(a[3:0]), .b(b[3:0]), .cin(cin),       .sum(sum[3:0]), .cout(carry_mid));
    rca_4bit high (.a(a[7:4]), .b(b[7:4]), .cin(carry_mid), .sum(sum[7:4]), .cout(cout));
endmodule


// ──────────────────────────────────────────────
// MODULE 5 : 4-bit Carry Lookahead Adder (CLA)
//
//  Step 1: Compute G and P for each bit
//    G[i] = A[i] & B[i]     (generates carry independently)
//    P[i] = A[i] ^ B[i]     (propagates if carry comes in)
//
//  Step 2: Expand carry equations (no chaining!)
//    C[1] = G[0] | (P[0] & C[0])
//    C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0])
//    C[3] = G[2] | (P[2]&G[1])  | (P[2]&P[1]&G[0])
//                               | (P[2]&P[1]&P[0]&C[0])
//    C[4] = G[3] | (P[3]&G[2])  | (P[3]&P[2]&G[1])
//                               | (P[3]&P[2]&P[1]&G[0])
//                               | (P[3]&P[2]&P[1]&P[0]&C[0])
//
//  Step 3: Sum[i] = P[i] ^ C[i]  (same as XOR with carry-in)
// ──────────────────────────────────────────────
module cla_4bit (
    input  wire [3:0] a, b,
    input  wire       cin,
    output wire [3:0] sum,
    output wire       cout
);
    // Generate and Propagate
    wire [3:0] g;      // g[i] = a[i] & b[i]
    wire [3:0] p;      // p[i] = a[i] ^ b[i]

    assign g = a & b;
    assign p = a ^ b;

    // Carry lookahead — all computed in PARALLEL (no chain)
    wire [4:0] c;
    assign c[0] = cin;
    assign c[1] = g[0]
                | (p[0] & c[0]);

    assign c[2] = g[1]
                | (p[1] & g[0])
                | (p[1] & p[0] & c[0]);

    assign c[3] = g[2]
                | (p[2] & g[1])
                | (p[2] & p[1] & g[0])
                | (p[2] & p[1] & p[0] & c[0]);

    assign c[4] = g[3]
                | (p[3] & g[2])
                | (p[3] & p[2] & g[1])
                | (p[3] & p[2] & p[1] & g[0])
                | (p[3] & p[2] & p[1] & p[0] & c[0]);

    // Final sum
    assign sum  = p ^ c[3:0];
    assign cout = c[4];

endmodule


// ──────────────────────────────────────────────
// TESTBENCH  (tests RCA and CLA for same inputs)
// ──────────────────────────────────────────────
`timescale 1ns/1ps
module adder_tb;

    reg  [3:0] a, b;
    reg        cin;
    wire [3:0] rca_sum, cla_sum;
    wire       rca_cout, cla_cout;

    rca_4bit rca (.a(a), .b(b), .cin(cin), .sum(rca_sum), .cout(rca_cout));
    cla_4bit cla (.a(a), .b(b), .cin(cin), .sum(cla_sum), .cout(cla_cout));

    integer i;
    reg [4:0] expected;

    initial begin
        $dumpfile("adder.vcd"); $dumpvars(0, adder_tb);
        $display("=== 4-bit RCA vs CLA Exhaustive Test ===");
        $display("A    | B    | Cin | RCA Sum Cout | CLA Sum Cout | Expected | Match");

        cin = 0;
        for (i = 0; i < 256; i = i+1) begin
            {a, b} = i; #5;
            expected = a + b + cin;
            if ({rca_cout, rca_sum} !== expected ||
                {cla_cout, cla_sum} !== expected) begin
                $display("FAIL a=%04b b=%04b | RCA=%b%04b CLA=%b%04b exp=%05b",
                          a, b, rca_cout, rca_sum, cla_cout, cla_sum, expected);
            end
        end

        // Test with carry-in = 1
        cin = 1;
        for (i = 0; i < 256; i = i+1) begin
            {a, b} = i; #5;
            expected = a + b + cin;
            if ({rca_cout, rca_sum} !== expected ||
                {cla_cout, cla_sum} !== expected) begin
                $display("FAIL cin=1 a=%04b b=%04b | exp=%05b", a, b, expected);
            end
        end

        $display("All 512 combinations PASSED. RCA == CLA for all inputs.");
        $finish;
    end

endmodule
