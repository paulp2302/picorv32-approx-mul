#ifndef MUL_TEST_H
#define MUL_TEST_H

#include <stdint.h>

extern void print(const char *p);
extern void print_hex(uint32_t v, int digits);
extern void print_dec(uint32_t v);

void mul_test(uint32_t step_a, uint32_t step_b, uint8_t iterations);

#endif // MUL_TEST_H
