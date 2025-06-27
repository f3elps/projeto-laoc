`timescale 1ns/1ps

module tb_ula_controle;

    // Clock
    reg clk;
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Entradas para Controle
    reg [2:0] opcode;
    reg [1:0] bit_verif;

    // Saídas do Controle
    wire STOP, EscPC, EscReg, EscMEM, LerMEM, Ji, Beqz;
    wire [1:0] ULAOp, ULAFonte;
    wire EndFonte_MEM, FonteEscReg, RegFonte;

    // Entradas para ULA
    reg [7:0] entrada1, entrada2;

    // Saídas da ULA
    wire [7:0] Resultado;
    wire Zero;

    // Instanciações
    Controle ctrl (
        .opcode(opcode),
        .BitVerificacao(bit_verif),
        .clock(clk),
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

    ULA ula (
        .entrada1(entrada1),
        .entrada2(entrada2),
        .ULAop(ULAOp),
        .Zero(Zero),
        .Resultado(Resultado)
    );

    // Procedimento de Testes
    initial begin
        $display("\n==== TESTE ULA + CONTROLE ====");

        bit_verif = 2'b00; // default

        // 1. Teste ADD (opcode = 000)
        opcode = 3'b000;
        entrada1 = 8'd10;
        entrada2 = 8'd5;
        #10;
        $display("[ADD] 10 + 5 = %d | Resultado = %d | Zero = %b", entrada1, Resultado, Zero);

        // 2. Teste COPY (opcode = 001)
        opcode = 3'b001;
        entrada1 = 8'd42;
        entrada2 = 8'd0; // será ignorado
        #10;
        $display("[COPY] %d + 0 = %d | Resultado = %d | Zero = %b", entrada1, entrada2, Resultado, Zero);

        // 3. Teste IFZERO com igualdade (opcode = 100)
        opcode = 3'b100;
        entrada1 = 8'd7;
        entrada2 = 8'd7;
        #10;
        $display("[IFZERO] %d == %d -> Resultado = %d | Zero = %b | Beqz = %b", entrada1, entrada2, Resultado, Zero, Beqz);

        // 4. Teste IFZERO com diferença
        entrada1 = 8'd7;
        entrada2 = 8'd8;
        #10;
        $display("[IFZERO] %d != %d -> Resultado = %d | Zero = %b | Beqz = %b", entrada1, entrada2, Resultado, Zero, Beqz);

        // 5. Teste STOP
        opcode = 3'b111;
        #10;
        $display("[STOP] STOP = %b | EscPC = %b | EscReg = %b | EscMEM = %b", STOP, EscPC, EscReg, EscMEM);

        $display("==== FIM DO TESTE ====");
        $finish;
    end

endmodule
