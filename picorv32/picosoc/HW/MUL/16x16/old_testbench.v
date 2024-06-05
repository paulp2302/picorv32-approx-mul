// Universal testbench for the 16x16 multipliers 

`timescale 100ps/10ps // Unit of time is 100ps

`ifndef TEST_MODE
`define TEST_MODE 0
`endif 

`define ACC_TEST_VECTORS "tv_config.tv"
`define APPROX_TEST_VECTORS "tv_approx.tv"

`ifndef VCD_FILE
`define VCD_FILE "mul16x16.vcd"
`endif

module mul16x16_tb;
    //parameter ACC_TEST_VECTORS = "tv_accurate.tv" 
    //parameter APPROX_TEST_VECTORS = "tv_approx.tv"

    reg[15:0] a, b;      // Input of DuT
    wire[31:0] out;       // Output of DuT
    reg[31:0] out_exp;   // Expected response

    reg clk, reset;                 // clock and reset are internal
    reg[31:0] vectornum, errors;    // bookkeeping variables
    reg[63:0] testvectors[0:99];      // array of testvectors

    // Instantiate the design under test:
    if (`TEST_MODE == 0)
        Config16x16Mul  mul(.a(a), .b(b), .out(out)); //
    else if (`TEST_MODE == 1)
        Approx16x16MulV1 mul(.a(a), .b(b), .out(out));
    else if (`TEST_MODE == 2)
        Approx16x16MulV2 mul(.a(a), .b(b), .out(out));
    else if (`TEST_MODE == 3)
        Approx16x16MulV3 mul(.a(a), .b(b), .out(out));
    else if (`TEST_MODE == 4)
        Approx16x16MulV4 mul(.a(a), .b(b), .out(out));
    else
        Approx16x16MulV5 mul(.a(a), .b(b), .out(out));

    // Generate clock
    always // no sensitivity list
        begin
            clk=1; #5;
            clk=0; #5; // 5ns period
        end
    
    initial begin
        $dumpfile(`VCD_FILE); // File with simulation resuls
        $dumpvars(0, mul16x16_tb); // Select which variables are written to file 
        if (`TEST_MODE == 0)
            $readmemb(`ACC_TEST_VECTORS, testvectors); // Readvectors
        else
            $readmemb(`APPROX_TEST_VECTORS, testvectors); // Readvectors
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
            if (testvectors[vectornum] === 64'bx)
                begin
                    $display("%d tests completed with %d errors", vectornum, errors);
                    $finish;    // End simulation
                end
            end
endmodule
