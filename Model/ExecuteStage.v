module ExecuteStage(input clk,                 output PCSrcE,
                    input rst,                 output RegWriteM,
                    input RegWriteE,           output MemReadM,
                    input ALUSrcE,             output ResultSrcM,
                    input MemWriteE,           output MemWriteM,
                    input MemReadE,            output[4:0] RD_M,
                    input ResultSrcE,          output[31:0] ALU_ResultM,
                    input StallE,              output[31:0] PCTargetE,
                    input[2:0] BranchE,        output[31:0] PCPlus4M,
                    input[2:0] ALUControlE,    output[31:0] WriteDataM,
                    input[31:0] RD1_E,
                    input[31:0] RD2_E,
                    input[31:0] ImmExtE,
                    input[4:0] RD_E,
                    input[31:0] PCE,
                    input[31:0] PCPlus4E,
                    input[31:0] ResultW,
                    input[1:0] ForwardA_E,
                    input[1:0] ForwardB_E,
                    input PipelineFlush);

    wire[31:0] Src_A, Src_B_interim, Src_B;
    wire[31:0] ResultE;
    wire ZeroE, Negative;

    reg RegWriteE_r, MemWriteE_r, MemReadE_r, ResultSrcE_r;
    reg[4:0] RD_E_r;
    reg[31:0] PCPlus4E_r, RD2_E_r, ResultE_r;


    Mux3 ForwardSrcAMux(.a(RD1_E),
                        .b(ResultW),
                        .c(ALU_ResultM),
                        .s(ForwardA_E),
                        .d(Src_A));

    Mux3 ForwardSrcBMux(.a(RD2_E),
                        .b(ResultW),
                        .c(ALU_ResultM),
                        .s(ForwardB_E),
                        .d(Src_B_interim));

    Mux Rs2ImmMux(.a(Src_B_interim),
                  .b(ImmExtE),
                  .s(ALUSrcE),
                  .c(Src_B));

    ALU ALU(.A(Src_A),
            .B(Src_B),
            .Result(ResultE),
            .ALUControl(ALUControlE),
            .Zero(ZeroE),
            .Negative(Negative));

    PCAdder BranchHandler(.a(PCE),
                          .b(ImmExtE),
                          .c(PCTargetE));


    always @ (posedge clk or negedge rst) begin
        if(rst == 1'b1 | (PipelineFlush == 1'b1)) begin
            RegWriteE_r <= 1'b0; 
            MemWriteE_r <= 1'b0; 
            MemReadE_r <= 1'b0; 
            ResultSrcE_r <= 1'b0;
            RD_E_r <= 5'h00;
            PCPlus4E_r <= 32'h00000000; 
            RD2_E_r <= 32'h00000000; 
            ResultE_r <= 32'h00000000;
        end
        else if(StallE == 1'b0) begin
            RegWriteE_r <= RegWriteE; 
            MemWriteE_r <= MemWriteE; 
            MemReadE_r <= MemReadE; 
            ResultSrcE_r <= ResultSrcE;
            RD_E_r <= RD_E;
            PCPlus4E_r <= PCPlus4E; 
            RD2_E_r <= Src_B_interim; 
            ResultE_r <= ResultE;
        end
    end


    assign PCSrcE = (BranchE == `BRANCH_TYPE_BEQ) ? (ZeroE) :
                    (BranchE == `BRANCH_TYPE_BNE) ? (~ZeroE) :
                    (BranchE == `BRANCH_TYPE_BLT) ? (Negative) :
                    (BranchE == `BRANCH_TYPE_BGE) ? (ZeroE | ~Negative) : 1'b0;

    assign RegWriteM = RegWriteE_r;
    assign MemWriteM = MemWriteE_r;
    assign MemReadM = MemReadE_r;
    assign ResultSrcM = ResultSrcE_r;
    assign RD_M = RD_E_r;
    assign PCPlus4M = PCPlus4E_r;
    assign WriteDataM = RD2_E_r;
    assign ALU_ResultM = ResultE_r;

endmodule
