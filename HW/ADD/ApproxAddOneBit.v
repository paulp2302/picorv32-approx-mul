module AccurateAddOneBit (A, B, Cin, Cout, Sum);

    input  wire A;
    input  wire B;
    input  wire Cin;
    output wire Cout;
    output wire Sum;

    assign Sum  = (not B) and ((not A) or (not Cin));
    assign Cout = not Sum;
    
endmodule