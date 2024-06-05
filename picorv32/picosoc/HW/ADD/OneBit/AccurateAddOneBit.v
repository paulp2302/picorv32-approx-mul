// Accurate One Bit Adder Implementation
module AccurateAddOneBit (A, B, Cin, Cout, Sum);

    input  wire A;
    input  wire B;
    input  wire Cin;
    output wire Cout;
    output wire Sum;

    assign Sum  = (A ^ B) ^ Cin;
    assign Cout = (A & B) | ((A ^ B) & Cin);
    
endmodule