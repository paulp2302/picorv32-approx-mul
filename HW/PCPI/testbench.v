// Universal testbench for the 2x2 multipliers 

`timescale 100ps/10ps // Unit of time is 100ps

`ifndef VCD_FILE
`define VCD_FILE "pcpi.vcd"
`endif

module pcpi_tb;

    
    // Input of DuT
    reg[31:0] pcpi_rs1, pcpi_rs2, pcpi_insn = {32{1'b0}};
    reg pcpi_valid, clk, resetn;     
    
     // Output of DuT
    wire [31:0] pcpi_rd;
    wire pcpi_wait, pcpi_ready, pcpi_wr;
    wire [3:0] state;

    


    // Instantiate the design under test:
    
    pcpi pcpi_dut(.clk(clk),
                  .resetn(resetn),
                  .pcpi_valid(pcpi_valid),
                  .pcpi_insn(pcpi_insn),
                  .pcpi_rs1(pcpi_rs1),
                  .pcpi_rs2(pcpi_rs2),
                  .pcpi_wr(pcpi_wr),
                  .pcpi_rd(pcpi_rd),
                  .pcpi_wait(pcpi_wait),
                  .pcpi_ready(pcpi_ready),
                  .state(state));

    // Generate clock
    always // no sensitivity list
        begin
            clk=1; #5;
            clk=0; #5; // 5ns period
        end
    
    initial begin
        resetn = 1;
        #100;
        resetn = 0;
        #10;
        resetn = 1;
    end
    
    initial begin
        $dumpfile(`VCD_FILE); // File with simulation resuls
        $dumpvars(0, pcpi_tb); // Select which variables are written to file 
    end

    // Stimuli generation:
    // apply test vectors on rising edge of clk
    always @(posedge clk)
        begin
            if (resetn) begin
            // IDLE
            #1; pcpi_valid <= 1;
            //#100; pcpi_valid <= 0;
            end
            #100; $finish;
        end

    // Responsechecker:
    // check results on falling edge of clk
   /* always @(negedge clk)
        if (~reset) // skip during reset
            begin
            if (out !== out_exp)
                begin
                    $display("Error: inputs = %b", {a, b});
                    $display(" outputs = %b (%b exp)", out, out_exp);
                    errors = errors + 1;
                end

            // increment array index and read th next testvector
            vectornum = vectornum + 1;
            if (testvectors[vectornum] === 8'bx)
                begin
                    $display("%d tests completed with %d errors", vectornum, errors);
                    $finish;    // End simulation
                end
            end*/
endmodule
