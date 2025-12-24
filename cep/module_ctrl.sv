module ctrl
(
    input  logic [6:0] inst,
    output logic [1:0] ALU_op,
    output logic       branch,
    output logic       memr,        
    output logic       memw,
    output logic [1:0] mem_to_reg,
    output logic       we,
    output logic       reg_to_ALU,
    output logic       jump  
);

always_comb begin
    
        if ( inst == 7'b0110011) begin // add(R-type)
            ALU_op = 2'b10;
            branch = 1'b0;
            memr = 1'b0;
            memw = 1'b0;
            mem_to_reg = 2'b01;
            we = 1'b1;
            reg_to_ALU = 1'b0;
            jump = 1'b0;
        end

        else if ( inst == 7'b0000011) begin // load(I-type)
            ALU_op = 2'b00;
            branch = 1'b0;
            memr = 1'b1;
            memw = 1'b0;
            mem_to_reg = 2'b00;
            we = 1'b1;
            reg_to_ALU = 1'b1;
            jump = 1'b0;
        end
        
        else if ( inst == 7'b0010011) begin // add_immediate(I-type)
            ALU_op = 2'b10;
            branch = 1'b0;
            memr = 1'b0;
            memw = 1'b0;
            mem_to_reg = 2'b01;
            we = 1'b1;
            reg_to_ALU = 1'b1;
            jump = 1'b0;
        end
        
        else if ( inst == 7'b0100011) begin // store(S-type)
            ALU_op = 2'b00;
            branch = 1'b0;
            memr = 1'b0;
            memw = 1'b1;
            mem_to_reg = 2'b01;
            we = 1'b0;
            reg_to_ALU = 1'b1;
            jump = 1'b0;
        end

        else if ( inst == 7'b1100011) begin // branch(B-type)
            ALU_op = 2'b01; 
            branch = 1'b1;
            memr = 1'b0;
            memw = 1'b0;
            mem_to_reg = 2'b01;
            we = 1'b0;
            reg_to_ALU = 1'b0;
            jump = 1'b0;
        end

        else if ( inst == 7'b0110111) begin // Upper imm(U-type)
            ALU_op = 2'b11; 
            branch = 1'b0;
            memr = 1'b0;
            memw = 1'b0;
            mem_to_reg = 2'b01;
            we = 1'b1;
            reg_to_ALU = 1'b1;
            jump = 1'b0;
        end

        else if ( inst == 7'b1101111) begin // jump(J-type)
            ALU_op = 2'b01;
            branch = 1'b0;
            memr = 1'b0;
            memw = 1'b0;
            mem_to_reg = 2'b10; //PC + 4
            we = 1'b1;
            reg_to_ALU = 1'b0;
            jump = 1'b1;
        end

        else begin
            ALU_op = 2'b00; 
            branch = 1'b0;
            memr = 1'b0;
            memw = 1'b0;
            mem_to_reg = 2'b00;
            we = 1'b0;
            reg_to_ALU = 1'b0;
            jump = 1'b0;
        end
end
endmodule