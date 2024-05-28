module Mux(input[31:0] a,   output[31:0] c,
           input[31:0] b,
           input s);

    assign c = (~s) ? a : b;

endmodule

module Mux3(input[31:0] a,   output [31:0] d,
            input[31:0] b,
            input[31:0] c,
            input[1:0] s);

    assign d = (s == 2'b00) ? a :
               (s == 2'b01) ? b :
               (s == 2'b10) ? c : 32'h00000000;
endmodule
