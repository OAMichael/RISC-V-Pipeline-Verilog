module MainDecoder(input[6:0] Op,      output RegWrite,
                   input[2:0] funct3,  output MemWrite,
                                       output MemRead,
                                       output ALUSrc,
                                       output ResultSrc,
                                       output[2:0] Branch,
                                       output[1:0] ImmSrc,
                                       output[1:0] ALUOp);

    assign RegWrite = (Op == `OPCODE_LOAD | Op == `OPCODE_ARITHM | Op == `OPCODE_ARITHM_IMM) ? 1'b1 : 1'b0;
    assign MemWrite = (Op == `OPCODE_STORE) ? 1'b1 : 1'b0;
    assign MemRead = (Op == `OPCODE_LOAD) ? 1'b1 : 1'b0;

    assign ALUSrc = (Op == `OPCODE_LOAD | Op == `OPCODE_STORE | Op == `OPCODE_ARITHM_IMM) ? 1'b1 : 1'b0;
    assign ResultSrc = (Op == `OPCODE_LOAD) ? 1'b1 : 1'b0;
    assign Branch = (Op == `OPCODE_BRANCH) ? ((funct3 == 3'b000) ? `BRANCH_TYPE_BEQ :
                                              (funct3 == 3'b001) ? `BRANCH_TYPE_BNE :
                                              (funct3 == 3'b100) ? `BRANCH_TYPE_BLT :
                                              (funct3 == 3'b101) ? `BRANCH_TYPE_BGE :
                                                                   `BRANCH_TYPE_INVALID) : `BRANCH_TYPE_INVALID;

    assign ImmSrc = (Op == `OPCODE_STORE) ? `IMM_LAYOUT_STORE :
                    (Op == `OPCODE_BRANCH) ? `IMM_LAYOUT_BRANCH : `IMM_LAYOUT_ARITHM;

    assign ALUOp = (Op == `OPCODE_ARITHM | Op == `OPCODE_ARITHM_IMM) ? `ALU_OP_ARITHM :
                   (Op == `OPCODE_BRANCH) ? `ALU_OP_BRANCH : `ALU_OP_DEFAULT;

endmodule
