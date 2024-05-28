module ALU(input[31:0] A,           output[31:0] Result,
           input[31:0] B,           output Zero,
           input[2:0] ALUControl,   output Negative);

    wire[31:0] Sum;

    assign Sum = (ALUControl[0] == 1'b0) ? A + B : (A + ((~B) + 1)) ;
    assign Result = (ALUControl == `ALU_CTRL_ADD) ? Sum :
                    (ALUControl == `ALU_CTRL_SUB) ? Sum :
                    (ALUControl == `ALU_CTRL_AND) ? A & B :
                    (ALUControl == `ALU_CTRL_OR)  ? A | B :
                    (ALUControl == `ALU_CTRL_SLT) ? {{31{1'b0}}, (Sum[31])} : {32{1'b0}};

    assign Zero = &(~Result);
    assign Negative = Result[31];

endmodule
