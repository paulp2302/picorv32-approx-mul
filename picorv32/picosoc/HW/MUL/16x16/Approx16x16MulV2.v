// Approx16x16MulV2
// Implementation of a multiplier tree to approximate a 16x16 multiplication 
// uses: Approx8x8MulV2.v

module Approx16x16MulV2(a, b, out);
    input wire[15:0] a, b;
    output wire[31:0] out;

    wire[31:0] ll, lh, hl, hh;

    assign ll[31:16] = 16'b0;
    assign lh[7:0]   = 8'b0;
    assign lh[31:24] = 8'b0;
    assign hl[7:0]   = 8'b0;
    assign hl[31:24] = 8'b0;
    assign hh[15:0]  = 16'b0;

    Approx8x8MulV2 lxl(.a (a[7:0]), .b (b[7:0]), .out (ll[15:0]));
    Approx8x8MulV2 lxh(.a (a[7:0]), .b (b[15:8]), .out (lh[23:8]));
    Approx8x8MulV2 hxl(.a (a[15:8]), .b (b[7:0]), .out (hl[23:8]));
    Approx8x8MulV2 hxh(.a (a[15:8]), .b (b[15:8]), .out (hh[31:16]));
    
    assign out = ll + lh + hl + hh;

endmodule