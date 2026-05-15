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