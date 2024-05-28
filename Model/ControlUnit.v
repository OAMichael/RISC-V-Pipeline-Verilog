`include "ALUDecoder.v"
`include "MainDecoder.v"

module ControlUnit(input[6:0] Op,      output RegWrite,
                   input[2:0] funct3,  output MemWrite,
                   input[6:0] funct7,  output MemRead,
                                       output ALUSrc,
                                       output ResultSrc,
                                       output[2:0] Branch,
                                       output[2:0] ALUControl,
                                       output[1:0] ImmSrc);

    wire[1:0] ALUOp;

    MainDecoder MainDecoder(.Op(Op),
                            .RegWrite(RegWrite),
                            .ImmSrc(ImmSrc),
                            .MemWrite(MemWrite),
                            .MemRead(MemRead),
                            .ResultSrc(ResultSrc),
                            .Branch(Branch),
                            .ALUSrc(ALUSrc),
                            .ALUOp(ALUOp),
                            .funct3(funct3));

    ALUDecoder ALUDecoder(.ALUOp(ALUOp),
                          .funct3(funct3),
                          .funct7(funct7),
                          .op(Op),
                          .ALUControl(ALUControl));

endmodule
