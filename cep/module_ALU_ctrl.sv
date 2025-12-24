module ALU_ctrl (
    input logic [1:0] ALUOp,
    input logic [6:0] funct7,
    input logic [2:0] funct3,   
    output logic [3:0] operation
);

always_comb begin
    if       (ALUOp    == 2'b00) begin
        operation = 4'b0010; // Load/Store operations (ADD)
    end
    else if  (ALUOp    == 2'b11) begin
        operation = 4'b1000; // Pass U-imm (LUI)
    end
    else if  (ALUOp[0] == 1'b1 ) begin
        operation = 4'b0110; // Branch operations (SUB)
    end
    else if ((ALUOp[1] == 1'b1) && (funct7 == 7'b0000000) && (funct3 == 3'b001)) begin
        operation = 4'b0011; // LEFT SHIFT
    end
    else if ((ALUOp[1] == 1'b1) && (funct7 == 7'b0000000) && (funct3 == 3'b000)) begin
        operation = 4'b0010; // ADD
    end
    else if ((ALUOp[1] == 1'b1) && (funct7 == 7'b0100000) && (funct3 == 3'b000)) begin
        operation = 4'b0110; // SUB
    end
    else if ((ALUOp[1] == 1'b1) && (funct7 == 7'b0000000) && (funct3 == 3'b111)) begin
        operation = 4'b0000; // AND
    end
    else if ((ALUOp[1] == 1'b1) && (funct7 == 7'b0000000) && (funct3 == 3'b110)) begin
        operation = 4'b0001; // OR
    end
end
endmodule



    
     