module memoInstrucoes (
    input wire clk,
    input wire [7:0] address,      // Endereço da instrução (do PC)
    output reg [7:0] instruction_out // Instrução lida
);


    // Memória de 256 posições de 8 bits
    reg [7:0] memory[0:255];


    // Inicializa a memória a partir de um arquivo .hex na mesma pasta
    initial begin
        $readmemh("instructions.hex", memory);
    end


    // Lógica de leitura na borda de descida do clock
    always @(negedge clk) begin
        instruction_out <= memory[address];
    end


endmodule