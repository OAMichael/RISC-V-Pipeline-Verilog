module MemoryStage(input clk,              output RegWriteW,
                   input rst,              output ResultSrcW,
                   input RegWriteM,        output[4:0] RD_W,
                   input MemWriteM,        output[31:0] PCPlus4W,
                   input MemReadM,         output MemReadW,
                   input ResultSrcM,       output[31:0] ALU_ResultW,
                   input[4:0] RD_M,        output[31:0] ReadDataW,
                   input[31:0] PCPlus4M,
                   input[31:0] WriteDataM,
                   input[31:0] ALU_ResultM);
    
    wire[31:0] ReadDataM;

    reg RegWriteM_r, ResultSrcM_r, MemReadW_r;
    reg[4:0] RD_M_r;
    reg[31:0] PCPlus4M_r, ALU_ResultM_r, ReadDataM_r;


    DataMemory DMEM(.clk(clk),
                    .rst(rst),
                    .WE(MemWriteM),
                    .WD(WriteDataM),
                    .A(ALU_ResultM),
                    .RD(ReadDataM));


    always @ (posedge clk or negedge rst) begin
        if (rst == 1'b1) begin
            RegWriteM_r <= 1'b0; 
            MemReadW_r <= 1'b0;
            ResultSrcM_r <= 1'b0;
            RD_M_r <= 5'h00;
            PCPlus4M_r <= 32'h00000000; 
            ALU_ResultM_r <= 32'h00000000; 
            ReadDataM_r <= 32'h00000000;
        end
        else begin
            RegWriteM_r <= RegWriteM;
            MemReadW_r <= MemReadM;
            ResultSrcM_r <= ResultSrcM;
            RD_M_r <= RD_M;
            PCPlus4M_r <= PCPlus4M;
            ALU_ResultM_r <= ALU_ResultM;
            ReadDataM_r <= ReadDataM;
        end
    end 


    assign RegWriteW = RegWriteM_r;
    assign ResultSrcW = ResultSrcM_r;
    assign MemReadW = MemReadW_r;
    assign RD_W = RD_M_r;
    assign PCPlus4W = PCPlus4M_r;
    assign ALU_ResultW = ALU_ResultM_r;
    assign ReadDataW = ReadDataM_r;

endmodule
