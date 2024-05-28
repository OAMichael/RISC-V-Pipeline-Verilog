module FetchStage(input clk,               output[31:0] InstrD,
                  input rst,               output[31:0] PCD,
                  input PCSrcE,            output[31:0] PCPlus4D,
                  input[31:0] PCTargetE,
                  input StallF,
                  input PipelineFlush);

    wire[31:0] PC_F, PCF, PCPlus4F;
    wire[31:0] InstrF;

    reg[31:0] InstrF_r;
    reg[31:0] PCF_r, PCPlus4F_r;


    Mux PCMux(.a(PCPlus4F),
              .b(PCTargetE),
              .s(PCSrcE),
              .c(PC_F));

    PCModule ProgramCounter(.clk(clk),
                            .rst(rst),
                            .PC(PCF),
                            .PC_Next(PC_F),
                            .Stall(StallF));

    InstructionMemory IMEM(.rst(rst),
                           .A(PCF),
                           .D(InstrF));

    PCAdder PCIncrement(.a(PCF),
                        .b(`INSTRUCTION_BYTESIZE),
                        .c(PCPlus4F));


    always @ (posedge clk or negedge rst) begin
        if(rst == 1'b1 | PipelineFlush == 1'b1) begin
            InstrF_r <= 32'h00000000;
            PCF_r <= 32'h00000000;
            PCPlus4F_r <= 32'h00000000;
        end
        else if (StallF == 1'b0) begin
            InstrF_r <= InstrF;
            PCF_r <= PCF;
            PCPlus4F_r <= PCPlus4F;
        end
    end


    assign InstrD = rst ? 32'h00000000 : InstrF_r;
    assign PCD = rst ? 32'h00000000 : PCF_r;
    assign PCPlus4D = rst ? 32'h00000000 : PCPlus4F_r;

endmodule
