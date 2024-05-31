module pcpi(
    input clk, resetn, pcpi_valid,
    input [31:0] pcpi_insn,
    input [31:0] pcpi_rs1, pcpi_rs2,
    output reg pcpi_wr,
    output reg [31:0] pcpi_rd,
    output reg pcpi_wait, pcpi_ready,
);

Config16x16Mul multiplier(.a (a), .b (a), .out (mul_out));

parameter SIZE = 4;
parameter MUL16 = 7'b0101011;
parameter IDLE = 3'b001, DECODE = 3'b010, EXECUTE = 3'b011, DONE = 3'b100;

// Internal declarations
reg [SIZE-1:0] state; 
reg [SIZE-1:0] next_state;
reg [15:0] a,b;
wire [6:0] opcode;

assign opcode = pcpi_insn[6:0];

// Declarations for MUL module
wire [31:0] mul_out;
//wire mul_start, mul_finish; // Keep this if we don't make STA
//reg[15:0] prev_rs1, prev_rs2, prev_out;

// Temporarly assignments, until Mul module is done
//assign mul_finish = 1; 


// FSM Sequence
always @ (posedge clk) begin
    if (!resetn || !pcpi_valid)
        state <= IDLE;
    else 
        state <= next_state;
end

// Next State Logic
always @ (state or pcpi_valid) begin
    next_state = 3'b000;
    case(state) 
        IDLE:    if (pcpi_valid)
                    next_state = DECODE;
        DECODE:  if (opcode == MUL16)
                    next_state = DONE;
        EXECUTE: if (mul_finish)        // Keep this state if we don't pass STA, otherwise remove
                    next_state = DONE;
                 else
                    next_state = EXECUTE;
        DONE: next_state = IDLE;
        default: next_state = IDLE;
    endcase
end

// Output Logic
always @ (state) begin
    pcpi_wr <= 0;
    pcpi_ready <= 0;
    pcpi_wait <= 0; // Remove this if we make STA, then we can have this set to 0 always
    case(state)
        IDLE: pcpi_ready <= 0;  
        DECODE: begin
                a <= pcpi_rs1[15:0];
                b <= pcpi_rs2[15:0];
        end
        EXECUTE,  
        DONE: begin
                pcpi_wr <= 1;
                pcpi_ready <= 1;
                pcpi_rd <= mul_out;
        end
    endcase
end



endmodule