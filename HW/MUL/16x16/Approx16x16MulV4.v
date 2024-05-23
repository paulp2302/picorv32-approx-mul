// Approx16x16MulV4
// Implementation of a multiplier tree to approximate a 16x16 multiplication 
// uses: Approx8x8MulV1.v

module Approx16x16MulV4(a, b, out);
    input wire[15:0] a, b;
    output wire[31:0] out;

    wire[31:0] ll, lh, hl, hh;
    wire[31:0] sum1, sum2, sum;

    assign ll[31:16] = 16'b0;
    assign lh[7:0]   = 8'b0;
    assign lh[31:24] = 8'b0;
    assign hl[7:0]   = 8'b0;
    assign hl[31:24] = 8'b0;
    assign hh[15:0]  = 16'b0;

    Approx8x8MulV1 lxl(.a (a[7:0]), .b (b[7:0]), .out (ll[15:0]));
    Approx8x8MulV1 lxh(.a (a[7:0]), .b (b[15:8]), .out (lh[23:8]));
    Approx8x8MulV1 hxl(.a (a[15:8]), .b (b[7:0]), .out (hl[23:8]));
    Approx8x8MulV1 hxh(.a (a[15:8]), .b (b[15:8]), .out (hh[31:16]));
    
    ApproxAddMultiBit #(.bitWidth(32)) add1 (
        .A(ll),
        .B(lh),
        .Cin(1'b0), 
        .Sub(1'b0),
        .Sum(sum1),
        .Cout());

    ApproxAddMultiBit #(.bitWidth(32)) add2 (
        .A(hl),
        .B(hh),
        .Cin(1'b0),
        .Sub(1'b0),
        .Sum(sum2),
        .Cout());

    ApproxAddMultiBit #(.bitWidth(32)) add3 (
        .A(sum1),
        .B(sum2),
        .Cin(1'b0),
        .Sub(1'b0),
        .Sum(out),
        .Cout());

endmodule