/*
 *  Custom RISCV instruction for approximate multiplication
 *
 *  Copyright (C) 2024  Samir Hodzic, Veronica Kimelman, Paul Pölzl
 *
 *  Permission to use, copy, modify, and/or distribute this software for any
 *  purpose with or without fee is hereby granted, provided that the above
 *  copyright notice and this permission notice appear in all copies.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 *  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 *  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 *  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 *  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 *  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 *  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 */

// Approx16x16MulV4
// Implementation of a multiplier tree to approximate a 16x16 multiplication 
// uses: Approx8x8MulV1.v


module Config16x16Mul (a, b, out);
	parameter [5:0] N16 = 0;
    parameter [4:0] N8 = 0;
    parameter [3:0] N4 = 0;
	
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

    Config8x8Mul #(.N8(N8), .N4(N4)) lxl(.a (a[7:0]), .b (b[7:0]), .out (ll[15:0]));
    Config8x8Mul #(.N8(N8), .N4(N4)) lxh(.a (a[7:0]), .b (b[15:8]), .out (lh[23:8]));
    Config8x8Mul #(.N8(N8), .N4(N4)) hxl(.a (a[15:8]), .b (b[7:0]), .out (hl[23:8]));
    Config8x8Mul #(.N8(N8), .N4(N4)) hxh(.a (a[15:8]), .b (b[15:8]), .out (hh[31:16]));
    
    ConfigAddMultiBit #(.bitWidth(32), .approxWidth(N16)) add1 (.A(ll), .B(lh), .Sum(sum1));
    ConfigAddMultiBit #(.bitWidth(32), .approxWidth(N16)) add2 (.A(hl), .B(hh), .Sum(sum2));
    ConfigAddMultiBit #(.bitWidth(32), .approxWidth(N16)) add3 (.A(sum1), .B(sum2), .Sum(out));

endmodule