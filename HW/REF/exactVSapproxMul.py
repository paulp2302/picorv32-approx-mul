import os
from sys import argv
import random
import numpy as np

from helperfunctions import *
from approxadd1 import *
from approxaddN import *
from approxmul2 import *
from approxmulN import *

test_vec_size = 100
width = 16 # 2 4 8 16
n16 = 13
n8 = 14
n4 = 3

if len(argv) == 6:
    test_vec_size = int(argv[1])
    width = int(argv[2])
    n16 = int(argv[3])
    n8 = int(argv[4])
    n4 = int(argv[5])
    print("Input parameters received\n")

N_ = {16: n16, 8: n8, 4: n4}

def calculate_relative_error(approx_result, exact_result):
    if (exact_result == 0):
        #return abs(approx_result)
        return 0
    return abs(approx_result - exact_result) / exact_result

def exactVSapproxMul():
    in1, in2 = generate_input_vectors(test_vec_size, width)

    errors = []
    for i in range(test_vec_size):
        # approximate multiplication
        approx_result = approxmulN(in1[i], in2[i], width)
        
        # exact multiplication
        exact_result = in1[i] * in2[i]
        
        # relative error
        error = calculate_relative_error(approx_result, exact_result)
        errors.append(error)
    
    # average relative error
    avg_error = np.mean(errors)
    print(f'Average relative error for N={width} is {avg_error}')

if __name__ == "__main__":
    exactVSapproxMul()
