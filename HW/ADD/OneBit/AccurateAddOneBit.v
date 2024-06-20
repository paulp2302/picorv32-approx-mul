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

// Accurate One Bit Adder Implementation
module AccurateAddOneBit (A, B, Cin, Cout, Sum);

    input  wire A;
    input  wire B;
    input  wire Cin;
    output wire Cout;
    output wire Sum;

    assign Sum  = (A ^ B) ^ Cin;
    assign Cout = (A & B) | ((A ^ B) & Cin);
    
endmodule