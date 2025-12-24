//------------ALU------------//

module ALU
(
   input  logic [31:0] in1,
   input  logic [31:0] in2,
   input  logic [3 :0] alu_op,
   output logic [31:0] out,
   output logic        zero,
   output logic        less
);

    always_comb begin
        zero = 1'b0;
        case(alu_op)
            4'b0000 : out = in1 & in2;
            4'b0001 : out = in1 | in2;
            4'b0010 : out = in1 + in2;
            4'b0011 : out = in1 << in2;
            4'b0110 : out = in1 - in2;
            4'b1000 : out = in2;
        endcase
/*
        if ((alu_op == 4'b0110) & (out == 32'd0)) begin //zero flag LOGIC
            zero = 1'b1;
        end
        else begin
            zero = 1'b0;
        end
*/
        if ((alu_op == 4'b0110) & (out[31] == 1'd1)) begin //less than flag LOGIC
            less = 1'b1;
        end
        else begin
            less = 1'b0;
        end
    end

endmodule