from helperfunctions import *
from sys import argv

path = 'approxadd1_data.txt'

'''
The path to the output file can optionally be given
as an input argument when launching ths script.
''' 

if len(argv) == 2:
    path = argv[1]
    print("Input filename received\n")

def approxadd1(a:int, b:int, cin:int):
    result  = ~b & ((~a) | (~cin))
    cout = ~result
    return limitlen(result, 1), limitlen(cout, 1)

if __name__ == "__main__": 
    with open(path, 'w') as file:
        file.write('// Truth table for the 1 bit approximate adder\n')
        file.write('// Format: a b cin_out cout\n')
        for i in range(2**3): # generates truth table for 1 bit approx adder
            cin = (i & 0b100) >> 2
            b = (i & 0b010) >> 1
            a = i & 0b001
            out, cout = approxadd1(a, b, cin)
            data = f'{a:b}{b:b}{cin:b}_{out:b}{cout:b}\n'
            file.write(data)
