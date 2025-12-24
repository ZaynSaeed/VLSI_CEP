//------------REGFILE------------//

module regfile
(
   input  logic [4 :0]  rs1,
   input  logic [4 :0]  rs2,
   input  logic [4 :0]  rd,
   input  logic [31:0]  wdata,
   input  logic         we, clk, reset,
   output logic [31:0]  rdata1,
   output logic [31:0]  rdata2
);

logic [31:0] registers [31:0];

always_comb begin
   rdata1 = registers[rs1];
   rdata2 = registers[rs2];
end

always_ff @(negedge clk) begin
   if (reset) begin
      registers[2] = 32'h1fff; //sp initialized at 0x1fff
   end

   else if (rd != 5'b0) begin
      if (we) begin
      registers[rd] <= wdata;
      end
   end

   registers[0] <= 32'b0; 
end

endmodule