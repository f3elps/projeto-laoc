module Controle (
    input wire [2:0] opcode,          // 3 bits agora
    input wire [1:0] BitVerificacao,  // Bits auxiliares (IFZERO, JUMP etc)
    input wire clock,
    
    output reg STOP,
    output reg EscPC,
    output reg EscReg,
    output reg EscMEM,
    output reg LerMEM,
    output reg Ji,
    output reg Beqz,
    output reg [1:0] ULAOp,
    output reg [1:0] ULAFonte,
    output reg EndFonte_MEM,
    output reg FonteEscReg,
    output reg RegFonte
);
    always @(posedge clock) begin
        STOP = 0;
        EscPC = 1;
        EscReg = 0;
        EscMEM = 0;
        LerMEM = 0;
        Ji = 0;
        Beqz = 0;
        ULAOp = 2'b00;
        ULAFonte = 2'b10;
        EndFonte_MEM = 0;
        FonteEscReg = 0;
        RegFonte = 0;

        case (opcode)
            3'b000: begin // ADD
                ULAOp = 2'b00;
                ULAFonte = 2'b10; // Registrador
                EscReg = 1;
                FonteEscReg=0;
            end

            3'b001: begin // COPY
                ULAOp = 2'b00;
                ULAFonte = 2'b01; // Constante zero
                EscReg = 1;
            end

            3'b010: begin // READ
                LerMEM = 1;
                RegFonte = 1; // Memória
                EscReg = 1;
                ULAFonte = 2'b00; // Imediato curto
                EndFonte_MEM = 1; // Endereço = Rb + Imediato
            end

            3'b011: begin // WRITE
                EscMEM = 1;
                ULAFonte = 2'b00; // Imediato curto
                EndFonte_MEM = 1;
            end

            3'b100: begin // IFZERO
                Ji = 0;
                Beqz = 1;
                ULAFonte = 2'b01; // Constante zero
                ULAOp = 2'b01;     // Comparação
            end

            3'b101: begin // JUMP
                Ji = 1;
                EscPC = 1;
            end

            3'b110: begin // SET
                ULAOp = 2'b00;
                ULAFonte = 2'b00; // Imediato curto
                EscReg = 1;
                FonteEscReg = 1;  // Imediato como valor final
            end

            3'b111: begin // STOP
                STOP = 1;
            end

            default: begin
                // Nenhuma instrução válida
            end
        endcase

        // Efeito do STOP
        if (STOP) begin
            EscPC = 0;
            EscReg = 0;
            EscMEM = 0;
        end
    end
endmodule


// Código da ULA:

module ULA (
    input wire [7:0] entrada1,
    input wire [7:0] entrada2,
    input wire [1:0] ULAop,
    output reg Zero,
    output reg [7:0] Resultado
);

    always @(*) begin
        case (ULAop)
            2'b00: Resultado = entrada1 + entrada2;         // ADD
            2'b01: Resultado = (entrada1 == entrada2) ? 8'b00000000 : 8'b00000001; // CMP (para IFZERO)
            2'b10: Resultado = entrada1 & entrada2;         // AND
            default: Resultado = 8'b00000000;
        endcase

        // Flag Zero ativado se resultado for exatamente zero
        Zero = (Resultado == 8'b00000000) ? 1 : 0;
    end

endmodule
