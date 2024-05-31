// Top module for STA
module top(
    input clk, resetn
);


wire [31:0] pcpi_rs1, pcpi_rs2;
reg pcpi_valid;
wire pcpi_wr, pcpi_wait, pcpi_ready;
reg [31:0] pcpi_insn, pcpi_rd;






pcpi dut(.clk(clk),
        .resetn(resetn),
        .pcpi_valid(pcpi_valid),
        .pcpi_insn(pcpi_insn),
        .pcpi_rs1(pcpi_rs1),
        .pcpi_rs1(pcpi_rs2),
        .pcpi_wr(pcpi_wr),
        .pcpi_rd(pcpi_rd),
        .pcpi_wait(pcpi_wait),
        .pcpi_ready(pcpi_ready));
endmodule