// Accurate16x16Mul
// Implementation of a multiplier tree to calculate a 16x16 multiplication 
// uses: Accurate8x8Mul.v

module Accurate16x16Mul(a, b, out);
    input wire[15:0] a, b;
    output wire[31:0] out;

    wire[31:0] ll, lh, hl, hh;

    assign ll[31:16] = 16'b0;
    assign lh[7:0]   = 8'b0;
    assign lh[31:24] = 8'b0;
    assign hl[7:0]   = 8'b0;
    assign hl[31:24] = 8'b0;
    assign hh[15:0]  = 16'b0;

    Accurate8x8Mul lxl(.a (a[7:0]), .b (b[7:0]), .out (ll[15:0]));
    Accurate8x8Mul lxh(.a (a[7:0]), .b (b[15:8]), .out (lh[23:8]));
    Accurate8x8Mul hxl(.a (a[15:8]), .b (b[7:0]), .out (hl[23:8]));
    Accurate8x8Mul hxh(.a (a[15:8]), .b (b[15:8]), .out (hh[31:16]));

    assign out = ll + lh + hl + hh;
    
endmodule