`include "Parametros.v"

module reg_EX_MEM (
    input wire clk,
    input wire reset,

    // ex
    input wire [31:0] alu_result_in,
    input wire [31:0] read_data2_in,
    input wire [4:0] rd_in,
    input wire alu_zero_in,

    // controle
    input wire MemRead_in,
    input wire MemWrite_in,
    input wire Branch_in,
    input wire RegWrite_in,
    input wire MemToReg_in,

    // mem
    output reg [31:0] alu_result_out,
    output reg [31:0] read_data2_out,
    output reg [4:0] rd_out,
    output reg alu_zero_out,

    output reg MemRead_out,
    output reg MemWrite_out,
    output reg Branch_out,
    output reg RegWrite_out,
    output reg MemToReg_out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            alu_result_out <= 32'b0;
            read_data2_out <= 32'b0;
            rd_out <= 5'b0;
            alu_zero_out <= 1'b0;
            MemRead_out <= 1'b0;
            MemWrite_out <= 1'b0;
            Branch_out <= 1'b0;
            RegWrite_out <= 1'b0;
            MemToReg_out <= 1'b0;
        end else begin
            alu_result_out <= alu_result_in;
            read_data2_out <= read_data2_in;
            rd_out <= rd_in;
            alu_zero_out <= alu_zero_in;
            MemRead_out <= MemRead_in;
            MemWrite_out <= MemWrite_in;
            Branch_out <= Branch_in;
            RegWrite_out <= RegWrite_in;
            MemToReg_out <= MemToReg_in;
        end
    end

endmodule
