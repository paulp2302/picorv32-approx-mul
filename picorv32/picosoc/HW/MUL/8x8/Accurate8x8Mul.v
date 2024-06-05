// Accurate8x8Mul
// Implementation of a multiplier tree to calculate a 8x8 multiplication 
// uses: Accurate4x4Mul.v

module Accurate8x8Mul(a, b, out);
    input wire[7:0] a, b;
    output wire[15:0] out;

    wire[15:0] ll, lh, hl, hh;

    assign ll[15:8]  = 8'b0;
    assign lh[3:0]   = 4'b0;
    assign lh[15:12] = 4'b0;
    assign hl[3:0]   = 4'b0;
    assign hl[15:12] = 4'b0;
    assign hh[7:0]   = 8'b0;

    Accurate4x4Mul lxl(.a (a[3:0]), .b (b[3:0]), .out (ll[7:0]));
    Accurate4x4Mul lxh(.a (a[3:0]), .b (b[7:4]), .out (lh[11:4]));
    Accurate4x4Mul hxl(.a (a[7:4]), .b (b[3:0]), .out (hl[11:4]));
    Accurate4x4Mul hxh(.a (a[7:4]), .b (b[7:4]), .out (hh[15:8]));

    assign out = ll + lh + hl + hh;
    
endmodule