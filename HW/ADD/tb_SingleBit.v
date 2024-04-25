`timescale 1ns/1ns

module AccurateAddOneBit_tb;

    reg A;
    reg B;
    reg Cin;
    wire Cout;
    wire Sum;
    
    reg Sum_expct;
    reg Cout_expct;

    // Instantiate the Unit Under Test (UUT)
    AccurateAddOneBit uut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Cout(Cout),
        .Sum(Sum)
    );

    reg clk, reset; // clock and reset are internal
    reg[31:0] vectornum, errors; // bookkeeping variables
    reg[4:0] testvectors [7:0]; // array of testvectors

    // generate clock
    always // no sensitivity list
        begin
            clk = 1; #5;
            clk = 0; #5; // 1ns period
        end

    initial
        begin
            $dumpfile("adder.vcd"); // File with simulation results
            $dumpvars(0,AccurateAddOneBit_tb); // which variables are written to file
            $readmemb("tv_AccurateAddOneBit.tv", testvectors); // Read vectors
            vectornum = 0; errors = 0; // Initialize
            // Init
            A = 0;
            B = 0;
            Cin = 0;
            Sum_expct = 0;
            Cout_expct = 0;
            
            reset = 1;
            #10; reset = 0; // Apply reset wait
        end

    // Stimuli generation:
    // apply test vectors on rising edge of clk
    always @(posedge clk)
        begin
            #1; {A,B,Cin,Sum_expct,Cout_expct} = testvectors[vectornum]; // Apply inputs
        end

    // Response checker:
    // check results on falling edge of clk
    always @(negedge clk)
        if (~reset) // skip during reset
            begin
                if (Sum !== Sum_expct || Cout !== Cout_expct) // Check outputs
                    begin
                        $display("Error: inputs = %b", {A,B,Cin});
                        $display(" outputs = %b (%b exp)", {Sum,Cout}, {Sum_expct,Cout_expct});
                        errors = errors + 1;
                    end

                // increment array index and read next testvector
                vectornum = vectornum + 1;
                if (testvectors[vectornum] ===5'bx)
                    begin
                        $display("%d tests completed with %d errors", vectornum, errors);
                        $finish; // End simulation
                    end
            end
endmodule


/*
`timescale 1ns/1ns

module tb_SingleBit;
    reg A, B, Cin;
    wire Sum, Cout;
    
    AccurateAddOneBit uut (.A(A), .B(B), .Cin(Cin), .Sum(Sum), .Cout(Cout));
    
    initial begin
        $dumpfile("adder.vcd");
        $dumpvars(0, tb_SingleBit);

        // Init
        A = 0;
        B = 0;
        Cin = 0;

        #10 A=1'b0; B=1'b0; Cin=1'b0;
        #10 A=1'b0; B=1'b0; Cin=1'b1;

        #10 A=1'b0; B=1'b1; Cin=1'b0;
        #10 A=1'b0; B=1'b1; Cin=1'b1;
        
        #10 A=1'b1; B=1'b0; Cin=1'b0;
        #10 A=1'b1; B=1'b0; Cin=1'b1;
        
        #10 A=1'b1; B=1'b1; Cin=1'b0;
        #10 A=1'b1; B=1'b1; Cin=1'b1;
        
        #10 $finish;
    end
endmodule
*/