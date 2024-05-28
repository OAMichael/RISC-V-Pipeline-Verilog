`define IMEM_SIZE 65535
`define DMEM_SIZE 65535

`define INSTRUCTION_BYTESIZE 32'h00000004

`define OPCODE_LOAD         7'b0000011
`define OPCODE_STORE        7'b0100011
`define OPCODE_ARITHM       7'b0110011
`define OPCODE_ARITHM_IMM   7'b0010011
`define OPCODE_BRANCH       7'b1100011

`define BRANCH_TYPE_INVALID 3'b000
`define BRANCH_TYPE_BEQ     3'b001
`define BRANCH_TYPE_BNE     3'b010
`define BRANCH_TYPE_BLT     3'b011
`define BRANCH_TYPE_BGE     3'b100

`define FORWARD_SRC_REG     2'b00
`define FORWARD_SRC_WB      2'b01
`define FORWARD_SRC_MEM     2'b10

`define IMM_LAYOUT_ARITHM   2'b00
`define IMM_LAYOUT_STORE    2'b01
`define IMM_LAYOUT_BRANCH   2'b10

`define ALU_CTRL_ADD        3'b000
`define ALU_CTRL_SUB        3'b001
`define ALU_CTRL_AND        3'b010
`define ALU_CTRL_OR         3'b011
`define ALU_CTRL_SLT        3'b101  // Skip 100 for convenient ALU implementation

`define ALU_OP_DEFAULT      2'b00
`define ALU_OP_BRANCH       2'b01
`define ALU_OP_ARITHM       2'b10
