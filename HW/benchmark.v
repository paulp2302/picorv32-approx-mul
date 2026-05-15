/*
 *  Custom wrapper for timing and resource analysis of the standalone
 *  RISCV approximate multiplication instruction.
 *
 *  - The 97-bit shift register prevents Yosys from deleting the multiplier
 *  logic.
 *  - The XOR assignment of the output pin compresses all output pins
 *  preventing the physical I/O limit of the iCE40UP5k package.    
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

module benchmark_wrapper #(
    parameter N16 = 0,
    parameter N8 = 0,
    parameter N4 = 0
)(
    input clk, resetn,
    input data_in,
    output reg out_pin
);

    reg [96:0] shift_reg;
    wire wr, p_wait, ready;
    wire [31:0] rd;

    always @(posedge clk) begin
        shift_reg <= {shift_reg[95:0], data_in};
        out_pin <= ^rd ^ wr ^ p_wait ^ ready;
    end

    custom_mul #(
        .N16(N16),
        .N8(N8),
        .N4(N4)
    ) mul (
        .clk(clk),
        .resetn(resetn),
        .pcpi_valid(shift_reg[0]),
        .pcpi_insn(shift_reg[32:1]),
        .pcpi_rs1(shift_reg[64:33]),
        .pcpi_rs2(shift_reg[96:65]),
        .pcpi_wr(wr),
        .pcpi_rd(rd),
        .pcpi_wait(p_wait),
        .pcpi_ready(ready)
    );

endmodule
