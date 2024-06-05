// Approx8x8MulV3
// Implementation of a multiplier tree to approximate a 8x8 multiplication 
// uses: Approx4x4MulV1.v and ApproxAddMultiBit.v

module Approx8x8MulV3(a, b, out);
    input wire[7:0] a, b;
    output wire[15:0] out;

    wire[15:0] ll, lh, hl, hh;
    wire[15:0] sum1, sum2, sum;

    assign ll[15:8]  = 8'b0;
    assign lh[3:0]   = 4'b0;
    assign lh[15:12] = 4'b0;
    assign hl[3:0]   = 4'b0;
    assign hl[15:12] = 4'b0;
    assign hh[7:0]   = 8'b0;

    Approx4x4MulV1 lxl(.a (a[3:0]), .b (b[3:0]), .out (ll[7:0]));
    Approx4x4MulV1 lxh(.a (a[3:0]), .b (b[7:4]), .out (lh[11:4]));
    Approx4x4MulV1 hxl(.a (a[7:4]), .b (b[3:0]), .out (hl[11:4]));
    Approx4x4MulV1 hxh(.a (a[7:4]), .b (b[7:4]), .out (hh[15:8]));

    ApproxAddMultiBit #(.bitWidth(16)) add1 (
        .A(ll),
        .B(lh),
        .Cin(1'b0), 
        .Sub(1'b0),
        .Sum(sum1),
        .Cout());

    ApproxAddMultiBit #(.bitWidth(16)) add2 (
        .A(hl),
        .B(hh),
        .Cin(1'b0),
        .Sub(1'b0),
        .Sum(sum2),
        .Cout());

    ApproxAddMultiBit #(.bitWidth(16)) add3 (
        .A(sum1),
        .B(sum2),
        .Cin(1'b0),
        .Sub(1'b0),
        .Sum(out),
        .Cout());
    
endmodule