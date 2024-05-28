module WritebackStage(input clk,   output[31:0] ResultW,
                      input rst,
                      input ResultSrcW,
                      input[31:0] PCPlus4W,
                      input[31:0] ALU_ResultW,
                      input[31:0] ReadDataW);

    Mux FinalMux(.a(ALU_ResultW),
                 .b(ReadDataW),
                 .s(ResultSrcW),
                 .c(ResultW));

endmodule
