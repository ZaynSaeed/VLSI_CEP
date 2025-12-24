//------------MUX------------//

module mux
(
   input  logic [31:0] in1,
   input  logic [31:0] in2,
   input  logic        sel,
   output logic [31:0] out
);
always_comb begin

   if (sel) begin
      out = in2;
   end
   
   else begin
      out = in1;
   end

end
endmodule