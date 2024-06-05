from helperfunctions import *
from approxadd1 import *
from sys import argv

test_vec_size = 100
width = 8
bits_approx = 4
path = 'approxaddN_data.txt'

'''
3 or 4 arguments must be given when launching the script: 
test vector size, width, number of bits to be approximated 
and optionally a custom output path; 
argv[0] is reserved
'''

if len(argv) == 4:
    test_vec_size = int(argv[1])
    width = int(argv[2])
    bits_approx = int(argv[3])
    print('Input parameters received\n')

if len(argv) == 5:
    test_vec_size = int(argv[1])
    width = int(argv[2])
    bits_approx = int(argv[3])
    path = argv[4]
    print('Input parameters and path received\n')

def approxaddN(a:int, b:int, N:int): 
    cin = [0] * (N+1)
    out = [0] * N
    cin[0] = 0
    for i in range(N):
        out[i], cin[i+1] = approxadd1(get_bit(a,i), get_bit(b,i), cin[i])
    approxRes = binary_array_to_int(out)
    sum = ((a >> N) << N) + ((b >> N) << N) + cin[N] * 2**N + approxRes
    return sum

if __name__ == "__main__":
    # Generate the random input vectors
    in1, in2 = generate_input_vectors(test_vec_size, width)
    cin, _ = generate_input_vectors(test_vec_size, 1)

    with open(path, 'w') as file:
        # Write header lines
        file.write(f'// Random testvectors for a {width}-bit adder with {bits_approx} approximated bits\n')
        file.write('// Format: a_b_result\n')

        # Calculate the result and write the data to the output file
        for i in range(test_vec_size):
            result = approxaddN(in1[i], in2[i], bits_approx)
            result = limitlen(result, width)
            data = f'{in1[i]:0{width}b}_{in2[i]:0{width}b}_{result:0{width}b}\n'
            file.write(data)
