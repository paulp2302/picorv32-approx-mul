// Approx2x2Mul
// Implementation for approximate multiplier (Version 2) 

module Approx2x2Mul(a, b, out);
    input wire[1:0] a, b;
    output wire[3:0] out;

    wire a0b1, a1b0, a1b1;

    assign a0b1 = a[0] & b[1];
    assign a1b0 = a[1] & b[0];
    assign a1b1 = a[1] & b[1];

    assign out[0] = a0b1 & a1b0;
    assign out[1] = a0b1 ^ a1b0;
    assign out[2] = out[0] ^ a1b1;
    assign out[3] = a0b1 & a1b0;
endmodule