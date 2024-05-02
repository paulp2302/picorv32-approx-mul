// Accurate Multiple Bit Adder Implementation
module AccurateAddMultiBit (A, B, Cin, Sub, Sum, Cout);

    parameter bitWidth = 32;

    input  wire [bitWidth-1:0] A;
    input  wire [bitWidth-1:0] B;
    input  wire Cin;
    input  wire Sub; // '0' for adding, '1' for subtracting
    output wire [bitWidth-1:0] Sum;
    output wire Cout;

    reg [bitWidth-1:0] bIn; // true B signal, depending on whether you want to add or subtract
    reg [bitWidth:0] c_internal; // internal carry
    wire [bitWidth-1:0] bIn; // true B signal, depending on whether you want to add or subtract
    wire [bitWidth:0] c_internal; // internal carry

    // calculate bIn depending on whether it is an addition or subtraction
    always @(*) begin: init_block
        integer i;
        for (i = 0; i < bitWidth; i = i+1) begin
            bIn[i] <= B[i] ^ Sub; // if subtraction: flip it because subtracting a number is the same as adding its two’s complement
        end
    end

    // create multiple instances (each AccurateAddOneBit instance performs the addition for one bit position)
    genvar j;
    generate
        for (j = 0; j < bitWidth; j = j+1) begin : adders
            // carry output from one bit is fed as the carry input to the next bit
            AccurateAddOneBit AccurateAddOneBit_Instance (.A(A[j]), .B(bIn[j]), .Sum(Sum[j]), .Cin(c_internal[j]), .Cout(carry_internal[i+1]));
            //wire Cout_temp;
            //AccurateAddOneBit AccurateAddOneBit_Instance (.A(A[j]), .B(bIn[j]), .Sum(Sum[j]), .Cin(c_internal[j]), .Cout(Cout_temp));
            //assign carry_internal[i+1] = Cout_temp;
        end
    endgenerate

    assign c_internal[0] = Sub | Cin; // if Cin = '1' -> add operation or if Sub = '1' -> add operation (for two's complement)
    assign Cout = c_internal[bitWidth];

endmodule