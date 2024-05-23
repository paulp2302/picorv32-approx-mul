#include "custom_inst.h"

// Custom Instruction for Appoximate multiplication
uint32_t mul16(uint16_t a, uint16_t b) {

    /* 
       For RISC-V R Type instructions:
       .insn r opcode6, func3, func7, rd, rs1, rs2 
       
       +-------+-----+-----+-------+----+---------+
       | func7 | rs2 | rs1 | func3 | rd | opcode6 |
       +-------+-----+-----+-------+----+---------+
       31      25    20    15      12   7        0
    */

    uint32_t result;
    __asm__ (".insn r 0xB, 0x0, 0x1, %0, %1, %2"
            : "=r" (result) 
            : "r" (a), "r" (b));
    return result;
} 