module WB (
    input  var logic        clk,
    input  var logic        rst,
    input  var logic  [1:0] mem2regd,
    input  var logic        regwd,
    output var logic  [1:0] mem2regq,
    output var logic        regwq
);
    always_ff @(posedge clk) begin
        if (rst)begin 
            mem2regq <= 2'b00;
            regwq    <= 1'b0;
        end
        else begin
            mem2regq <= mem2regd;
            regwq    <= regwd;
        end
    end
endmodule