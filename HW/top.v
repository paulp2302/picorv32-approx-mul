// Top module for STA
module custom_mul (
    input clk, resetn, pcpi_valid,
    input [31:0] pcpi_insn,
    input [31:0] pcpi_rs1, pcpi_rs2,
    output reg pcpi_wr,
    output reg [31:0] pcpi_rd,
    output reg pcpi_wait, pcpi_ready
);

// Inputs and outputs for the multiplier
wire [15:0] a, b;
wire [31:0] product;

// Internal wires for outputs
wire wr, p_wait, ready;
wire [31:0] rd;

always @ (posedge clk) begin
        pcpi_rd <= rd;
        pcpi_wr <= wr;
        pcpi_wait <= p_wait;
        pcpi_ready <= ready;
end

Config16x16Mul mul(
        .a(a),
        .b(b),
        .out(product));

pcpi dut(.clk(clk),
        .resetn(resetn),
        .pcpi_valid(pcpi_valid),
        .pcpi_insn(pcpi_insn),
        .pcpi_rs1(pcpi_rs1),
        .pcpi_rs2(pcpi_rs2),
        .pcpi_wr(wr),
        .pcpi_rd(rd),
        .pcpi_wait(p_wait),
        .pcpi_ready(ready),
        .a(a),
        .b(b),
        .res(product));
endmodule