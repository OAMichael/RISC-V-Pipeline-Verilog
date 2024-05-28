module InstructionMemory(input rst,    output[31:0] D,
                         input[31:0] A);

  reg[31:0] Memory[`IMEM_SIZE:0];
  
  assign D = rst ? {32{1'b0}} : Memory[A[17:2]];

  // initial begin
  //     $readmemh("SampleProgram.hex", Memory);
  // end

endmodule
