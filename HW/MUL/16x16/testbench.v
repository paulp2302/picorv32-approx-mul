// This is free and unencumbered software released into the public domain.
//
// Anyone is free to copy, modify, publish, use, compile, sell, or
// distribute this software, either in source code form or as a compiled
// binary, for any purpose, commercial or non-commercial, and by any
// means.

// Universal testbench for the 16x16 multipliers 

`timescale 100ps/10ps // Unit of time is 100ps

`ifndef TEST_MODE
`define TEST_MODE 0
`endif 

`ifndef TEST_VECTORS
`define TEST_VECTORS "tv_config.tv"
`endif 

`ifndef VCD_FILE
`define VCD_FILE "mul16x16.vcd"
`endif

`ifndef N16
`define N16 0
`endif

`ifndef N8
`define N8 0
`endif

`ifndef N4
`define N4 0
`endif

`ifndef NUM_TV
`define NUM_TV 1000
`endif

module mul16x16_tb;
    //parameter ACC_TEST_VECTORS = "tv_accurate.tv" 
    //parameter APPROX_TEST_VECTORS = "tv_approx.tv"

    reg[15:0] a, b;      // Input of DuT
    wire[31:0] out;       // Output of DuT
    reg[31:0] out_exp;   // Expected response

    reg clk, reset;                 // clock and reset are internal
    reg[31:0] vectornum, errors;    // bookkeeping variables
    reg[63:0] testvectors[0:`NUM_TV-1];      // array of testvectors

    // Instantiate the design under test:
    generate
        if (`TEST_MODE == 0)
            Config16x16Mul #(.N16(`N16), .N8(`N8), .N4(`N4)) mul(.a(a), .b(b), .out(out)); 
        else if (`TEST_MODE == 1)
            Config16x16Mul mul(.a(a), .b(b), .out(out));
    endgenerate

    // Generate clock
    always // no sensitivity list
        begin
            clk=1; #5;
            clk=0; #5; // 5ns period
        end
    
    initial begin
        $dumpfile(`VCD_FILE); // File with simulation resuls
        $dumpvars(0, mul16x16_tb); // Select which variables are written to file 
        $readmemb(`TEST_VECTORS, testvectors); // Readvectors
        vectornum = 0; errors = 0; // Initialize
        reset = 1;
        #27; reset = 0; // Apply reset wait
    end

    // Stimuli generation:
    // apply test vectors on rising edge of clk
    always @(posedge clk)
        begin
            #1; {a, b, out_exp} = testvectors[vectornum];
        end

    // Responsechecker:
    // check results on falling edge of clk
    always @(negedge clk)
        if (~reset) // skip during reset
            begin
            if (out !== out_exp)
                begin
                    $display("Error: inputs: A=%b, B=%b", a, b);
                    $display(" outputs = %b (%b exp)", out, out_exp);
                    errors = errors + 1;
                end

            // increment array index and read th next testvector
            vectornum = vectornum + 1;
            if (vectornum == `NUM_TV)
                begin
                    $display("========================================");
                    $display("Simulation finished: %d tests", vectornum);
                    $display("Functional errors: %d", errors);
                    if (errors > 0)
                        $fatal(1, "Simulation failed with %0d functional errors", errors);
                    $finish;    // End simulation
                end
            end
endmodule
