`ifndef PARAM
    `include "Parametros.v"
`endif

// Unidade de controle para pipeline (EX, MEM, WB).
module ControlPipeline (
    input  wire [6:0] opcode,

    // Controle EX
    output reg        ALUSrc,
    output reg [1:0]  ALUOp,

    // Controle MEM
    output reg        MemRead,
    output reg        MemWrite,
    output reg        Branch,

    // Controle WB
    output reg        RegWrite,
    output reg        MemToReg,

    // Controle fluxo
    output reg        Jump, //são os jals
    output reg        JumpReg
);

always @(*) begin

    // Instruções
    ALUSrc   = 1'b0; ALUOp  = 2'b00;

    MemRead  = 1'b0; MemWrite = 1'b0;Branch   = 1'b0; 
    
    RegWrite = 1'b0;MemToReg = 1'b0; 
    
    Jump     = 1'b0;JumpReg  = 1'b0;

        case(opcode)
            OPC_RTYPE: begin // R-type: add, sub, and, or, slt
                RegWrite = 1'b1;
                ALUOp = 2'b10;      // Usa funct3/funct7
            end
            
            OPC_OPIMM: begin // I-type: addi
                RegWrite = 1'b1;
                ALUSrc = 1'b1;      // Usa imediato
                ALUOp = 2'b10;      // Usa funct3
            end
            
            OPC_LOAD: begin // LW
                RegWrite = 1'b1;
                MemRead = 1'b1;
                MemToReg = 1'b1;    // Dado vem da memória
                ALUSrc = 1'b1;      // Usa imediato (offset)
                ALUOp = 2'b00;      // Soma para calcular endereço
            end
            
            OPC_STORE: begin // SW
                MemWrite = 1'b1;
                ALUSrc = 1'b1;      // Usa imediato (offset)
                ALUOp = 2'b00;      // Soma para calcular endereço
            end
            
            OPC_BRANCH: begin // BEQ
                Branch = 1'b1;
                ALUOp = 2'b01;      // Subtração para comparar
            end
            
            OPC_JAL: begin // JAL
                RegWrite = 1'b1;    // Salva PC+4 em rd
                Jump = 1'b1;
            end
            
            OPC_JALR: begin // JALR
                RegWrite = 1'b1;    // Salva PC+4 em rd
                JumpReg = 1'b1;
                ALUSrc = 1'b1;      // Usa imediato
            end
            
            OPC_LUI: begin // LUI
                RegWrite = 1'b1;
                ALUSrc = 1'b1;      // Usa imediato
                ALUOp = 2'b11;      // Passa o imediato direto
            end
            
            default: begin
                // NOP - mantém valores padrão
            end
        endcase
end

endmodule
