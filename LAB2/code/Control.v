`ifndef PARAM
	`include "Parametros.v"
`endif

module Control (
    input  wire [6:0] opcode,
    output logic Branch,
    output logic MemRead,
    output logic MemtoReg,
    output logic [1:0] ALUOp,  
    output logic MemWrite,
    output logic ALUSrc,
    output logic RegWrite,
    output logic JAL,
    output logic JALR,
    output logic LUI
);

always @(*) begin
    Branch   = 1'b0;
    MemRead  = 1'b0;
    MemtoReg = 1'b0;
    ALUOp    = 2'b00; 
    MemWrite = 1'b0;
    ALUSrc   = 1'b0;
    RegWrite = 1'b0;
    JAL      = 1'b0;
    JALR     = 1'b0;
    LUI      = 1'b0;
    
    case (opcode)
        // Tipo-R (add, sub, and, or, slt)
        OPC_RTYPE: begin
            RegWrite = 1'b1;
            ALUSrc   = 1'b0; // ULA usa Dado2 (Registrador)
            ALUOp    = 2'b10; // ALUControl vai decodificar funct3/funct7
        end
        
        // Load (lw)
        OPC_LOAD: begin
            MemRead  = 1'b1;
            MemtoReg = 1'b1; // Dado da Memória vai para o registrador
            ALUSrc   = 1'b1; // ULA usa Imediato
            RegWrite = 1'b1;
            ALUOp    = 2'b00; // ALUControl vai mandar ULA SOMAR
        end
        
        // Store (sw)
        OPC_STORE: begin
            MemWrite = 1'b1;
            ALUSrc   = 1'b1; // ULA usa Imediato
            ALUOp    = 2'b00; // ALUControl vai mandar ULA SOMAR
        end
        
        // Branch (beq)
        OPC_BRANCH: begin
            Branch   = 1'b1;
            ALUSrc   = 1'b0; // ULA usa Dado2 (Registrador)
            ALUOp    = 2'b01; // ALUControl vai mandar ULA SUBTRAIR
        end
        
        // JAL (Jump and Link)
        OPC_JAL: begin
            JAL      = 1'b1;
            RegWrite = 1'b1;
            // ALUOp é 'não importa' (00)
            // ALUSrc é 'não importa' (0)
        end
        
        // JALR (Jump and Link Register)
        OPC_JALR: begin
            JALR     = 1'b1;
            RegWrite = 1'b1;
            ALUSrc   = 1'b1; // ULA usa Imediato
            ALUOp    = 2'b00; // ALUControl vai mandar ULA SOMAR
        end
        
        // I-Type (addi)
        OPC_OPIMM: begin
            RegWrite = 1'b1;
            ALUSrc   = 1'b1; // ULA usa Imediato
            ALUOp    = 2'b00; // addi é SOMA (igual lw/sw)
        end
        
        // LUI (Load Upper Immediate)
        OPC_LUI: begin
            LUI      = 1'b1;
            RegWrite = 1'b1;
            ALUSrc   = 1'b1; // ULA usa Imediato
            ALUOp    = 2'b11; // **CORRIGIDO**: Sinal especial para LUI
        end
        
        default: begin
        end
    endcase
end

endmodule
