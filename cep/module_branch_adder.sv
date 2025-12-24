//------------ADDER2------------//

module adder2
(
   input  logic  [31:0] pc,  
   input  logic  [31:0] offset,
   output logic  [31:0] out
);

always_comb begin
   out = pc + offset; 
end
endmodule