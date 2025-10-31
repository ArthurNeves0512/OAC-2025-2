`ifndef PARAM
	`include "Parametros.v"
`endif

module Uniciclo (
	input logic clockCPU, clockMem,
	input logic reset,
	output logic [31:0] PC,
	output logic [31:0] Instr,
	input  logic [4:0] regin,    // Entrada de debug (Item 1.2)
	output logic [31:0] regout   // Saída de debug (Item 1.2)
	);
	
	// --- Sinais (fios) Internos ---
	logic [31:0] PCnext, PCplus4, PCbranch, PCjalr;
	logic [31:0] ImmGen_out;
	logic [31:0] ReadData1, ReadData2;
	logic [31:0] ALU_B;
	logic [31:0] ALU_result;
	logic [31:0] MemData;
	logic [31:0] WriteData;
	
	// Sinais de controle
	logic Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
	logic JAL, JALR, LUI;
	logic [1:0] ALUOp;
	logic [4:0] ALUControl_out;
	logic Zero;
	logic PCSrc; // Fio para (Branch & Zero)
	
	initial
		begin
			PC<=TEXT_ADDRESS;
			Instr<=32'b0;
			regout<=32'b0;
		end
		
		
	always @(posedge clockCPU or posedge reset)
	begin
		if(reset)
			PC <= TEXT_ADDRESS; // Endereço inicial do programa
		else
			PC <= PCnext;
	end
	
	// Calcula os possíveis próximos endereços
	assign PCplus4  = PC + 32'd4;
	assign PCbranch = PC + ImmGen_out; // Alvo para BEQ e JAL
	assign PCjalr   = ALU_result & ~32'h1; // Alvo para JALR (resultado da ULA, zera bit 0)
	
	// Sinal de habilitação do desvio BEQ
	assign PCSrc = (Branch & Zero);
	
	// MUX de seleção do próximo PC
	always @(*) 
	begin
		if (JALR)
			PCnext = PCjalr;   // JALR tem a maior prioridade
		else if (JAL)
			PCnext = PCbranch;  // JAL usa o mesmo cálculo de alvo que BEQ/JAL
		else if (PCSrc)
			PCnext = PCbranch;  // BEQ (se Zero=1)
		else
			PCnext = PCplus4;   // Padrão
	end
	
	// Memória de Instruções (Instanciada do seu esqueleto)
	ramI MemI (
		.address(PC[11:2]), 
		.clock(clockMem), 
		.data(), 
		.wren(1'b0), 
		.q(Instr)
	);
	

	
	Control ctrl (
		.opcode(Instr[6:0]),
		.Branch(Branch),
		.MemRead(MemRead),
		.MemtoReg(MemtoReg),
		.ALUOp(ALUOp),
		.MemWrite(MemWrite),
		.ALUSrc(ALUSrc),
		.RegWrite(RegWrite),
		.JAL(JAL),
		.JALR(JALR),
		.LUI(LUI)
	);
	
	// Banco de Registradores (Módulo da Maria Fernanda)
	Registers regs (
		.iCLK(clockCPU),
		.iRST(reset),
		.iRegWrite(RegWrite),
		.iReadRegister1(Instr[19:15]),  // rs1
		.iReadRegister2(Instr[24:20]),  // rs2
		.iWriteRegister(Instr[11:7]),   // rd
		.iWriteData(WriteData),         // Dado que vem do MUX de Write Back
		.oReadData1(ReadData1),
		.oReadData2(ReadData2),
		.iRegDispSelect(regin),
		.oRegDisp(regout)
	);
	
	// Gerador de Imediato (Módulo do João)
	ImmGen immgen (
		.iInstrucao(Instr),
		.oImm(ImmGen_out)
	);
	
 
	assign ALU_B = ALUSrc ? ImmGen_out : ReadData2;
	
	// Controle da ULA (Módulo do Rodrigo)
	ALUControl aluctrl (
		.ALUOp(ALUOp),
		.funct3(Instr[14:12]),
		.funct7(Instr[31:25]),
		.ALUControl(ALUControl_out)
	);
	
	// ULA (Módulo do Arthur)
	ULA alu (
        // Lógica inteligente: Se for LUI, força a operação OPLUI.
        // Senão, usa a saída normal do ALUControl.
		.iControl(LUI ? OPLUI : ALUControl_out), 
		.iA(ReadData1),
		.iB(ALU_B),
		.oResult(ALU_result),
		.Zero(Zero)
	);
	
	
	ramD MemD (
		.address(ALU_result[11:2]), // Endereço vem da ULA
		.clock(clockMem),
		.data(ReadData2),           // Dado a ser escrito (para SW)
		.wren(MemWrite),            // Sinal de controle
		.q(MemData)                 // Dado lido da memória (para LW)
	);
	

	always @(*) begin
		if (JAL | JALR)
			WriteData = PCplus4;      // JAL e JALR salvam o endereço de retorno (PC+4)
		else if (MemtoReg)
			WriteData = MemData;      // LW salva o dado vindo da memória
		else
			WriteData = ALU_result; // R-Type, ADDI, e LUI salvam o resultado da ULA
	end
	
endmodule
