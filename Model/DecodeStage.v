module DecodeStage(input clk,              output RegWriteE,
                   input rst,              output ALUSrcE,
                   input[31:0] InstrD,     output MemWriteE,
                   input[31:0] PCD,        output MemReadE,
                   input[31:0] ResultW,    output ResultSrcE,
                   input[31:0] PCPlus4D,   output[2:0] BranchE,
                   input RegWriteW,        output[2:0] ALUControlE,
                   input[4:0] RDW,         output[31:0] RD1_E,
                   input StallD,           output[31:0] RD2_E,
                   input PipelineFlush,    output[31:0] ImmExtE,
                                           output[4:0] RD_E,
                                           output[31:0] PCE,
                                           output[31:0] PCPlus4E,
                                           output[4:0] RS1_E,
                                           output[4:0] RS2_E,
                                           output[2:0] BranchD);

    wire RegWriteD, ALUSrcD, MemWriteD, MemReadD, ResultSrcD;
    wire[1:0] ImmSrcD;
    wire[2:0] ALUControlD;
    wire[31:0] RD1_D, RD2_D, ImmExtD;

    reg RegWriteD_r, ALUSrcD_r, MemWriteD_r, MemReadD_r, ResultSrcD_r;
    reg[2:0] ALUControlD_r, BranchD_r;
    reg[31:0] RD1_D_r, RD2_D_r, ImmExtD_r;
    reg[4:0] RD_D_r, RS1_D_r, RS2_D_r;
    reg[31:0] PCD_r, PCPlus4D_r;


    ControlUnit CU(.Op(InstrD[6:0]),
                   .RegWrite(RegWriteD),
                   .ImmSrc(ImmSrcD),
                   .ALUSrc(ALUSrcD),
                   .MemWrite(MemWriteD),
                   .MemRead(MemReadD),
                   .ResultSrc(ResultSrcD),
                   .Branch(BranchD),
                   .funct3(InstrD[14:12]),
                   .funct7(InstrD[31:25]),
                   .ALUControl(ALUControlD));

    RegisterFile RegFile(.clk(clk),
                         .rst(rst),
                         .A1(InstrD[19:15]),
                         .A2(InstrD[24:20]),
                         .A3(RDW),
                         .WE3(RegWriteW),
                         .D3(ResultW),
                         .D1(RD1_D),
                         .D2(RD2_D));

    SignExtend Sext(.In(InstrD[31:0]),
                    .ImmExt(ImmExtD),
                    .ImmSrc(ImmSrcD));


    always @ (posedge clk or negedge rst) begin
        if(rst == 1'b1 | PipelineFlush == 1'b1) begin
            RegWriteD_r <= 1'b0;
            ALUSrcD_r <= 1'b0;
            MemWriteD_r <= 1'b0;
            MemReadD_r <= 1'b0;
            ResultSrcD_r <= 1'b0;
            BranchD_r <= 3'b000;
            ALUControlD_r <= 3'b000;
            RD1_D_r <= 32'h00000000; 
            RD2_D_r <= 32'h00000000; 
            ImmExtD_r <= 32'h00000000;
            RD_D_r <= 5'h00;
            PCD_r <= 32'h00000000; 
            PCPlus4D_r <= 32'h00000000;
            RS1_D_r <= 5'h00;
            RS2_D_r <= 5'h00;
        end
        else if (StallD == 1'b0) begin
            RegWriteD_r <= RegWriteD;
            ALUSrcD_r <= ALUSrcD;
            MemWriteD_r <= MemWriteD;
            MemReadD_r <= MemReadD;
            ResultSrcD_r <= ResultSrcD;
            BranchD_r <= BranchD;
            ALUControlD_r <= ALUControlD;
            RD1_D_r <= RD1_D; 
            RD2_D_r <= RD2_D; 
            ImmExtD_r <= ImmExtD;
            RD_D_r <= InstrD[11:7];
            PCD_r <= PCD; 
            PCPlus4D_r <= PCPlus4D;
            RS1_D_r <= InstrD[19:15];
            RS2_D_r <= InstrD[24:20];
        end
    end

    assign RegWriteE = RegWriteD_r;
    assign ALUSrcE = ALUSrcD_r;
    assign MemWriteE = MemWriteD_r;
    assign MemReadE = MemReadD_r;
    assign ResultSrcE = ResultSrcD_r;
    assign BranchE = BranchD_r;
    assign ALUControlE = ALUControlD_r;
    assign RD1_E = RD1_D_r;
    assign RD2_E = RD2_D_r;
    assign ImmExtE = ImmExtD_r;
    assign RD_E = RD_D_r;
    assign PCE = PCD_r;
    assign PCPlus4E = PCPlus4D_r;
    assign RS1_E = RS1_D_r;
    assign RS2_E = RS2_D_r;

endmodule
