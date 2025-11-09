`ifndef PARAM
	`include "Parametros.v"
`endif

module Uniciclo (
	input logic clockCPU, clockMem,
	input logic reset,
	output logic [31:0] PC,
	output logic [31:0] Instr,
	input logic [4:0] regin,   
	output logic [31:0] regout   
	);
	
	logic [31:0] PCnext, PCplus4, PCbranch, PCjal, PCjalr;
	logic [31:0] ImmGen_out;
	logic [31:0] ReadData1, ReadData2;
	logic [31:0] ALU_B;
	logic [31:0] ALU_result;
	logic [31:0] MemData;
	logic [31:0] WriteData;
	
	logic Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
	logic JAL, JALR, LUI;
	logic [1:0] ALUOp;
	logic [4:0] ALUControl_out;
	logic Zero;
	logic PCSrc; 
	
	initial
		begin
			PC<=TEXT_ADDRESS;
			Instr<=32'b0;
			regout<=32'b0;
		end
		
	always @(posedge clockCPU or posedge reset)
	begin
		if(reset)
			PC <= TEXT_ADDRESS; 
		else
			PC <= PCnext;
	end
	
	assign PCplus4  = PC + 32'd4;
	assign PCbranch = PC + ImmGen_out; 
	assign PCjalr   = ALU_result & ~32'h1; 
	
	assign PCSrc = (Branch & Zero);
	
	always @(*) 
	begin
		if (JALR)
			PCnext = PCjalr;  
		else if (JAL)
			PCnext = PCbranch;  
		else if (PCSrc)
			PCnext = PCbranch;  
		else
			PCnext = PCplus4;   
	end
	
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
	
	Registers regs (
		.iCLK(clockCPU),
		.iRST(reset),
		.iRegWrite(RegWrite),
		.iReadRegister1(Instr[19:15]),  
		.iReadRegister2(Instr[24:20]),  
		.iWriteRegister(Instr[11:7]),   
		.iWriteData(WriteData),         
		.oReadData1(ReadData1),
		.oReadData2(ReadData2),
		.iRegDispSelect(regin),
		.oRegDisp(regout)
	);
	
	ImmGen immgen (
		.iInstrucao(Instr),
		.oImm(ImmGen_out)
	);
	
	assign ALU_B = ALUSrc ? ImmGen_out : ReadData2;
	
	ALUControl aluctrl (
		.ALUOp(ALUOp),
		.funct3(Instr[14:12]),
		.funct7(Instr[31:25]),
		.ALUControl(ALUControl_out)
	);
	
	ALU alu (
		.iControl(LUI ? OPLUI : ALUControl_out), 
		.iA(ReadData1),
		.iB(ALU_B),
		.oResult(ALU_result),
		.Zero(Zero)
	);
	
	ramD MemD (
		.address(ALU_result[11:2]), 
		.clock(clockMem),
		.data(ReadData2),           
		.wren(MemWrite),            
		.q(MemData)                
	);
	
	always @(*) begin
		if (JAL | JALR)
			WriteData = PCplus4;      
		else if (MemtoReg)
			WriteData = MemData;      
		else
			WriteData = ALU_result; 
	end
	
endmodule
