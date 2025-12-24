//-------------DMEM------------//

module DMEM
(
   input  logic [31:0] addr,
   input  logic [31:0] wdata,
   input  logic        clk, reset, memr, memw,
   output logic [31:0] rdata,
   output logic [ 3:0] arr0, arr1, arr2, arr3
);
   parameter logic [31:0] DMEM_BASE_ADDR = 32'h1000;
             logic [31:0] memory [0:1023]; 

   always_comb begin
      arr0                                       = memory[1015][3:0];
      arr1                                       = memory[1016][3:0];
      arr2                                       = memory[1017][3:0];
      arr3                                       = memory[1018][3:0];
   end

   always_comb begin
      if ((memr) && (addr >= DMEM_BASE_ADDR && addr < DMEM_BASE_ADDR + 4*1024)) begin      // checking if addr is > 0x1000 and within 4kB.
         rdata                                   = memory[((addr - DMEM_BASE_ADDR) >> 2)]; // mapping 0x1000 to 0 .. 0x1004 to 1.. etc
      end
   end

   always_ff @(posedge clk) begin
      if (reset) begin                                                                      // hardcoded the array
         memory[0]                               = 32'h4;
         memory[1]                               = 32'h2;
         memory[2]                               = 32'h1;
         memory[3]                               = 32'h3;
      end

      else if ((memw) && (addr >= DMEM_BASE_ADDR && addr < DMEM_BASE_ADDR + 4*1024)) begin
         memory[((addr - DMEM_BASE_ADDR) >> 2)] <= wdata;
      end
      
   end
endmodule
