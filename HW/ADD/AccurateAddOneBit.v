module AccurateAddOneBit (A, B, Cin, Cout, Sum);

    input  wire A;
    input  wire B;
    input  wire Cin;
    output wire Cout;
    output wire Sum;

    assign Sum  = (A xor B) xor Cin;
    assign Cout = (A and B) or ((A xor B) and Cin);
    
endmodule