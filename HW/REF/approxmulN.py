import os
from sys import argv
import random

from helperfunctions import *
from approxadd1 import *
from approxaddN import *
from approxmul2 import *

test_vec_size = 100
width = 16 # 2 4 8 16
n16 = 13
n8 = 14
n4 = 3
path = 'approxmulN_data.txt'

'''
4 or 5 arguments must be given when launching the script: 
test vector size, N16, N8 and N4 and optionally a filename modifier; 
argv[0] is reserved
''' 

if len(argv) == 6: 
    test_vec_size = int(argv[1])
    width = int(argv[2])
    n16 = int(argv[3])
    n8 = int(argv[4])
    n4 = int(argv[5])
    print("Input parameters received\n")

if len(argv) == 7:
    test_vec_size = int(argv[1])
    width = int(argv[2])
    n16 = int(argv[3])
    n8 = int(argv[4])
    n4 = int(argv[5])
    path = argv[6]
    print("Input parameters and filename received\n")


N_ = {16: n16, 8: n8, 4: n4}

def approxmulN(a:int, b:int, N:int, N_: dict):
    if N % 2 != 0:
        raise ValueError("N is odd, this shouldn't happen")
    if a.bit_length()>N or b.bit_length()>N:
            print("\n here\n")
            print(a, b)
            raise ValueError("Values too long!")
    a0, a1 = split_bits(a, int(N/2))
    b0, b1 = split_bits(b, int(N/2))
    if N == 2:
        
        return approxmul2(a0, a1, b0, b1)
    
    HH = approxmulN(a1, b1, int(N/2), N_)
    HH = HH << int(N)

    HL = approxmulN(a1, b0, int(N/2), N_)
    HL = HL << int(N/2)

    LH = approxmulN(a0, b1, int(N/2), N_)
    LH = LH << int(N/2)

    LL = approxmulN(a0, b0, int(N/2), N_)
    LL = LL

    LL_LH = limitlen(approxaddN(LL, LH, N_[N]), 2*N)
    HL_HH = limitlen(approxaddN(HL, HH, N_[N]), 2*N)
    result = limitlen(approxaddN(LL_LH, HL_HH, N_[N]), 2*N)
    return limitlen(result, 32)

if __name__ == "__main__":
    # Generate the random input vectors
    in1, in2 = generate_input_vectors(test_vec_size, width)

    with open(path, 'w') as file:
        # Write header lines
        file.write(f'// Random testvectors for a {width}-bit approx multiplier\n')
        file.write(f'// with N16={n16}, N8={n8}, N4={n4}\n')
        file.write('// Format: a_b_result\n')

        # Calculate the result and write the data to the output file
        for i in range(test_vec_size):
            result = approxmulN(in1[i], in2[i], width, N_)
            data = f'{in1[i]:0{width}b}_{in2[i]:0{width}b}_{result:0{2*width}b}\n'
            file.write(data)


