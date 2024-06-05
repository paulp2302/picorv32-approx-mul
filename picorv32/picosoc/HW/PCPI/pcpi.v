module pcpi(
    // PCPI Interface
    input clk, resetn, pcpi_valid,
    input [31:0] pcpi_insn,
    input [31:0] pcpi_rs1, pcpi_rs2,
    output reg pcpi_wr,
    output reg [31:0] pcpi_rd,
    output reg pcpi_wait, pcpi_ready,
    
    // Approx multiplier interface
    input [31:0] res,
    output reg [15:0] a, b
);

parameter SIZE = 2;
parameter MUL16 = 7'b0101011;
// We need an additional state after EXECUTE to be able to retrieve
// the result from the multiplier
parameter IDLE = 2'b01, EXECUTE = 2'b10, DONE = 2'b11;

// Internal declarations
reg [SIZE-1:0] state; 
reg [SIZE-1:0] next_state;
//reg [15:0] a,b;
wire [6:0] opcode;


assign opcode = pcpi_insn[6:0];

// FSM Sequence
always @ (posedge clk) begin
    if (!resetn || !pcpi_valid)
        state <= IDLE;
    else 
        state <= next_state;
end

// Next State Logic
always @ (state or pcpi_valid) begin
    next_state = 2'b00;
    case(state) 
        IDLE:    if (pcpi_valid && opcode == MUL16)
                    next_state = EXECUTE;
                else
                    next_state = IDLE;
        EXECUTE:   next_state = DONE;
        DONE:     next_state = IDLE;
        default: next_state = IDLE;
    endcase
end

// Output Logic
always @ (state) begin
    pcpi_wr <= 0;
    pcpi_ready <= 0;
    pcpi_wait <= 0; // Remove this if we make STA, then we can have this set to 0 always
    if (state == EXECUTE)
      begin
                a <= pcpi_rs1[15:0];
                b <= pcpi_rs2[15:0];
                
                
      end 
    else if (state == DONE)
        begin
            pcpi_wr <= 1; 
                pcpi_ready <= 1; // Fix tb to adapt to these two signals, wrt test_vector
        pcpi_rd <= res;
end
end



endmodule