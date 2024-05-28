module RegisterFile(input clk,         output[31:0] D1,
                    input rst,         output[31:0] D2,
                    input[4:0] A1,
                    input[4:0] A2,
                    input[4:0] A3,
                    input WE3,
                    input[31:0] D3);

    reg[31:0] Registers[31:0];

    // Write on negative edge
    always @ (negedge clk) begin
        if(WE3 & (A3 != 5'h00)) begin
            Registers[A3] <= D3;
        end
    end

    assign D1 = rst ? 32'd0 : Registers[A1];
    assign D2 = rst ? 32'd0 : Registers[A2];

    initial begin
        Registers[0] = 32'h00000000;
    end

endmodule
