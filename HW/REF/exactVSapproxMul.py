import os
from sys import argv
import random
import numpy as np
import matplotlib.pyplot as plt

from helperfunctions import *
from approxadd1 import *
from approxaddN import *
from approxmul2 import *
from approxmulN import *

test_vec_size = 100000
width = 16 # 2 4 8 16
n16 = 16
n8 = 8
n4 = 0

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
    errors = np.zeros(test_vec_size)

    in1 = np.array(in1, dtype=int)
    in2 = np.array(in2, dtype=int)


    for i in range(test_vec_size):
        # approximate multiplication
        approx_result = approxmulN(int(in1[i]), int(in2[i]), width, N_)
        
        # exact multiplication
        exact_result = in1[i] * in2[i]
        
        # relative error
        error = calculate_relative_error(approx_result, exact_result)
        errors[i] = error
    
    exact_result = in1 * in2

    # average relative error
    #print(errors)
    #plt.plot(errors)
    #plt.scatter(in1*in2, errors)
    #plt.show()
    #print(np.sum(errors))
    avg_error = np.mean(errors)
    median_error = np.median(errors)
    max_error = np.max(errors)
    print(f'Average relative error for N={width} is {avg_error * 100}%')
    print(f'Median relative error for N={width} is {median_error * 100}%')
    print(f'Max relative error for N={width} is {max_error * 100}%')

if __name__ == "__main__":
    exactVSapproxMul()
