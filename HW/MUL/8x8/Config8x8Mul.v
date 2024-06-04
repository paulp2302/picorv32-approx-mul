// Approx8x8MulV3
// Implementation of a multiplier tree to approximate a 8x8 multiplication 
// uses: Approx4x4MulV1.v and ApproxAddMultiBit.v

module Config8x8Mul(a, b, out);
    parameter [4:0] N8 = 0;
    parameter [3:0] N4 = 0;

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

    Config4x4Mul #(.N4(N4)) lxl(.a (a[3:0]), .b (b[3:0]), .out (ll[7:0]));
    Config4x4Mul #(.N4(N4)) lxh(.a (a[3:0]), .b (b[7:4]), .out (lh[11:4]));
    Config4x4Mul #(.N4(N4)) hxl(.a (a[7:4]), .b (b[3:0]), .out (hl[11:4]));
    Config4x4Mul #(.N4(N4)) hxh(.a (a[7:4]), .b (b[7:4]), .out (hh[15:8]));

    ConfigAddMultiBit #(.bitWidth(16), .approxWidth(N8)) add1 (.A(ll), .B(lh), .Sum(sum1));
    ConfigAddMultiBit #(.bitWidth(16), .approxWidth(N8)) add2(.A(hl), .B(hh), .Sum(sum2));
    ConfigAddMultiBit #(.bitWidth(16), .approxWidth(N8)) add3(.A(sum1), .B(sum2), .Sum(out));
    
endmodule