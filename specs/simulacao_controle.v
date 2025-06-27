module simulacao_controle;


    // --- Entradas para o módulo de controle ---
    reg  [2:0] opcode;
    reg  [1:0] BitVerificacao;
    reg  clock;


    // --- Saídas do módulo de controle ---
    wire STOP;
    wire EscPC;
    wire EscReg;
    wire EscMEM;
    wire LerMEM;
    wire Ji;
    wire Beqz;
    wire [1:0] ULAOp;
    wire [1:0] ULAFonte;
    wire EndFonte_MEM;
    wire FonteEscReg;
    wire RegFonte;


    // Instanciação do Módulo de Controle (Device Under Test - DUT)
    Controle dut (
        .opcode(opcode),
        .BitVerificacao(BitVerificacao),
        .clock(clock),
        .STOP(STOP),
        .EscPC(EscPC),
        .EscReg(EscReg),
        .EscMEM(EscMEM),
        .LerMEM(LerMEM),
        .Ji(Ji),
        .Beqz(Beqz),
        .ULAOp(ULAOp),
        .ULAFonte(ULAFonte),
        .EndFonte_MEM(EndFonte_MEM),
        .FonteEscReg(FonteEscReg),
        .RegFonte(RegFonte)
    );


    // Geração do sinal de clock (a cada 5 unidades de tempo, o clock inverte)
    always #5 clock = ~clock;


    // --- Script de Simulação ---
    initial begin
        // Inicialização dos sinais
        clock = 0;
        opcode = 3'b000;
        BitVerificacao = 2'b00;


        // Monitor para exibir as mudanças nos sinais no console
        $monitor("Time=%0t | Opcode=%b | STOP=%b EscPC=%b EscReg=%b LerMEM=%b EscMEM=%b | Ji=%b Beqz=%b | ULAOp=%b ULAFonte=%b",
                 $time, opcode, STOP, EscPC, EscReg, LerMEM, EscMEM, Ji, Beqz, ULAOp, ULAFonte);
       
        // --- Início dos Testes ---
        // Testa cada instrução, uma por ciclo de clock
       
        // 1. Teste ADD (000)
        #10; // Espera um ciclo de clock (10 unidades de tempo)
        opcode = 3'b000;
       
        // 2. Teste COPY (001)
        #10;
        opcode = 3'b001;
       
        // 3. Teste READ (010)
        #10;
        opcode = 3'b010;
       
        // 4. Teste WRITE (011)
        #10;
        opcode = 3'b011;
       
        // 5. Teste IFZERO (100)
        #10;
        opcode = 3'b100;
       
        // 6. Teste JUMP (101)
        #10;
        opcode = 3'b101;
       
        // 7. Teste SET (110)
        #10;
        opcode = 3'b110;
       
        // 8. Teste STOP (111)
        #10;
        opcode = 3'b111;
       
        // 9. Verifica o estado após STOP
        #10;
        opcode = 3'b000; // Tenta executar um ADD, mas o STOP deve impedir


        // Finaliza a simulação
        #10;
        $finish;
    end


endmodule
