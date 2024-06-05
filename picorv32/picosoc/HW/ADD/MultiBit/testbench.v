`timescale 1ns/1ns


`ifndef TEST_MODE
`define TEST_MODE 0
`endif 

`define ACC_TEST_VECTORS "tv_accurate.tv"
`define APPROX_TEST_VECTORS "tv_approx.tv"

`ifndef VCD_FILE
`define VCD_FILE "multibit.vcd"
`endif

module AddMultiBit_tb;

    parameter bitWidth = 8;

    reg [bitWidth-1:0] A;
    reg [bitWidth-1:0] B;
    reg Cin;
    reg Sub;
    wire Cout;
    wire [bitWidth-1:0] Sum;
    
    reg [bitWidth-1:0] Sum_expct;
    reg Cout_expct;

    // Instantiate the Unit Under Test (UUT)
    if (`TEST_MODE == 0)
        AccurateAddMultiBit #(.bitWidth(bitWidth)) uut (.A(A), .B(B), .Cin(Cin), .Sub(Sub), .Cout(Cout), .Sum(Sum));
    else
        ApproxAddMultiBit #(.bitWidth(bitWidth)) uut (.A(A), .B(B), .Cin(Cin), .Sub(Sub), .Cout(Cout), .Sum(Sum));
    
    reg clk, reset; // clock and reset are internal
    reg[31:0] vectornum, errors; // bookkeeping variables
    reg[26:0] testvectors [0:9]; // array of testvectors

    // generate clock
    always // no sensitivity list
        begin
            clk = 1; #5;
            clk = 0; #5; // 1ns period
        end

    initial
        begin
            $dumpfile(`VCD_FILE); // File with simulation results
            $dumpvars(0, AddMultiBit_tb); // which variables are written to file
            if (`TEST_MODE == 0)
                $readmemb(`ACC_TEST_VECTORS, testvectors); // Read vectors
            else
                $readmemb(`APPROX_TEST_VECTORS, testvectors); // Read vectors
        
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
            #1; {A,B,Cin,Sub,Sum_expct,Cout_expct} = testvectors[vectornum]; // Apply inputs
        end

    // Response checker:
    // check results on falling edge of clk
    always @(negedge clk)
        if (~reset) // skip during reset
            begin
                if (Sum !== Sum_expct || Cout !== Cout_expct) // Check outputs
                    begin
                        $display("Error: inputs: A=%h, B=%h, Cin=%b, Sub=%b", {A}, {B}, {Cin}, {Sub});
                        $display(" outputs: Sum=%h, Cout=%b (Exp: Sum=%h, Cout=%b)", {Sum}, {Cout}, {Sum_expct}, {Cout_expct});
                        errors = errors + 1;
                    end

                // increment array index and read next testvector
                vectornum = vectornum + 1;
                if (testvectors[vectornum] ===27'bx)
                    begin
                        $display("%d tests completed with %d errors", vectornum, errors);
                        $finish; // End simulation
                    end
            end
endmodule
