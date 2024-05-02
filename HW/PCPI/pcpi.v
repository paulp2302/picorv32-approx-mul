module pcpi(
    input clk, resetn, pcpi_valid,
    input [31:0] pcpi_insn,
    input [31:0] pcpi_rs1, pcpi_rs2,
    output pcpi_wr,
    output [31:0] pcpi_rd,
    output pcpi_wait, pcpi_ready
);

parameter SIZE = 3;
parameter MUL16 = 7'b0000000;
parameter IDLE = 3'b001, DECODE = 3'b010, EXECUTE = 3'b011, DONE = 3'b100;

reg [SIZE-1:0] state;
wire [SIZE-1:0] next_state;
wire [6:0] opcode;
wire mul_finish, mul_waiting;

assign opcode = pcpi_insn[6:0];

// FSM Sequence
always @ (posedge clk) begin
    if (!resetn)
        state <= IDLE;
    else 
        state <= next_state;
end

// Next State Logic
always @ (state or pcpi_valid) begin
    next_state = 3'b000;
    case(state) 
        IDLE: if (pcpi_valid)
                next_state = DECODE;
        DECODE: if (opcode == MUL16)
                    next_state = EXECUTE;
        EXECUTE: if (mul_finish && resetn)
                    next_state = DONE;
        DONE: next_state = IDLE;
        default: next_state = IDLE;
    endcase
end

// Output Logic
always @ (state) begin
    case(state)
    IDLE:
    DECODE:
    EXECUTE:
    DONE: 
    endcase
end



endmodule