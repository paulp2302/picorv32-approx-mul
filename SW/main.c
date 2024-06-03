#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include "custom_inst.h"

uint32_t binaryToDecimal(char *binary) {
    return (uint32_t)strtol(binary, NULL, 2);
}

int main() {
    FILE *file = fopen("test_vectors.tv", "r");
    if (file == NULL) {
        printf("Could not open file test_vectors.tv");
        return 1;
    }

    char a_str[33], b_str[33], expected_str[33];
    uint32_t a, b, result, expected;
    // Size three for now, change later
    while (fscanf(file, "%32s_%32s_%32s", a_str, b_str, expected_str) == 3) {
        a = binaryToDecimal(a_str);
        b = binaryToDecimal(b_str);
        expected = binaryToDecimal(expected_str);
        result = mul16(a, b);
        printf("The result of %u * %u is %u (expected %u)\n", a, b, result, expected);
    }

    fclose(file);
    return 0;
};