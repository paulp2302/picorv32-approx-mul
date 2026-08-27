import os
from sys import argv
import random
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.lines as mlines
import matplotlib.transforms as mtransforms

from helperfunctions import *
from approxadd1 import *
from approxaddN import *
from approxmul2 import *
from approxmulN import *


def exactVSapproxMul(test_vec_size, width, n16, n8, n4, plot_scatter=True):
    N_ = {16: n16, 8: n8, 4: n4}

    in1, in2 = generate_input_vectors(test_vec_size, width)
    approx_result = np.zeros(test_vec_size)

    in1 = np.array(in1, dtype=np.uint32)
    in2 = np.array(in2, dtype=np.uint32)

    for i in range(test_vec_size):
        # approximate multiplication
        approx_result[i] = approxmulN(int(in1[i]), int(in2[i]), width, N_)

    # Exact unsigned multiplication
    exact_result = in1 * in2

    # Calculate the relative error (prevent divide by zero)
    errors = np.abs(approx_result - exact_result)
    zero_idx = np.argwhere(exact_result == 0)
    errors[zero_idx] = 0
    exact_result[zero_idx] = 1
    errors /= exact_result

    # Calculate metrics
    avg_error = np.mean(errors)
    median_error = np.median(errors)
    max_error = np.max(errors)

    # Print the metrics over the testset
    print(f'Metrics for {test_vec_size} random testvectors run on {width}-bit multiplier with N16={n16}, N8={n8}, N4={n4}')
    print(f'Average relative error: {avg_error: >15.3%}')
    print(f'Median relative error:  {median_error: >15.3%}')
    print(f'Max relative error:     {max_error: >15.3%}')

    # Scatter plot between expected and approximated results
    if plot_scatter:

        output_dir = f"plots/width_{width}/{n16}_{n8}_{n4}"
        os.makedirs(output_dir, exist_ok=True)

        # Linear Scatter
        fig, ax = plt.subplots()
        line = mlines.Line2D([0,1], [0,1], color="red")
        plt.xlabel("Expected result")
        plt.ylabel("Approximated result")
        ax.scatter(exact_result, approx_result)
        transform = ax.transAxes
        line.set_transform(transform)
        ax.add_line(line)
        plt.savefig(os.path.join(output_dir, "scatter_linear.png"), dpi=300, bbox_inches='tight')
        plt.close()

        # Logarithmic
        fig, ax = plt.subplots()
        plt.xlabel("Expected result")
        plt.ylabel("Relative Error")
        ax.scatter(exact_result, errors)
        plt.yscale('log')  # Optionally use logarithmic scale for better visualization
        plt.savefig(os.path.join(output_dir, "scatter_log.png"), dpi=300, bbox_inches='tight')
        plt.close()

        # Histogramm
        plt.figure()
        plt.hist(errors, bins=50, log=True)  # Log scale for better visualization of distribution
        plt.xlabel("Relative Error")
        plt.ylabel("Frequency")
        plt.title("Histogram of Relative Errors")
        plt.savefig(os.path.join(output_dir, "error_histogram.png"), dpi=300, bbox_inches='tight')
        plt.close()

        print(f"Plots successfully saved to: {output_dir}/")

    return avg_error, median_error, max_error


if __name__ == "__main__":
    test_vec_size = 10000
    width = 16 # 2 4 8 16
    n16 = 25
    n8 = 8
    n4 = 0

    if len(argv) == 6:
        test_vec_size = int(argv[1])
        width = int(argv[2])
        n16 = int(argv[3])
        n8 = int(argv[4])
        n4 = int(argv[5])
        print("Input parameters received\n")

    exactVSapproxMul(test_vec_size, width, n16, n8, n4)
