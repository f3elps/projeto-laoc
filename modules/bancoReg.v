module bancoReg (
    input wire clk,
    input wire reset,
    input wire EscReg,         // Habilita a escrita no registrador
    input wire [1:0] read_addr1, // Endereço de leitura 1
    input wire [1:0] read_addr2, // Endereço de leitura 2
    input wire [1:0] write_addr, // Endereço de escrita
    input wire [7:0] write_data, // Dado a ser escrito
    output reg [7:0] read_data1, // Saída de dado 1
    output reg [7:0] read_data2  // Saída de dado 2
);


    // 4 registradores de 8 bits (endereços de 2 bits)
    reg [7:0] registers[0:3];
    integer i;


    // Lógica de escrita na borda de subida
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 4; i = i + 1) begin
                registers[i] <= 8'h00;
            end
        end else if (EscReg) begin
            registers[write_addr] <= write_data;
        end
    end


    // Lógica de leitura na borda de descida
    always @(negedge clk) begin
        read_data1 <= registers[read_addr1];
        read_data2 <= registers[read_addr2];
    end


endmodule
