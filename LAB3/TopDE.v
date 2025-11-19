`ifndef PARAM
	`include "Parametros.v"
`endif

module TopDE (
	input logic CLOCK, Reset,
	input logic [4:0] Regin,
	output logic ClockDIV,
	output logic [31:0] PC,Instr,Regout,
	output logic [3:0] Estado
	);
	
	// Corrigido para sincronismo e inicialização
	always @(posedge CLOCK or posedge Reset) 
	begin
		if(Reset)
            ClockDIV <= 1'b0; // FIX: Garante que o clock divisível comece em zero
        else
			ClockDIV <= ~ClockDIV;
	end
	
/* Uniciclo UNI1 (.clockCPU(ClockDIV), .clockMem(CLOCK), .reset(Reset), 
						.PC(PC), .Instr(Instr), .regin(Regin), .regout(Regout)); */

	// Instância do Processador Multiciclo
	Multiciclo MULT1 (.clockCPU(ClockDIV), .clockMem(CLOCK), .reset(Reset), 
						.PC(PC), .Instr(Instr), .regin(Regin), .regout(Regout), .estado(Estado));	
						
/* Pipeline PIP1 (.clockCPU(ClockDIV), .clockMem(CLOCK), .reset(Reset), 
						.PC(PC), .Instr(Instr), .regin(Regin), .regout(Regout)); */
		
endmodule