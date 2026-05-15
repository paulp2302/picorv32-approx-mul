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

// Configurable Multiple Bit Adder Implementation
module ConfigAddMultiBit (A, B, Sum);
    parameter [5:0] bitWidth = 32;
    parameter [5:0] approxWidth = 0; 

    input  wire [bitWidth-1:0] A;
    input  wire [bitWidth-1:0] B;
    output wire [bitWidth-1:0] Sum;

    wire [approxWidth:0] c_internal; // internal carry
    wire [bitWidth-1:0] accurateRes;
    wire [approxWidth-1:0] approxRes;

    // C_in is always zero in our implementation
    assign c_internal[0] = 0;

    // Calculate the accurate part of the addition
    assign accurateRes = ((A >> approxWidth) + (B >> approxWidth)) << approxWidth;

    // Calculate the total sum from the accurate and appoximate result
    // The overflow of the approximate adder C_out also needs to be considered
    assign Sum = (approxWidth == 0) ? accurateRes 
                    : accurateRes + approxRes + (c_internal[approxWidth] << approxWidth);

    // Generate multiple instances of the appoximate One-Bit adder to 
    // create an approximate multiBit adder for approxWidth bits
    genvar j;
    generate
        // create multiple instances (each ApproxAddOneBit instance performs the addition for one bit position)
        for (j = 0; j < approxWidth; j = j + 1) begin : approx_adders
        // carry output from one bit is fed as the carry input to the next bit
        ApproxAddOneBit ApproxAddOneBit_Inst (.A(A[j]), .B(B[j]), .Sum(approxRes[j]), .Cin(c_internal[j]), .Cout(c_internal[j+1]));
        end
    endgenerate
    
endmodule