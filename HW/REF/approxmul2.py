from helperfunctions import *
from sys import argv

path = 'approxmul2_data.txt'

'''
The path to the output file can optionally be given
as an input argument when launching ths script.
argv[0] is reserved
''' 

if len(argv) == 2:
    path = argv[1]
    print("Input filename received\n")

def approxmul2(a0:int, a1:int, b0:int, b1:int):
    # helper variables for the first AND gates
    a0b1 = a0 & b1
    a1b0 = a1 & b0
    a1b1 = a1 & b1

    # calculate the bits of the out signal
    out0 = a0b1 & a1b0
    out1 = a0b1 ^ a1b0
    out2 = out0 ^ a1b1
    out3 = a0b1 & a1b0

    # merge the single bits to the out signal
    out = 0
    out = set_bit(out, 0, out0)
    out = set_bit(out, 1, out1)
    out = set_bit(out, 2, out2)
    out = set_bit(out, 3, out3)
    return out

if __name__ == "__main__":
    with open(path, 'w') as file:
        file.write('// Truth table for a 2x2 approximate multiplier\n')
        file.write('// Format: a1 a0_b1 b0_out3 out2 out1 out0\n')
        for i in range(2**4): # generates truth table for 2 bit approx multiplier
            b1 = (i & 0b1000) >> 3
            b0 = (i & 0b0100) >> 2
            a1 = (i & 0b0010) >> 1
            a0 = i & 0b0001
            out = approxmul2(a0, a1, b0, b1)
            data = f'{a1:b}{a0:b}_{b1:b}{b0:b}_{out:04b}\n'
            file.write(data)