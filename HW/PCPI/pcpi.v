/*
 * Custom RISCV instruction for approximate multiplication
 *
 * Copyright (C) 2024  Samir Hodzic, Veronica Kimelman, Paul Pölzl
 *
 * Permission to use, copy, modify, and/or distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 */

module pcpi(
    // PCPI Interface
    input clk, resetn, pcpi_valid,
    input [31:0] pcpi_insn,
    input [31:0] pcpi_rs1, pcpi_rs2,
    
    // CHANGED: Outputs are now wires for combinational routing
    output wire pcpi_wr,
    output wire [31:0] pcpi_rd,
    output wire pcpi_wait, pcpi_ready,
    
    // Approx multiplier interface
    input [31:0] res,
    output wire [15:0] a, b // CHANGED: Wires instead of regs
);

parameter MUL16 = 7'b0101011;   // opcode of the MUL16 instruction

wire [6:0] opcode;
assign opcode = pcpi_insn[6:0];

// Flag to check if the current instruction is our custom multiplier
wire is_mul16 = (pcpi_valid && opcode == MUL16);

// -----------------------------------------------------------------------------
// 1-Cycle Combinational Logic
// -----------------------------------------------------------------------------

// Feed the CPU registers directly into the multiplier tree
assign a = pcpi_rs1[15:0];
assign b = pcpi_rs2[15:0];

// Feed the multiplier result directly back to the CPU
assign pcpi_rd = res;

// Assert 'write' and 'ready' immediately on the exact cycle the instruction is seen
assign pcpi_wr    = is_mul16;
assign pcpi_ready = is_mul16;

// No wait states needed since it computes in 1 cycle
assign pcpi_wait  = 1'b0;

endmodule
