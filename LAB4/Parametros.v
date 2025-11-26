`ifndef PARAMETROS_V
`define PARAMETROS_V

// ===== Operações da ULA =====
`define ZERO       4'b0000
`define OPAND      4'b0001
`define OPOR       4'b0010
`define OPXOR      4'b0011
`define OPADD      4'b0100
`define OPSUB      4'b0101
`define OPSLT      4'b0110
`define OPSLTU     4'b0111
`define OPSLL      4'b1000
`define OPSRL      4'b1001
`define OPSRA      4'b1010
`define OPLUI      4'b1011
`define OPMUL      4'b1100
`define OPMULH     4'b1101
`define OPMULHU    4'b1110
`define OPMULHSU   4'b1111
`define OPDIV      4'b0000
`define OPDIVU     4'b0001
`define OPREM      4'b0010
`define OPREMU     4'b0011

// ===== Opcodes RISC-V =====
`define OPC_LOAD    7'b0000011
`define OPC_OPIMM   7'b0010011
`define OPC_AUIPC   7'b0010111
`define OPC_STORE   7'b0100011
`define OPC_RTYPE   7'b0110011
`define OPC_LUI     7'b0110111
`define OPC_BRANCH  7'b1100011
`define OPC_JALR    7'b1100111
`define OPC_JAL     7'b1101111

// ===== Funct3 =====
`define FUNC3_ADD   3'b000
`define FUNC3_SLL   3'b001
`define FUNC3_SLT   3'b010
`define FUNC3_SLTU  3'b011
`define FUNC3_XOR   3'b100
`define FUNC3_SRL   3'b101
`define FUNC3_OR    3'b110
`define FUNC3_AND   3'b111

// ===== Funct7 =====
`define FUNC7_ADD   7'b0000000
`define FUNC7_SUB   7'b0100000
`define FUNC7_SRL   7'b0000000
`define FUNC7_SRA   7'b0100000

// ===== Endereços de Memória =====
`define TEXT_ADDRESS    32'h00400000
`define DATA_ADDRESS    32'h10010000

// ===== Registradores Especiais =====
`define SP_INITIAL      32'h100103FC

// ===== Definir PARAM para evitar múltiplas inclusões =====
`define PARAM

`endif // PARAMETROS_V