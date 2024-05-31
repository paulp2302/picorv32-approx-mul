// Configurable Multiple Bit Adder Implementation
module ConfigAddMultiBit (A, B, Sum);

    parameter bitWidth = 32;
    parameter approxWidth = 0; 

    input  wire [bitWidth-1:0] A;
    input  wire [bitWidth-1:0] B;
    output wire [bitWidth-1:0] Sum;

    wire [approxWidth:0] c_internal; // internal carry
    wire [bitWidth-1:0] accurateRes;
    wire [approxWidth-1:0] approxRes;

    // C_in is always zero in our implementation
    assign c_internal[0] = 0;

    // Calculate the accurate part of the addition
    assign accurateRes[bitWidth-1:approxWidth] = A[bitWidth-1:approxWidth] + B[bitWidth-1:approxWidth];
    assign accurateRes[approxWidth-1:0] = 0;

    // Calculate the total sum from the accurate and appoximate result
    // The overflow of the approximate adder C_out also needs to be considered
    assign Sum = accurateRes + approxRes + (c_internal[approxWidth] << approxWidth);

    // Generate multiple instances of the appoximate One-Bit adder to 
    // create an approximate multiBit adder for approxWidth bits
    genvar j;
    generate
        // create multiple instances (each ApproxAddOneBit instance performs the addition for one bit position)
        for (j = 0; j < approxWidth; j = j + 1) begin : approx_adders
            // carry output from one bit is fed as the carry input to the next bit
            ApproxAddOneBit ApproxAddOneBit_Inst (.A(A[j]), .B(B[j]), .Sum(approxRes[j]), .Cin(c_internal[j]), .Cout(c_internal[j+1]));
        end
    endgenerate
    
endmodule