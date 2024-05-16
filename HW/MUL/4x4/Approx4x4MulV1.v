// Approx4x4MulV1
// Implementation of a multiplier tree to approximate a 4x4 multiplication 
// uses: Approx2x2Mul.v

module Approx4x4MulV1(a, b, out);
    input wire[3:0] a, b;
    output wire[7:0] out;

    wire[7:0] ll, lh, hl, hh;

    assign ll[7:4] = 4'b0;
    assign lh[1:0] = 2'b0;
    assign lh[7:6] = 2'b0;
    assign hl[1:0] = 2'b0;
    assign hl[7:6] = 2'b0;
    assign hh[3:0] = 4'b0;

    Approx2x2Mul lxl(.a (a[1:0]), .b (b[1:0]), .out (ll[3:0]));
    Approx2x2Mul lxh(.a (a[1:0]), .b (b[3:2]), .out (lh[5:2]));
    Approx2x2Mul hxl(.a (a[3:2]), .b (b[1:0]), .out (hl[5:2]));
    Approx2x2Mul hxh(.a (a[3:2]), .b (b[3:2]), .out (hh[7:4]));

    assign out = ll + lh + hl + hh;
    
endmodule