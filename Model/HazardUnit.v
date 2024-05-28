module HazardUnit(input rst,       output[1:0] ForwardAE,
                  input RegWriteM, output[1:0] ForwardBE,
                  input RegWriteW, output StallF,
                  input MemReadM,  output StallD,
                  input[4:0] Rd_M, output StallE,
                  input[4:0] Rd_W, output PipelineFlush,
                  input[4:0] Rs1_E,
                  input[4:0] Rs2_E,
                  input PCSrcE,
                  input MemReadW);

    assign ForwardAE = rst ? 2'b00 :
                       ((RegWriteW == 1'b1) & (Rd_W != 5'h00) & (Rd_W == Rs1_E)) ? `FORWARD_SRC_WB :
                       ((RegWriteM == 1'b1) & (Rd_M != 5'h00) & (Rd_M == Rs1_E)) ? `FORWARD_SRC_MEM : `FORWARD_SRC_REG;
                       
    assign ForwardBE = rst ? 2'b00 :
                       ((RegWriteW == 1'b1) & (Rd_W != 5'h00) & (Rd_W == Rs2_E)) ? `FORWARD_SRC_WB :
                       ((RegWriteM == 1'b1) & (Rd_M != 5'h00) & (Rd_M == Rs2_E)) ? `FORWARD_SRC_MEM : `FORWARD_SRC_REG;

    assign StallE = rst ? 1'b0 :
                    ((MemReadW == 1'b1) & (Rd_W != 5'h00) & ((Rd_W == Rs1_E) | (Rd_W == Rs2_E))) ? 1'b0 :
                    ((MemReadM == 1'b1) & (Rd_M != 5'h00) & ((Rd_M == Rs1_E) | (Rd_M == Rs2_E))) ? 1'b1 : 1'b0;

    assign StallD = StallE;
    assign StallF = StallD;

    assign PipelineFlush = PCSrcE;

endmodule
