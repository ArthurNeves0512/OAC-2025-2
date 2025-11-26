`include "Parametros.v"

module ramI (
    input wire [9:0] address,      // 10 bits
    input wire clock,
    input wire [31:0] data,
    input wire wren,
    output reg [31:0] q
);

    // 2**1024 words de 32 bits
    reg [31:0] mem [0:1023];
    
    initial begin
        $readmemh("de1_text.mif", mem);
    end
    
    // sync
    always @(posedge clock) begin
        q <= mem[address];
    end

endmodule