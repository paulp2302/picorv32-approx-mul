// Top module for STA
module top(
    input clk, resetn, pcpi_valid,
    input [31:0] pcpi_insn,
    input [31:0] pcpi_rs1, pcpi_rs2,
    output reg pcpi_wr,
    output reg [31:0] pcpi_rd,
    output reg pcpi_wait, pcpi_ready,
    output reg [31:0] out
);

//wire [31:0] pcpi_rs1, pcpi_rs2;
//reg pcpi_valid;
//wire pcpi_wr, pcpi_wait, pcpi_ready;
//reg [31:0] pcpi_insn, pcpi_rd;
wire [15:0] a, b;
wire [31:0] product;

//assign pcpi_rs1[15:0] = a;
//assign pcpi_rs2[15:0] = b;

always @ (posedge clk) begin
        out <= pcpi_rd[31:0];
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
        .pcpi_rs1(pcpi_rs2),
        .pcpi_wr(pcpi_wr),
        .pcpi_rd(pcpi_rd),
        .pcpi_wait(pcpi_wait),
        .pcpi_ready(pcpi_ready),
        .a(a),
        .b(b),
        .res(product));
endmodule