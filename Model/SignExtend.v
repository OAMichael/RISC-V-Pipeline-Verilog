module SignExtend(input[31:0] In,  output[31:0] ImmExt,
                  input[1:0] ImmSrc);

    assign ImmExt = (ImmSrc == `IMM_LAYOUT_ARITHM) ? {{20{In[31]}}, In[31:20]} :
                    (ImmSrc == `IMM_LAYOUT_STORE) ? {{20{In[31]}}, In[31:25], In[11:7]} :
                    (ImmSrc == `IMM_LAYOUT_BRANCH) ? {{20{In[31]}}, In[7], In[30:25], In[11:8], 1'b0} : 32'h00000000;

endmodule
