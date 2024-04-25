module Accurate2x2Mul(
    input [1:0] a,b,
    output [3:0] out
);

    wire a1b1, a1b0, a0b1, a0a1b0b1;

    assign a1b1 = a[1] & b[1];
    assign a1b0 = a[1] & b[0];
    assign a0b1 = a[0] & b[1];
    assign a0a1b0b1 = a0b1 & a1b0;

    assign out[3] = a1b1 & a0a1b0b1;
    assign out[2] = a1b1 ^ a0a1b0b1;
    assign out[1] = a0b1 ^ a1b0;
    assign out[0] = a[0] & b[0];

endmodule