`timescale 1ns/1ns

module AddMultiBit_tb;

    parameter bitWidth = 32;

    reg [bitWidth-1:0] A;
    reg [bitWidth-1:0] B;
    reg Cin;
    reg Sub;
    wire Cout;
    wire [bitWidth-1:0] Sum;
    
    reg [bitWidth-1:0] Sum_expct;
    reg Cout_expct;

    // Instantiate the Unit Under Test (UUT)
    AccurateAddMultiBit uut (.A(A), .B(B), .Cin(Cin), .Sub(Sub), .Cout(Cout), .Sum(Sum));
    //ApproxAddMultiBit uut (.A(A), .B(B), .Cin(Cin), .Sub(Sub), .Cout(Cout), .Sum(Sum));

    reg clk, reset; // clock and reset are internal
    reg[31:0] vectornum, errors; // bookkeeping variables
    reg[98:0] testvectors [0:4]; // array of testvectors

    // generate clock
    always // no sensitivity list
        begin
            clk = 1; #5;
            clk = 0; #5; // 1ns period
        end

    initial
        begin
            $dumpfile("AddMultiBit.vcd"); // File with simulation results
            $dumpvars(0,AddMultiBit_tb); // which variables are written to file
            $readmemb("tv_AccurateAddMultiBit.tv", testvectors); // Read vectors
            //$readmemb("tv_ApproxAddMultiBit.tv", testvectors); // Read vectors
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
                        $display(" outputs: Sum=%h, Cout=%b (Exp: Sum=%h, Cou=%b)", {Sum}, {Cout}, {Sum_expct}, {Cout_expct});
                        errors = errors + 1;
                    end

                // increment array index and read next testvector
                vectornum = vectornum + 1;
                if (testvectors[vectornum] ===99'bx)
                    begin
                        $display("%d tests completed with %d errors", vectornum, errors);
                        $finish; // End simulation
                    end
            end
endmodule
