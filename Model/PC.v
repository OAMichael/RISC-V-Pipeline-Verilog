module PCModule(input clk,     output reg[31:0] PC,
                input rst,
                input[31:0] PC_Next,
                input Stall);

    always @ (posedge clk) begin
        if(rst == 1'b1) begin
            PC <= {32{1'b0}};
        end
        else if (Stall == 1'b0) begin
            PC <= PC_Next;
        end
    end

endmodule


module PCAdder(input[31:0] a, output[31:0]c,
               input[31:0] b);

    assign c = a + b;
    
endmodule
