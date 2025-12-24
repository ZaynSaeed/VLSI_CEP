module M (
    input  var logic        clk,
    input  var logic        rst,
    input  var logic        memrd,
    input  var logic        memwd,
    output var logic        memrq,
    output var logic        memwq
);
    always_ff @(posedge clk) begin
        if (rst)begin 
            memrq   <= 1'b0;
            memwq   <= 1'b0;
        end
        else begin
            memrq   <= memrd;
            memwq   <= memwd;
        end
    end
endmodule