import os
from sys import argv
import random

def generate_input_vectors(test_vec_size: int, bit_size: int):
    in1 = [random.randint(0, (2**bit_size)-1) for _ in range(test_vec_size)]
    in2 = [random.randint(0, (2**bit_size)-1) for _ in range(test_vec_size)]
    return in1, in2

def set_bit(v, index, x): # set the bit of v at index to x
    mask = 1 << index
    v &= ~mask
    if x:
        v |= mask
    return v

def get_bit(v: int, N: int) -> int: # get the n-th bit of value v
    return (v >> N) & 1


def limitlen(v, len): # cuts off all bits after len
    mask = (1 << len) - 1
    return v & mask

def binary_array_to_int(arr): # converts a binary array into an int
    # if arr == []:
    #     return 0
    sum=0
    for i, bit in enumerate(arr):
        sum += bit * 2**i
    return sum
    # return int(''.join(map(str, arr)), 2)

def split_bits(value, n): # returns the n-least significant bits and the n more significant bits (1001, n=1 -> LSBs=1, MSBs=0)
    mask = (1 << n) - 1
    LSBs = value & mask
    MSBs = (value >> n) & mask
    return LSBs, MSBs