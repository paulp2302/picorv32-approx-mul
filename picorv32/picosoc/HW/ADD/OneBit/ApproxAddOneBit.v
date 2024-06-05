// Team 5 -> ApproxAdd2 implementation
module ApproxAddOneBit (A, B, Cin, Cout, Sum);

    input  wire A;
    input  wire B;
    input  wire Cin;
    output wire Cout;
    output wire Sum;

    assign Sum  = (!B) & ((!A) | (!Cin));
    assign Cout = !Sum;
    
endmodule