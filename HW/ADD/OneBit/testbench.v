// This is free and unencumbered software released into the public domain.
//
// Anyone is free to copy, modify, publish, use, compile, sell, or
// distribute this software, either in source code form or as a compiled
// binary, for any purpose, commercial or non-commercial, and by any
// means.

`timescale 1ns/1ns

`ifndef TEST_MODE
`define TEST_MODE 0
`endif 

`define ACC_TEST_VECTORS "tv_accurate.tv"
`define APPROX_TEST_VECTORS "tv_approx.tv"

`ifndef VCD_FILE
`define VCD_FILE "onebit.vcd"
`endif

module AddOneBit_tb;
    reg A;
    reg B;
    reg Cin;
    wire Cout;
    wire Sum;
    
    reg Sum_expct;
    reg Cout_expct;

    // Instantiate the Unit Under Test (UUT)
    generate
        if (`TEST_MODE == 0)
            AccurateAddOneBit uut (.A(A), .B(B), .Cin(Cin), .Cout(Cout), .Sum(Sum));
        else
            ApproxAddOneBit uut (.A(A), .B(B), .Cin(Cin), .Cout(Cout), .Sum(Sum));
    endgenerate

    reg clk, reset; // clock and reset are internal
    reg[31:0] vectornum, errors; // bookkeeping variables
    reg[4:0] testvectors [0:7]; // array of testvectors

    // generate clock
    always // no sensitivity list
        begin
            clk = 1; #5;
            clk = 0; #5; // 1ns period
        end

    initial
        begin
            $dumpfile(`VCD_FILE); // File with simulation resuls
            $dumpvars(0, AddOneBit_tb); // Select which variables are written to file
            if (`TEST_MODE == 0)
                $readmemb(`ACC_TEST_VECTORS, testvectors); // Readvectors
            else
                $readmemb(`APPROX_TEST_VECTORS, testvectors); // Readvectors
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
                if (testvectors[vectornum] === 5'bx)
                    begin
                        $display("%d tests completed with %d errors", vectornum, errors);
                        $finish; // End simulation
                    end
            end
endmodule
