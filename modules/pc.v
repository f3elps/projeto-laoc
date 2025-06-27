module PC (
    input wire clk,
    input wire reset,
    input wire EscPC,       // Habilita a escrita no PC
    input wire [7:0] pc_in, // Novo valor do PC
    output reg [7:0] pc_out // Saída do PC
);


    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc_out <= 8'h00;
        end else if (EscPC) begin
            pc_out <= pc_in;
        end
    end


endmodule
