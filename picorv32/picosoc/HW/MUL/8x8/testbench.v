// Universal testbench for the 16x16 multipliers 

`timescale 100ps/10ps // Unit of time is 100ps

`ifndef TEST_MODE
`define TEST_MODE 0
`endif 

`ifndef TEST_VECTORS
`define TEST_VECTORS "tv_config.tv"
`endif 

`ifndef VCD_FILE
`define VCD_FILE "mul8x8.vcd"
`endif

`ifndef N8
`define N8 0
`endif

`ifndef N4
`define N4 0
`endif

module mul8x8_tb;
    //parameter ACC_TEST_VECTORS = "tv_accurate.tv" 
    //parameter APPROX_TEST_VECTORS = "tv_approx.tv"

    reg[7:0] a, b;      // Input of DuT
    wire[15:0] out;       // Output of DuT
    reg[15:0] out_exp;   // Expected response

    reg clk, reset;                 // clock and reset are internal
    reg[31:0] vectornum, errors;    // bookkeeping variables
    reg[31:0] testvectors[0:99];      // array of testvectors

    // Instantiate the design under test:
    if (`TEST_MODE == 0)
        Config8x8Mul #(.N8(`N8), .N4(`N4)) mul(.a(a), .b(b), .out(out)); 
    else if (`TEST_MODE == 1)
        Config8x8Mul mul(.a(a), .b(b), .out(out));
    
    // Generate clock
    always // no sensitivity list
        begin
            clk=1; #5;
            clk=0; #5; // 5ns period
        end
    
    initial begin
        $dumpfile(`VCD_FILE); // File with simulation resuls
        $dumpvars(0, mul8x8_tb); // Select which variables are written to file 
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
            if (testvectors[vectornum] === 32'bx)
                begin
                    $display("%d tests completed with %d errors", vectornum, errors);
                    $finish;    // End simulation
                end
            end
endmodule
