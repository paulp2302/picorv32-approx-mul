// Universal testbench for the 2x2 multipliers 

`timescale 100ps/10ps // Unit of time is 100ps

`ifndef VCD_FILE
`define VCD_FILE "pcpi.vcd"
`endif

module top_tb;

    
    // Input of DuT
    reg[31:0] pcpi_rs1, pcpi_rs2, pcpi_insn = {32{1'b0}};
    reg pcpi_valid, clk, resetn;     
    
     // Output of DuT
    wire [31:0] pcpi_rd;
    wire pcpi_wait, pcpi_ready, pcpi_wr;
    reg [31:0] out_exp;

    reg[31:0] vectornum, errors;    // bookkeeping variables
    reg[97:0] testvectors[0:99];
    reg read_en;


    // Instantiate the design under test:
    
    top        dut(.clk(clk),
                  .resetn(resetn),
                  .pcpi_valid(pcpi_valid),
                  .pcpi_insn(pcpi_insn),
                  .pcpi_rs1(pcpi_rs1),
                  .pcpi_rs2(pcpi_rs2),
                  .pcpi_wr(pcpi_wr),
                  .pcpi_rd(pcpi_rd),
                  .pcpi_wait(pcpi_wait),
                  .pcpi_ready(pcpi_ready));

    // Generate clock
    always // no sensitivity list
        begin
            clk=1; #5;
            clk=0; #5; // 5ns period
        end
    
    
    
    initial begin
        $dumpfile(`VCD_FILE); // File with simulation resuls
        $dumpvars(0, top_tb); // Select which variables are written to file 
        $readmemb(`TEST_VECTORS, testvectors); // Readvectors
        vectornum = 0; errors = 0; // Initialize
        resetn = 1;
       // #50; resetn = 0; // Apply reset wait
    end

    initial begin
        pcpi_valid <= 0;
        pcpi_insn <= 32'b00000000001000001000000000101011;
        #5; pcpi_valid <= 1;
        #100; $finish;
        
    end
    // Stimuli generation:
    // apply test vectors on rising edge of clk
    always @(posedge clk)
        begin
            if (read_en) 
            #1; {pcpi_rs1, pcpi_rs2, out_exp} = testvectors[vectornum];  
        end

    always @(posedge clk) begin
        if (read_en) begin
        pcpi_valid = 1;
        #10; pcpi_valid = 0;
        end
    end

    always @(posedge clk) begin
        if(pcpi_ready) begin
            vectornum = vectornum + 1;
            read_en   = 1;
        end
        else
            read_en = 0;    
    end

    // Responsechecker:
    // check results on falling edge of clk
   /* always @(negedge clk) begin
        if (~resetn) // skip during reset
            begin
            if (pcpi_rd !== out_exp)  
                begin
                    $display("Error: inputs: A=%b, B=%b", pcpi_rs1, pcpi_rs2);
                    $display(" outputs = %b (%b exp)", pcpi_rd, out_exp);
                    errors = errors + 1;
                end

            // increment array index and read th next testvector
            
            if (testvectors[vectornum] === 96'bx)
                begin
                    $display("%d tests completed with %d errors", vectornum, errors);
                    $finish;    // End simulation
                end
            end
    end*/
            
endmodule
