`include "Constants.v"
`include "FetchStage.v"
`include "DecodeStage.v"
`include "ExecuteStage.v"
`include "MemoryStage.v"
`include "WritebackStage.v"    
`include "PC.v"
`include "Mux.v"
`include "InstructionMemory.v"
`include "ControlUnit.v"
`include "RegisterFile.v"
`include "SignExtend.v"
`include "ALU.v"
`include "DataMemory.v"
`include "HazardUnit.v"


module PipelineTop(input clk, input rst);

    wire PCSrcE, RegWriteW, RegWriteE, ALUSrcE, MemWriteE, MemReadE, ResultSrcE, RegWriteM, MemWriteM, MemReadM, ResultSrcM, ResultSrcW, MemReadW;
    wire StallF, StallD, StallE, PipelineFlush;
    wire[2:0] ALUControlE, BranchE, BranchD;
    wire[4:0] RD_E, RD_M, RDW;
    wire[31:0] PCTargetE, InstrD, PCD, PCPlus4D, ResultW, RD1_E, RD2_E, ImmExtE, PCE, PCPlus4E, PCPlus4M, WriteDataM, ALU_ResultM;
    wire[31:0] PCPlus4W, ALU_ResultW, ReadDataW;
    wire[4:0] RS1_E, RS2_E;
    wire[1:0] ForwardBE, ForwardAE;


    FetchStage Fetch(.clk(clk),
                     .rst(rst),
                     .PCSrcE(PCSrcE),
                     .PCTargetE(PCTargetE),
                     .InstrD(InstrD),
                     .PCD(PCD),
                     .PCPlus4D(PCPlus4D),
                     .StallF(StallF),
                     .PipelineFlush(PipelineFlush));

    DecodeStage Decode(.clk(clk),
                       .rst(rst),
                       .InstrD(InstrD),
                       .PCD(PCD),
                       .PCPlus4D(PCPlus4D),
                       .RegWriteW(RegWriteW),
                       .RDW(RDW),
                       .ResultW(ResultW),
                       .RegWriteE(RegWriteE),
                       .ALUSrcE(ALUSrcE),
                       .MemWriteE(MemWriteE),
                       .MemReadE(MemReadE),
                       .ResultSrcE(ResultSrcE),
                       .BranchE(BranchE),
                       .BranchD(BranchD),
                       .ALUControlE(ALUControlE),
                       .RD1_E(RD1_E),
                       .RD2_E(RD2_E),
                       .ImmExtE(ImmExtE),
                       .RD_E(RD_E),
                       .PCE(PCE),
                       .PCPlus4E(PCPlus4E),
                       .RS1_E(RS1_E),
                       .RS2_E(RS2_E),
                       .StallD(StallD),
                       .PipelineFlush(PipelineFlush));

    ExecuteStage Execute(.clk(clk),
                         .rst(rst),
                         .RegWriteE(RegWriteE),
                         .ALUSrcE(ALUSrcE),
                         .MemWriteE(MemWriteE),
                         .MemReadE(MemReadE),
                         .ResultSrcE(ResultSrcE),
                         .BranchE(BranchE),
                         .ALUControlE(ALUControlE),
                         .RD1_E(RD1_E),
                         .RD2_E(RD2_E),
                         .ImmExtE(ImmExtE),
                         .RD_E(RD_E),
                         .PCE(PCE),
                         .PCPlus4E(PCPlus4E),
                         .PCSrcE(PCSrcE),
                         .PCTargetE(PCTargetE),
                         .RegWriteM(RegWriteM),
                         .MemWriteM(MemWriteM),
                         .MemReadM(MemReadM),
                         .ResultSrcM(ResultSrcM),
                         .RD_M(RD_M),
                         .PCPlus4M(PCPlus4M),
                         .WriteDataM(WriteDataM),
                         .ALU_ResultM(ALU_ResultM),
                         .ResultW(ResultW),
                         .ForwardA_E(ForwardAE),
                         .ForwardB_E(ForwardBE),
                         .StallE(StallE),
                         .PipelineFlush(PipelineFlush));
    
    MemoryStage Memory(.clk(clk),
                       .rst(rst),
                       .RegWriteM(RegWriteM),
                       .MemWriteM(MemWriteM),
                       .MemReadM(MemReadM),
                       .ResultSrcM(ResultSrcM),
                       .RD_M(RD_M),
                       .PCPlus4M(PCPlus4M),
                       .WriteDataM(WriteDataM),
                       .ALU_ResultM(ALU_ResultM),
                       .RegWriteW(RegWriteW),
                       .MemReadW(MemReadW),
                       .ResultSrcW(ResultSrcW),
                       .RD_W(RDW),
                       .PCPlus4W(PCPlus4W),
                       .ALU_ResultW(ALU_ResultW),
                       .ReadDataW(ReadDataW));

    WritebackStage Writeback(.clk(clk),
                             .rst(rst),
                             .ResultSrcW(ResultSrcW),
                             .PCPlus4W(PCPlus4W),
                             .ALU_ResultW(ALU_ResultW),
                             .ReadDataW(ReadDataW),
                             .ResultW(ResultW));

    HazardUnit HU(.rst(rst),
                  .RegWriteM(RegWriteM),
                  .RegWriteW(RegWriteW),
                  .MemReadM(MemReadM),
                  .MemReadW(MemReadW),
                  .Rd_M(RD_M),
                  .Rd_W(RDW),
                  .Rs1_E(RS1_E),
                  .Rs2_E(RS2_E),
                  .ForwardAE(ForwardAE),
                  .ForwardBE(ForwardBE),
                  .StallF(StallF),
                  .StallD(StallD),
                  .StallE(StallE),
                  .PCSrcE(PCSrcE),
                  .PipelineFlush(PipelineFlush));
endmodule
