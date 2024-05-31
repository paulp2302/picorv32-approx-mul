// Accurate4x4Mul
// Implementation of a multiplier tree to calculate a 4x4 multiplication 
// uses: Accurate2x2Mul.v

module Config4x4Mul(a, b, out);
    parameter N4 = 0;

    input wire[3:0] a, b;
    output wire[7:0] out;

    wire[7:0] ll, lh, hl, hh;
    wire[7:0] sum1, sum2;

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

    ConfigAddMultiBit #(.bitWidth(8), .approxWidth(N4)) add1(.A(ll), .B(lh), .Sum(sum1));
    ConfigAddMultiBit #(.bitWidth(8), .approxWidth(N4)) add2(.A(hl), .B(hh), .Sum(sum2));
    ConfigAddMultiBit #(.bitWidth(8), .approxWidth(N4)) add3(.A(sum1), .B(sum2), .Sum(out));
    
endmodule