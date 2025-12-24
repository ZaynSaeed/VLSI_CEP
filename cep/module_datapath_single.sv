module pipeline_proc(
    input  logic clk,
    input  logic reset,
    output logic [ 3:0] arr0, arr1, arr2, arr3
);

logic [31:0] pc_in, pc_out_f, IMEM_out_f, pc_out_de, IMEM_out_de, pcadder_out_f;
logic [31:0] badder_out, mux1_out, rd1_out, rd2_out_de, imm_out, ALU_out_de, pcadder_out_de;
logic [31:0] mux2_out, IMEM_out_mw, ALU_out_mw, rd2_out_mw, DMEM_out, pcadder_out_mw;

logic [1:0] ALUOp_out, mem2reg_out_de, mem2reg_out_mw;
logic [3:0] operation;
logic       branch_out, reg2ALU_out, memr_out_de, memw_out_de, we_out_de;
logic       memr_out_mw, memw_out_mw, we_out_mw;
logic       zero_out, less_out, branch_taken, flush, jump_out;

/* ----------------- { FLUSH } -----------------*/
always_comb begin
    if (branch_taken == 1'b1) begin
        flush = 1'b1;
    end
    else begin
        flush = 1'b0;
    end
end

/* ----------------- { DATAPATH } -----------------*/
//FETCH
PC      pc      (
                    .in     (pc_in),
                    .clk    (clk),
                    .reset  (reset),
                    .out    (pc_out_f)
                );

IMEM    imem    (
                    .addr   (pc_out_f),
                    .inst   (IMEM_out_f)
                );

adder1  pc_adder(
                    .pc     (pc_out_f),
                    .out    (pcadder_out_f)
                );

mux     mux3    (
                    .in1    (pcadder_out_f),
                    .in2    (badder_out),
                    .sel    (branch_taken),
                    .out    (pc_in)
                );

IF_ID   IF_ID   (   .clk    (clk),
                    .rst    (reset),
                    .instd  (IMEM_out_f),
                    .pcd    (pc_out_f),
                    .pc4d   (pcadder_out_f),
                    .instq  (IMEM_out_de),
                    .pcq    (pc_out_de),
                    .pc4q   (pcadder_out_de),
                    .flush  (flush)
                );

//DECODE & EXECUTE
regfile Regfile (
                    .clk    (clk),
                    .reset  (reset),
                    .rs1    (IMEM_out_de[19:15]),
                    .rs2    (IMEM_out_de[24:20]),
                    .we     (we_out_mw),
                    .wdata  (mux2_out),
                    .rd     (IMEM_out_mw[11:7]),
                    .rdata1 (rd1_out),
                    .rdata2 (rd2_out_de)
                );

imm_gen Imm_gen (
                    .inst   (IMEM_out_de[31:0]),
                    .imm    (imm_out)
                );

mux     mux1    (
                    .in1    (rd2_out_de),
                    .in2    (imm_out),
                    .sel    (reg2ALU_out),
                    .out    (mux1_out)
                );

ALU     alu     (
                    .in1    (rd1_out),
                    .in2    (mux1_out),
                    .alu_op (operation),
                    .out    (ALU_out_de),
                    .zero   (zero_out),
                    .less   (less_out)
               );

adder2  b_adder (
                    .pc     (pc_out_de),
                    .offset (imm_out),
                    .out    (badder_out)
                );

EX_MEM  EX_MEM  (   .clk    (clk),
                    .rst    (reset),
                    .alu_d  (ALU_out_de),
                    .rd2d   (rd2_out_de),
                    .pc4d   (pcadder_out_de),
                    .instd1 (IMEM_out_de),
                    .alu_q  (ALU_out_mw),
                    .rd2q   (rd2_out_mw),
                    .pc4q   (pcadder_out_mw),
                    .instq1 (IMEM_out_mw)
                );

//MEMORY & WRITEBACK
DMEM    dmem    (
                    .addr   (ALU_out_mw),
                    .wdata  (rd2_out_mw),
                    .memr   (memr_out_mw),
                    .memw   (memw_out_mw),
                    .clk    (clk),
                    .reset  (reset),
                    .rdata  (DMEM_out),
                    .arr0   (arr0), 
                    .arr1   (arr1), 
                    .arr2   (arr2), 
                    .arr3   (arr3)
                );

mux3x1  mux2    (
                    .in1    (DMEM_out),
                    .in2    (ALU_out_mw),
                    .in3    (pcadder_out_mw),
                    .sel    (mem2reg_out_mw),
                    .out    (mux2_out)
                );


/* ----------------- { CONTROL } -----------------*/

ctrl     control(
                    .inst       (IMEM_out_de[6:0]),
                    .ALU_op     (ALUOp_out),
                    .branch     (branch_out),
                    .memr       (memr_out_de),
                    .memw       (memw_out_de),
                    .mem_to_reg (mem2reg_out_de),
                    .we         (we_out_de),
                    .reg_to_ALU (reg2ALU_out),
                    .jump       (jump_out)
                );

ALU_ctrl ALU_ctl(
                    .ALUOp      (ALUOp_out),
                    .funct7     (IMEM_out_de[31:25]),
                    .funct3     (IMEM_out_de[14:12]),
                    .operation  (operation)
                );

AND_gate nd_gate(
                    .branch     (branch_out),
                    .zero       (zero_out),
                    .less       (less_out),
                    .jump       (jump_out),
                    .out        (branch_taken)
                );

M        M      (
                    .clk        (clk),
                    .rst        (reset),
                    .memrd      (memr_out_de),
                    .memwd      (memw_out_de),
                    .memrq      (memr_out_mw),
                    .memwq      (memw_out_mw)
                );

WB       WB     (
                    .clk        (clk),
                    .rst        (reset),
                    .mem2regd   (mem2reg_out_de),
                    .regwd      (we_out_de),
                    .mem2regq   (mem2reg_out_mw),
                    .regwq      (we_out_mw)
                );

endmodule



