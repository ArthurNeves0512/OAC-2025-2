`include "Parametros.v"

module TopDE (
    input wire CLOCK, 
    input wire Reset,
    input wire [4:0] Regin,
    output wire ClockDIV,
    output wire [31:0] PC,
    output wire [31:0] Instr,
    output wire [31:0] Regout,
    
    // ===== SINAIS DE DEBUG =====
    output wire [31:0] DEBUG_IF_ID_Instr,
    output wire [4:0] DEBUG_ID_EX_Rd,
    output wire DEBUG_ID_EX_RegWrite,
    output wire [4:0] DEBUG_EX_MEM_Rd,
    output wire DEBUG_EX_MEM_RegWrite,
    output wire [4:0] DEBUG_MEM_WB_Rd,
    output wire DEBUG_MEM_WB_RegWrite,
    output wire [31:0] DEBUG_WriteBack_Data,
    output wire DEBUG_stall,
    output wire DEBUG_IF_ID_flush,
    output wire DEBUG_ID_EX_flush,
    output wire DEBUG_should_jump,
    output wire DEBUG_branch_taken
);
    
    // clock cpu adaptado
    reg ClockDIV_reg;
    
    always @(posedge CLOCK or posedge Reset) begin
        if(Reset)
            ClockDIV_reg <= 1'b0;
        else
            ClockDIV_reg <= ~ClockDIV_reg;
    end
    
    assign ClockDIV = ClockDIV_reg;
    
    Pipeline PIP1 (
        .clockCPU(ClockDIV_reg), 
        .clockMem(CLOCK), 
        .reset(Reset), 
        .regin(Regin), 
        .PC(PC), 
        .Instr(Instr), 
        .regout(Regout),
        
        // Conectar sinais de debug
        .DEBUG_IF_ID_Instr(DEBUG_IF_ID_Instr),
        .DEBUG_ID_EX_Rd(DEBUG_ID_EX_Rd),
        .DEBUG_ID_EX_RegWrite(DEBUG_ID_EX_RegWrite),
        .DEBUG_EX_MEM_Rd(DEBUG_EX_MEM_Rd),
        .DEBUG_EX_MEM_RegWrite(DEBUG_EX_MEM_RegWrite),
        .DEBUG_MEM_WB_Rd(DEBUG_MEM_WB_Rd),
        .DEBUG_MEM_WB_RegWrite(DEBUG_MEM_WB_RegWrite),
        .DEBUG_WriteBack_Data(DEBUG_WriteBack_Data),
        .DEBUG_stall(DEBUG_stall),
        .DEBUG_IF_ID_flush(DEBUG_IF_ID_flush),
        .DEBUG_ID_EX_flush(DEBUG_ID_EX_flush),
        .DEBUG_should_jump(DEBUG_should_jump),
        .DEBUG_branch_taken(DEBUG_branch_taken)
    );
        
endmodule