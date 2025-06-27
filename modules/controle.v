module controle (
    input wire [2:0] opcode,        // 3 bits para o código da operação
    input wire [1:0] BitVerificacao,  // Bits auxiliares (não utilizados no código atual)
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


    // Lógica síncrona que reage à borda de subida do clock
    always @(posedge clock) begin
                STOP         = 0;
        EscPC        = 1;  // PC incrementa por padrão
        EscReg       = 0;  // Não escreve em registradores
        EscMEM       = 0;  // Não escreve na memória
        LerMEM       = 0;  // Não lê da memória
        Ji           = 0;  // Não é um jump incondicional
        Beqz         = 0;  // Não é um branch condicional
        ULAOp        = 2'b00; // Operação padrão da ULA (ex: soma)
        ULAFonte     = 2'b10; // Fonte padrão da ULA (registradores)
        EndFonte_MEM = 0;
        FonteEscReg  = 0;
        RegFonte     = 0;


                case (opcode)
            3'b000: begin // ADD
                ULAOp       = 2'b00; // ULA realiza SOMA
                ULAFonte    = 2'b10; // ULA usa dois registradores como entrada
                EscReg      = 1;     // Escreve o resultado no banco de registradores
                FonteEscReg = 0;     // O resultado vem da ULA
            end


            3'b001: begin // COPY (Ra <- Rb)
                ULAOp       = 2'b00; // ULA pode somar com zero para "copiar"
                ULAFonte    = 2'b01; // ULA usa Rb e a constante 0
                EscReg      = 1;     // Escreve o resultado em Ra
            end


            3'b010: begin // READ (Ra <- MEM[Rb + Imm])
                LerMEM       = 1;     // Habilita a leitura da memória de dados
                RegFonte     = 1;     // A escrita no registrador virá da memória
                EscReg       = 1;     // Habilita a escrita no registrador Ra
                ULAFonte     = 2'b00; // ULA usa Rb e imediato para calcular endereço
                EndFonte_MEM = 1;     // O endereço da memória vem da ULA
            end


            3'b011: begin                 EscMEM       = 1;                     ULAFonte     = 2'b00;                 EndFonte_MEM = 1;                 end


            3'b100: begin                 Beqz         = 1;                     ULAFonte     = 2'b01;                 ULAOp        = 2'b01; 
            end


            3'b101: begin // JUMP
                Ji           = 1;     // Habilita o sinal para um desvio incondicional
                EscPC        = 1;     // Permite que o PC seja atualizado para o novo endereço
            end


            3'b110: begin 
                ULAOp       = 2'b00; 
                ULAFonte    = 2'b00; 
                EscReg      = 1;     
                FonteEscReg = 1;     
            end


            3'b111: begin // STOP
                STOP         = 1;     // Ativa o sinal de parada
            end


            default: begin
                           end
        endcase


        // A instrução STOP sobrepõe outras e desliga as escritas
        if (STOP) begin
            EscPC  = 0;
            EscReg = 0;
            EscMEM = 0;
        end
    end
endmodule
