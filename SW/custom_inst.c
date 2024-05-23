#include "custom_inst.h"

// Custom Instruction for Appoximate multiplication
uint32_t mul16(uint16_t a, uint16_t b) {

    uint32_t result;
    __asm__ (".insn r 0xB, 0x0, 0x1, %0, %1, %2"
            : "=r" (result) 
            : "r" (a), "r" (b));
    return result;
} 