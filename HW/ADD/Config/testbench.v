// This is free and unencumbered software released into the public domain.
//
// Anyone is free to copy, modify, publish, use, compile, sell, or
// distribute this software, either in source code form or as a compiled
// binary, for any purpose, commercial or non-commercial, and by any
// means.

`timescale 1ns/1ns

`ifndef TEST_VECTORS
`define TEST_VECTORS "tv_config.tv"
`endif

`ifndef VCD_FILE
`define VCD_FILE "ConfigAddMultiBit.vcd"
`endif

`ifndef WIDTH_ADD
`define WIDTH_ADD 8
`endif

`ifndef N_ADD
`define N_ADD 4
`endif

`ifndef NUM_TV
`define NUM_TV 1000
`endif

module ConfigAddMultiBit_tb;

    parameter bitWidth = `WIDTH_ADD;
    parameter approxWidth = `N_ADD;

    reg [bitWidth-1:0] A;
    reg [bitWidth-1:0] B;
    wire [bitWidth-1:0] Sum;
    
    reg [bitWidth-1:0] Sum_expct;

    // Instantiate the Unit Under Test (UUT)
    ConfigAddMultiBit #(.bitWidth(bitWidth), .approxWidth(approxWidth)) uut (.A(A), .B(B), .Sum(Sum));
    reg clk, reset; // clock and reset are internal
    reg[31:0] vectornum, errors; // bookkeeping variables
    reg[(3*bitWidth-1):0] testvectors [0:`NUM_TV-1]; // array of testvectors

    // generate clock
    always // no sensitivity list
        begin
            clk = 1; #5;
            clk = 0; #5; // 1ns period
        end

    initial
        begin
            $dumpfile(`VCD_FILE); // File with simulation results
            $dumpvars(0, ConfigAddMultiBit_tb); // which variables are written to file
            $readmemb(`TEST_VECTORS, testvectors); // Read vectors
        
            vectornum = 0; errors = 0; // Initialize
            // Init
            A = 0;
            B = 0;
            Sum_expct = 0;
            
            reset = 1;
            #10; reset = 0; // Apply reset wait
        end

    // Stimuli generation:
    // apply test vectors on rising edge of clk
    always @(posedge clk)
        begin
            #1; {A,B,Sum_expct} = testvectors[vectornum]; // Apply inputs
        end

    // Response checker:
    // check results on falling edge of clk
    always @(negedge clk)
        if (~reset) // skip during reset
            begin
                if (Sum !== Sum_expct) // Check outputs
                    begin
                        $display("%d: %h", {vectornum}, {testvectors[vectornum]});
                        $display("Error: inputs: A=%h, B=%h", {A}, {B});
                        $display(" outputs: Sum=%h (Exp: Sum=%h)", {Sum}, {Sum_expct});
                        errors = errors + 1;
                    end

                // increment array index and read next testvector
                vectornum = vectornum + 1;
                if (vectornum == `NUM_TV)
                    begin
                        $display("========================================");
                        $display("Simulation finished: %d tests", vectornum);
                        $display("Functional errors: %d", errors);
                        $finish;    // End simulation
                    end
                end
endmodule
