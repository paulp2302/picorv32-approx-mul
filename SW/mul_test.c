#include "mul_test.h"
#include "custom_inst.h" // Needed for the mul16() function

void mul_test(uint32_t step_a, uint32_t step_b, uint8_t iterations) {
    uint32_t a = 0;
    uint32_t b = 0;
    uint32_t res = 0;
    uint32_t res_approx = 0;
    
    print("\n--- Starting Custom Approximate Multiplication Test ---\n\n");
    
    for (uint8_t i = 0; i < iterations; i++)
    {
        a = i * step_a;
        b = i * step_b;
        res = a * b;
        res_approx = mul16(a, b);
        
        print("A = ");
        print_dec(a);
        print("\n");
        
        print("B = ");
        print_dec(b);
        print("\n");

        print("Res = ");
        print_hex(res, 32);
        print("\n");

        print("Res (Approx)= ");
        print_hex(res_approx, 32);
        print("\n---\n");
    }
    print("Test Complete.\n");
}
