`include "Parametros.v"

module ALUControl (
    input  [1:0] ALUOp,
    input  [2:0] funct3,
    input  [6:0] funct7,
    output logic [4:0] ALUControl
);

always @(*) begin
    case (ALUOp)
        2'b00: ALUControl = `OPADD;  // ALUOp = 00 -> SOMA (para lw, sw, addi, jalr)
        2'b01: ALUControl = `OPSUB;  // ALUOp = 01 -> SUBTRAÇÃO (para beq)
        2'b10: begin  // ALUOp = 10 -> Tipo-R (decodifica funct3/funct7)
            case (funct3)
                `FUNC3_ADD: begin
                    if (funct7 == `FUNC7_SUB)
                        ALUControl = `OPSUB;
                    else
                        ALUControl = `OPADD;
                end
                `FUNC3_AND: ALUControl = `OPAND;
                `FUNC3_OR:  ALUControl = `OPOR;
                `FUNC3_SLT: ALUControl = `OPSLT;
                default:    ALUControl = `ZERO;
            endcase
        end
        2'b11: ALUControl = `OPLUI;  // ALUOp = 11 -> LUI (passa o imediato pela ULA)
        default: ALUControl = `ZERO;
    endcase
end

endmodule
