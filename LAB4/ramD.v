`include "Parametros.v"

module ramD (
    input wire [9:0] address,
    input wire clock,
    input wire [31:0] data,
    input wire wren,
    output reg [31:0] q
);
    reg [31:0] mem [0:1023];
    
    initial begin
        $readmemh("de1_data.mif", mem);
    end
    
    always @(posedge clock) begin
        if (wren) begin
            mem[address] <= data;   // write
        end
        q <= mem[address];          // read sempre happens
    end

endmodule