module pipeline_proc_FPGA(
    input  logic clk,
    input  logic reset1,
    input  logic reset,
    output logic an0, an1, an2, an3, an4, an5, an6, an7,
    output logic segA, segB, segC, segD, segE, segF, segG
);

logic clk100Hz, clk1Hz;
logic [ 3:0] arr0, arr1, arr2, arr3;
logic [ 7:0] countq_clk, countd_clk;
logic        count_en_clk;
logic [ 3:0] array;
logic [ 2:0] count_d, count_q;

logic [ 6:0] alpha_num;
logic [ 7:0] an_select;

clk_delay      tff  (
    .clk     (clk),
    .reset   (reset1),
    .clk_out (clk100Hz) //for alphanumeric
);

clk_delay_proc tff1 (
    .clk     (clk),
    .reset   (reset1),
    .clk_out (clk1Hz) //for processor
);

pipeline_proc   dut (
    .clk     (clk1Hz),
    .reset   (reset),
    .arr0    (arr0), 
    .arr1    (arr1), 
    .arr2    (arr2), 
    .arr3    (arr3)
);

//COUNTER
always_comb count_d = count_q + 1;
always_ff@(posedge clk100Hz)
begin
    if (reset) begin
        count_q     <= 0;
    end
    else begin
        if (count_q == 2'd3) begin
            count_q <= 0;
        end
        count_q     <= count_d;
    end
end

//MUX1
always_comb begin
    case (count_q)
        3'b000:array       = arr0; //1
        3'b001:array       = arr1; //2
        3'b010:array       = arr2; //3
        3'b011:array       = arr3; //4
        3'b110:array       = countq_clk[3:0]; //7
        3'b111:array       = countq_clk[7:4]; //8

        default: array     = 4'bxxxx;
    endcase
end

//DECODER FOR CATHODE
always_comb
begin
    segA                   = alpha_num[6];
    segB                   = alpha_num[5];
    segC                   = alpha_num[4];
    segD                   = alpha_num[3];
    segE                   = alpha_num[2];
    segF                   = alpha_num[1];
    segG                   = alpha_num[0];
end

always_comb begin
    case (array)
        4'b0000: alpha_num = 7'b0000001;
        4'b0001: alpha_num = 7'b1001111;
        4'b0010: alpha_num = 7'b0010010;
        4'b0011: alpha_num = 7'b0000110;
        4'b0100: alpha_num = 7'b1001100;
        4'b0101: alpha_num = 7'b0100100;
        4'b0110: alpha_num = 7'b0100000;
        4'b0111: alpha_num = 7'b0001111;
        4'b1000: alpha_num = 7'b0000000;
        4'b1001: alpha_num = 7'b0000100;
        4'b1010: alpha_num = 7'b0001000;
        4'b1011: alpha_num = 7'b1100000;
        4'b1100: alpha_num = 7'b0110001;
        4'b1101: alpha_num = 7'b1000010;
        4'b1110: alpha_num = 7'b0110000;
        4'b1111: alpha_num = 7'b0111000;
    endcase
end

//DECODER FOR ANODE
always_comb
begin
    an0                    = an_select[7];
    an1                    = an_select[6];
    an2                    = an_select[5];
    an3                    = an_select[4];
    an4                    = an_select[3];
    an5                    = an_select[2];
    an6                    = an_select[1];
    an7                    = an_select[0];
end

always_comb begin
    case (count_q)
        3'b000: an_select  = 8'b01111111;
        3'b001: an_select  = 8'b10111111;
        3'b010: an_select  = 8'b11011111;
        3'b011: an_select  = 8'b11101111;
        3'b110: an_select  = 8'b11111101;
        3'b111: an_select  = 8'b11111110;
        default: an_select = 8'b11111111;
    endcase
end

//TO COUNT CLK CYCLES
//COUNTER
always_comb countd_clk = countq_clk + 1;
always_ff@(posedge clk1Hz) 
begin
    if (reset) begin
        countq_clk     <= 0;
    end
    else if (count_en_clk) begin
        countq_clk     <= countd_clk;
    end
end

//LOGIC TO STOP COUNTING WHEN SORTING IS DONE
always_comb begin
    if (reset) begin
        count_en_clk   = 1'b1;
    end
    else if ((arr0 == 4'd1) && (arr1 == 4'd2) && (arr2 == 4'd3) && (arr3 == 4'd4)) begin
        count_en_clk   = 1'b0;
    end
end
endmodule