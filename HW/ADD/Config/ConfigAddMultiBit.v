// Configurable Multiple Bit Adder Implementation
module ConfigAddMultiBit (A, B, Sum);

    parameter bitWidth = 32;
    parameter approxWidth = 0; 

    input  wire [bitWidth-1:0] A;
    input  wire [bitWidth-1:0] B;
    output wire [bitWidth-1:0] Sum;

    wire [bitWidth:0] c_internal; // internal carry

    genvar j, k;
    generate
        // create multiple instances (each ApproxAddOneBit instance performs the addition for one bit position)
        for (j = 0; j < approxWidth; j = j + 1) begin : approx_adders
            // carry output from one bit is fed as the carry input to the next bit
            ApproxAddOneBit ApproxAddOneBit_Inst (.A(A[j]), .B(B[j]), .Sum(Sum[j]), .Cin(c_internal[j]), .Cout(c_internal[j+1]));
        end
        // create multiple instances (each AccurateAddOneBit instance performs the addition for one bit position)
        for (k = approxWidth; k < bitWidth; k = k + 1) begin : accurate_adders
        // carry output from one bit is fed as the carry input to the next bit
            AccurateAddOneBit AccurateAddOneBit_Inst (.A(A[k]), .B(B[k]), .Sum(Sum[k]), .Cin(c_internal[k]), .Cout(c_internal[k+1]));        
        end
    endgenerate

    assign c_internal[0] = 0;
endmodule