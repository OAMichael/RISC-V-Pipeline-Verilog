module DataMemory(input clk,       output[31:0] RD,
                  input rst,
                  input WE,
                  input[31:0] WD,
                  input[31:0] A);

    reg[31:0] Memory[`DMEM_SIZE:0];

    always @ (posedge clk) begin
        if(WE) begin
            Memory[A] <= WD;
        end
    end

    assign RD = rst ? 32'd0 : Memory[A];

endmodule
