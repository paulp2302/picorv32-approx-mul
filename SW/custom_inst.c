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

#include "custom_inst.h"

// Custom Instruction for Appoximate multiplication
uint32_t mul16(uint32_t a, uint32_t b) {

    /* 
       For RISC-V R Type instructions:
       .insn r opcode6, func3, func7, rd, rs1, rs2 
       
       +-------+-----+-----+-------+----+---------+
       | func7 | rs2 | rs1 | func3 | rd | opcode6 |
       +-------+-----+-----+-------+----+---------+
       31      25    20    15      12   7        0
    */

    uint32_t result;
    __asm__ (".insn r 0x2B, 0x0, 0x0, %0, %1, %2"
            : "=r" (result) 
            : "r" (a), "r" (b));
    return result;
} 