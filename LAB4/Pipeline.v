`include "Parametros.v"

module Pipeline (
    input wire clockCPU,
    input wire clockMem,
    input wire reset,
    input wire [4:0] regin,
    output wire [31:0] PC,
    output wire [31:0] Instr,
    output wire [31:0] regout
);

    //==========================================================================
    //  SINAIS INTERNOS - Organizados por estágio
    //==========================================================================
    
    //--- Estágio IF (Instruction Fetch) ---
    reg [31:0] PC_reg;
    reg [31:0] PC_next;  
    wire [31:0] PC_plus_4;
    wire [31:0] Instr_wire;
    
    //--- Registrador IF/ID ---
    wire [31:0] IF_ID_Instr, IF_ID_PC_plus_4;
    
    //--- Estágio ID (Instruction Decode) ---
    wire [31:0] ReadData1, ReadData2, ImmGen_out;
    wire ALUSrc_ID, MemRead_ID, MemWrite_ID, Branch_ID, RegWrite_ID, MemToReg_ID;
    wire [1:0] ALUOp_ID;
    wire Jump_ID, JumpReg_ID;
    wire [31:0] branch_target_ID;  // Calcula target já no ID
    
    //--- Registrador ID/EX ---
    wire [31:0] ID_EX_PC_plus_4, ID_EX_ReadData1, ID_EX_ReadData2, ID_EX_Imm;
    wire [4:0] ID_EX_Rs1, ID_EX_Rs2, ID_EX_Rd;
    wire ID_EX_ALUSrc, ID_EX_MemRead, ID_EX_MemWrite, ID_EX_Branch;
    wire ID_EX_RegWrite, ID_EX_MemToReg;
    wire [1:0] ID_EX_ALUOp;
    wire [2:0] ID_EX_funct3;  // ADICIONADO
    wire [6:0] ID_EX_funct7;  // ADICIONADO
    wire [31:0] ID_EX_branch_target;  // ADICIONADO
    
    //--- Estágio EX (Execute) ---
    wire [3:0] ALUControl;
    wire [31:0] ALU_operand_B, ALU_result;
    wire ALU_zero;
    
    //--- Registrador EX/MEM ---
    wire [31:0] EX_MEM_ALU_result, EX_MEM_ReadData2;
    wire [4:0] EX_MEM_Rd;
    wire EX_MEM_ALU_zero, EX_MEM_MemRead, EX_MEM_MemWrite;
    wire EX_MEM_Branch, EX_MEM_RegWrite, EX_MEM_MemToReg;
    wire [31:0] EX_MEM_branch_target;  // ADICIONADO
    
    //--- Estágio MEM (Memory Access) ---
    wire [31:0] Mem_ReadData;
    wire branch_taken;
    
    //--- Registrador MEM/WB ---
    wire [31:0] MEM_WB_MemData, MEM_WB_ALU_result;
    wire [4:0] MEM_WB_Rd;
    wire MEM_WB_RegWrite, MEM_WB_MemToReg;
    
    //--- Estágio WB (Write Back) ---
    wire [31:0] WriteBack_Data;
    
    //--- Hazard Detection Unit ---
    wire stall, IF_ID_flush, ID_EX_flush;
    
    //--- Controle de PC para Jump ---
    wire [31:0] jump_target_jal, jump_target_jalr;
    wire should_jump;

    //==========================================================================
    //  ATRIBUIÇÕES DE SAÍDA
    //==========================================================================
    assign PC = PC_reg;
    assign Instr = Instr_wire;

    //==========================================================================
    //  ESTÁGIO IF (Instruction Fetch)
    //==========================================================================
    
    assign PC_plus_4 = PC_reg + 4;

    // Cálculo de endereços de jump
    assign jump_target_jal = PC_reg + ImmGen_out;
    assign jump_target_jalr = ReadData1 + ImmGen_out;
    assign should_jump = Jump_ID || JumpReg_ID;
    
    // Lógica de seleção do próximo PC
    always @(*) begin
        if (branch_taken)
            PC_next = EX_MEM_branch_target;
        else if (Jump_ID)
            PC_next = jump_target_jal;
        else if (JumpReg_ID)
            PC_next = jump_target_jalr;
        else
            PC_next = PC_plus_4;
    end
    
    // Registrador de PC
    always @(posedge clockCPU or posedge reset) begin
        if (reset)
            PC_reg <= `TEXT_ADDRESS;
        else if (!stall)
            PC_reg <= PC_next;
    end
    
    // Memória de Instruções
    ramI MemInstr (
        .address(PC_reg[11:2]),
        .clock(clockMem),
        .data(32'b0),
        .wren(1'b0),
        .q(Instr_wire)
    );

    //==========================================================================
    //  REGISTRADOR IF/ID
    //==========================================================================
    
    reg_IF_ID IFID (
        .clk(clockCPU),
        .reset(reset),
        .stall(stall),
        .flush(IF_ID_flush || should_jump),
        .instr_in(Instr_wire),
        .pc_plus_4_in(PC_plus_4),
        .instr_out(IF_ID_Instr),
        .pc_plus_4_out(IF_ID_PC_plus_4)
    );

    //==========================================================================
    //  ESTÁGIO ID (Instruction Decode)
    //==========================================================================
    
    // Unidade de Controle Pipeline
    ControlPipeline Control (
        .opcode(IF_ID_Instr[6:0]),
        .ALUSrc(ALUSrc_ID),
        .ALUOp(ALUOp_ID),
        .MemRead(MemRead_ID),
        .MemWrite(MemWrite_ID),
        .Branch(Branch_ID),
        .RegWrite(RegWrite_ID),
        .MemToReg(MemToReg_ID),
        .Jump(Jump_ID),
        .JumpReg(JumpReg_ID)
    );
    
    // Banco de Registradores
    Registers BancoReg (
        .iCLK(clockCPU),
        .iRST(reset),
        .iRegWrite(MEM_WB_RegWrite),
        .iReadRegister1(IF_ID_Instr[19:15]),
        .iReadRegister2(IF_ID_Instr[24:20]),
        .iWriteRegister(MEM_WB_Rd),
        .iWriteData(WriteBack_Data),
        .oReadData1(ReadData1),
        .oReadData2(ReadData2),
        .iRegDispSelect(regin),
        .oRegDisp(regout)
    );
    
    // Gerador de Imediatos
    ImmGen ImmGenerator (
        .iInstrucao(IF_ID_Instr),
        .oImm(ImmGen_out)
    );
    
    assign branch_target_ID = IF_ID_PC_plus_4 - 4 + ImmGen_out;  // PC atual + offset

    //==========================================================================
    //  REGISTRADOR ID/EX - MODIFICADO
    //==========================================================================
    
    reg_ID_EX_fixed IDEX (
        .clk(clockCPU),
        .reset(reset),
        .flush(ID_EX_flush || should_jump),
        
        .pc_plus_4_in(IF_ID_PC_plus_4),
        .read_data1_in(ReadData1),
        .read_data2_in(ReadData2),
        .imm_in(ImmGen_out),
        .rs1_in(IF_ID_Instr[19:15]),
        .rs2_in(IF_ID_Instr[24:20]),
        .rd_in(IF_ID_Instr[11:7]),
        .funct3_in(IF_ID_Instr[14:12]),      
        .funct7_in(IF_ID_Instr[31:25]),      
        .branch_target_in(branch_target_ID), 
        
        .ALUSrc_in(ALUSrc_ID),
        .ALUOp_in(ALUOp_ID),
        .MemRead_in(MemRead_ID),
        .MemWrite_in(MemWrite_ID),
        .Branch_in(Branch_ID),
        .RegWrite_in(RegWrite_ID),
        .MemToReg_in(MemToReg_ID),
        
        .pc_plus_4_out(ID_EX_PC_plus_4),
        .read_data1_out(ID_EX_ReadData1),
        .read_data2_out(ID_EX_ReadData2),
        .imm_out(ID_EX_Imm),
        .rs1_out(ID_EX_Rs1),
        .rs2_out(ID_EX_Rs2),
        .rd_out(ID_EX_Rd),
        .funct3_out(ID_EX_funct3),
        .funct7_out(ID_EX_funct7),
        .branch_target_out(ID_EX_branch_target),
        
        .ALUSrc_out(ID_EX_ALUSrc),
        .ALUOp_out(ID_EX_ALUOp),
        .MemRead_out(ID_EX_MemRead),
        .MemWrite_out(ID_EX_MemWrite),
        .Branch_out(ID_EX_Branch),
        .RegWrite_out(ID_EX_RegWrite),
        .MemToReg_out(ID_EX_MemToReg)
    );

    //==========================================================================
    //  ESTÁGIO EX (Execute)
    //==========================================================================
    
    // Controlador da ULA - CORRIGIDO
    ALUControl ALUCtrl (
        .ALUOp(ID_EX_ALUOp),
        .funct3(ID_EX_funct3),
        .funct7(ID_EX_funct7),
        .ALUControl(ALUControl)
    );
    
    // MUX para segundo operando da ULA
    assign ALU_operand_B = ID_EX_ALUSrc ? ID_EX_Imm : ID_EX_ReadData2;
    
    // ULA
    ALU ULA (
        .iControl(ALUControl),
        .iA(ID_EX_ReadData1),
        .iB(ALU_operand_B),
        .oResult(ALU_result),
        .oZero(ALU_zero)
    );

    //==========================================================================
    //  REGISTRADOR EX/MEM - MODIFICADO
    //==========================================================================
    
    reg_EX_MEM_fixed EXMEM (
        .clk(clockCPU),
        .reset(reset),
        
        .alu_result_in(ALU_result),
        .read_data2_in(ID_EX_ReadData2),
        .rd_in(ID_EX_Rd),
        .alu_zero_in(ALU_zero),
        .branch_target_in(ID_EX_branch_target),
        
        .MemRead_in(ID_EX_MemRead),
        .MemWrite_in(ID_EX_MemWrite),
        .Branch_in(ID_EX_Branch),
        .RegWrite_in(ID_EX_RegWrite),
        .MemToReg_in(ID_EX_MemToReg),
        
        .alu_result_out(EX_MEM_ALU_result),
        .read_data2_out(EX_MEM_ReadData2),
        .rd_out(EX_MEM_Rd),
        .alu_zero_out(EX_MEM_ALU_zero),
        .branch_target_out(EX_MEM_branch_target),
        
        .MemRead_out(EX_MEM_MemRead),
        .MemWrite_out(EX_MEM_MemWrite),
        .Branch_out(EX_MEM_Branch),
        .RegWrite_out(EX_MEM_RegWrite),
        .MemToReg_out(EX_MEM_MemToReg)
    );

    //==========================================================================
    //  ESTÁGIO MEM (Memory Access)
    //==========================================================================
    
    // Memória de Dados
    ramD MemData (
        .address(EX_MEM_ALU_result[11:2]),
        .clock(clockMem),
        .data(EX_MEM_ReadData2),
        .wren(EX_MEM_MemWrite),
        .q(Mem_ReadData)
    );
    
    assign branch_taken = EX_MEM_Branch & EX_MEM_ALU_zero;

    //==========================================================================
    //  REGISTRADOR MEM/WB
    //==========================================================================
    
    reg_MEM_WB MEMWB (
        .clk(clockCPU),
        .reset(reset),
        
        .mem_data_in(Mem_ReadData),
        .alu_result_in(EX_MEM_ALU_result),
        .rd_in(EX_MEM_Rd),
        
        .RegWrite_in(EX_MEM_RegWrite),
        .MemToReg_in(EX_MEM_MemToReg),
        
        .mem_data_out(MEM_WB_MemData),
        .alu_result_out(MEM_WB_ALU_result),
        .rd_out(MEM_WB_Rd),
        
        .RegWrite_out(MEM_WB_RegWrite),
        .MemToReg_out(MEM_WB_MemToReg)
    );

    //==========================================================================
    //  ESTÁGIO WB (Write Back)
    //==========================================================================
    
    // MUX para selecionar dado a ser escrito no banco de registradores
    assign WriteBack_Data = MEM_WB_MemToReg ? MEM_WB_MemData : MEM_WB_ALU_result;

    //==========================================================================
    //  UNIDADE DE HAZARD DETECTION
    //==========================================================================
    
    HazardUnit HazardDetection (
        .IF_ID_Rs1(IF_ID_Instr[19:15]),
        .IF_ID_Rs2(IF_ID_Instr[24:20]),
        .ID_EX_Rd(ID_EX_Rd),
        .ID_EX_MemRead(ID_EX_MemRead),
        .branch_taken(branch_taken),
        .stall(stall),
        .IF_ID_flush(IF_ID_flush),
        .ID_EX_flush(ID_EX_flush)
    );

endmodule