module pipelineRegister #(
    parameter WIDTH = 8
) (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire [WIDTH-1:0] data_in,
    output reg [WIDTH-1:0] data_out
);


    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 0;
        end else if (enable) begin
            data_out <= data_in;
        end
    end


endmodule