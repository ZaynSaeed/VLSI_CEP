module EX_MEM (
    input  var logic        clk,
    input  var logic        rst,
    input  var logic [31:0] alu_d,
    input  var logic [31:0] rd2d,
    input  var logic [31:0] pc4d,
    input  var logic [31:0] instd1,
    output var logic [31:0] alu_q,
    output var logic [31:0] rd2q,
    output var logic [31:0] pc4q,
    output var logic [31:0] instq1
);
    always_ff @(posedge clk) begin
        if (rst) begin 
            alu_q       <= 32'b0;
            rd2q        <= 32'b0;
            instq1      <= 32'b0;
            pc4q        <= 32'b0;
        end
        else begin
            alu_q       <= alu_d;
            rd2q        <= rd2d;
            pc4q        <= pc4d;
            instq1      <= instd1;
        end
    end
endmodule