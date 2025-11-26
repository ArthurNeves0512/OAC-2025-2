`ifndef PARAM
    `include "Parametros.v"
`endif

module HazardUnit (

    // id
    input wire [4:0] IF_ID_Rs1,
    input wire [4:0] IF_ID_Rs2,
    
    // EX
    input wire [4:0] ID_EX_Rd,
    input wire ID_EX_MemRead,
    
    // branch/jump
    input wire branch_taken,
    
    // Saídas
    output reg stall,           // paralisa if/id e id/ex
    output reg IF_ID_flush,     // flush branch/jump
    output reg ID_EX_flush      // nop
);

    always @(*) begin

        stall = 1'b0;
        IF_ID_flush = 1'b0;
        ID_EX_flush = 1'b0;
        
        // hazard de load-use: lw c instrução de dado
        if (ID_EX_MemRead && 
            ((ID_EX_Rd == IF_ID_Rs1) || (ID_EX_Rd == IF_ID_Rs2)) &&
            (ID_EX_Rd != 5'b0)) begin
            stall = 1'b1;
            ID_EX_flush = 1'b1;
        end
        
        // branch hazard/jump p/ descarta usados
        if (branch_taken) begin
            IF_ID_flush = 1'b1;
            ID_EX_flush = 1'b1;
        end
    end

endmodule