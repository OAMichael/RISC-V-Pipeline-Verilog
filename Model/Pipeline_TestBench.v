`timescale 1ns/1ps

module Pipeline_TestBench();

    reg clk = 0, rst = 1;
    
    always begin
        clk = ~clk;
        #50;
    end

    initial begin
        rst <= 1'b1;
        #200;
        rst <= 1'b0;
        #1000000;
        $finish;
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0);
    end

    PipelineTop Pipeline(.clk(clk), .rst(rst));
endmodule
