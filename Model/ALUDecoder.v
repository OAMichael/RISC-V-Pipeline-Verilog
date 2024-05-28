module ALUDecoder(input[1:0] ALUOp,    output[2:0] ALUControl,
                  input[2:0] funct3,
                  input[6:0] funct7,
                  input[6:0] op);

    assign ALUControl = (ALUOp == `ALU_OP_DEFAULT) ? `ALU_CTRL_ADD :
                        (ALUOp == `ALU_OP_BRANCH) ? `ALU_CTRL_SUB :
                       ((ALUOp == `ALU_OP_ARITHM) & (funct3 == 3'b000) & ({op[5], funct7[5]} == 2'b11)) ? `ALU_CTRL_SUB :
                       ((ALUOp == `ALU_OP_ARITHM) & (funct3 == 3'b000) & ({op[5], funct7[5]} != 2'b11)) ? `ALU_CTRL_ADD :
                       ((ALUOp == `ALU_OP_ARITHM) & (funct3 == 3'b010)) ? `ALU_CTRL_SLT :
                       ((ALUOp == `ALU_OP_ARITHM) & (funct3 == 3'b110)) ? `ALU_CTRL_OR :
                       ((ALUOp == `ALU_OP_ARITHM) & (funct3 == 3'b111)) ? `ALU_CTRL_AND : `ALU_CTRL_ADD ;
endmodule
