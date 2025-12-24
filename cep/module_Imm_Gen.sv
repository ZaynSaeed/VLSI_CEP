//q5

//------------IMM_GEN------------//

module imm_gen
(
   input  logic [31:0] inst,
   output logic [31:0] imm
);

always_comb begin

   if (inst[6:0] == 7'b0000011 || inst[6:0] == 7'b0010011) begin
      imm = { { 20{ inst[31] } } , inst[31:20] }; // I-Type (load)
   end
    
   else if (inst[6:0] == 7'b0100011) begin
      imm = { { 20{ inst[31] } } , inst[31:25] , inst[11:7] }; // S-Type (store)
   end

   else if (inst[6:0] == 7'b1100011) begin
      imm = { { 19{ inst[31] } } , inst[31] , inst[7] , inst[30:25] , inst[11:8], 1'b0}; // B-Type (branch)
   end

   else if (inst[6:0] == 7'b1101111) begin
      imm = { { 11{ inst[31] } } , inst[31] , inst[19:12] , inst[20] , inst[30:21], 1'b0}; // J-Type (jump)
   end

   else if (inst[6:0] == 7'b0110111) begin
      imm = { inst[31:12], { 12{ 1'b0 } } }; // U-Type (Upper imm)
   end

   else begin
      imm = 32'b0;
   end

end
endmodule