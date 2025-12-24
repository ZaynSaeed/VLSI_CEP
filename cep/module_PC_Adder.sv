//------------ADDER1------------//

module adder1
(
   input  logic [31:0] pc,
   output logic [31:0] out
);

always_comb begin
   out = pc + 32'd4; 
end
endmodule