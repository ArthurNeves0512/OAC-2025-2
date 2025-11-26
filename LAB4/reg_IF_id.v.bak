`ifndef PARAM
    `include "Parametros.v"
`endif

module reg_IF_ID (
    input wire clk,
    input wire reset,
    input wire stall,   // para o registrador
    input wire flush,   // limpa o registrador (p/ branches/jumps)
    
    // if
    input wire [31:0] instr_in,
    input wire [31:0] pc_plus_4_in,
    
    // id
    output reg [31:0] instr_out,
    output reg [31:0] pc_plus_4_out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            instr_out <= 32'b0;
            pc_plus_4_out <= 32'b0;
        end else if (flush) begin
            // flush: insere uma bolha (NOP)
            instr_out <= 32'b0;
            pc_plus_4_out <= 32'b0;
        end else if (!stall) begin
            // Atualiza se não houver stall
            instr_out <= instr_in;
            pc_plus_4_out <= pc_plus_4_in;
        end
        //else mante os valores
    end

endmodule