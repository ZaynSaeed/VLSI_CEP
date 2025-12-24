//------------IMEM------------//

module IMEM
(
   input  logic [31:0] addr,
   output logic [31:0] inst
);

logic [31:0] memory [1000:0];  

   always_comb begin
      memory[0]  = 32'hfe010113;
      memory[1]  = 32'h00112e23;
      memory[2]  = 32'h00812c23;
      memory[3]  = 32'h02010413;
      memory[4]  = 32'h000017b7;
      memory[5]  = 32'h00078793;
      memory[6]  = 32'h0007a603;
      memory[7]  = 32'h0047a683;
      memory[8]  = 32'h0087a703;
      memory[9]  = 32'h00c7a783;
      memory[10] = 32'hfec42023;
      memory[11] = 32'hfed42223;
      memory[12] = 32'hfee42423;
      memory[13] = 32'hfef42623;
      memory[14] = 32'hfe040793;
      memory[15] = 32'h00400593;
      memory[16] = 32'h00078513;
      memory[17] = 32'h01c000ef;
      memory[18] = 32'h00000793;
      memory[19] = 32'h00078513;
      memory[20] = 32'h01c12083;
      memory[21] = 32'h01812403;
      memory[22] = 32'h02010113;
      memory[23] = 32'h00008067;
      memory[24] = 32'hfd010113;
      memory[25] = 32'h02812623;
      memory[26] = 32'h03010413;
      memory[27] = 32'hfca42e23;
      memory[28] = 32'hfcb42c23;
      memory[29] = 32'h00100793;
      memory[30] = 32'hfef42623;
      memory[31] = 32'h0b00006f;
      memory[32] = 32'hfec42783;
      memory[33] = 32'h00279793;
      memory[34] = 32'hfdc42703;
      memory[35] = 32'h00f707b3;
      memory[36] = 32'h0007a783;
      memory[37] = 32'hfef42223;
      memory[38] = 32'hfec42783;
      memory[39] = 32'hfff78793;
      memory[40] = 32'hfef42423;
      memory[41] = 32'h03c0006f;
      memory[42] = 32'hfe842783;
      memory[43] = 32'h00279793;
      memory[44] = 32'hfdc42703;
      memory[45] = 32'h00f70733;
      memory[46] = 32'hfe842783;
      memory[47] = 32'h00178793;
      memory[48] = 32'h00279793;
      memory[49] = 32'hfdc42683;
      memory[50] = 32'h00f687b3;
      memory[51] = 32'h00072703;
      memory[52] = 32'h00e7a023;
      memory[53] = 32'hfe842783;
      memory[54] = 32'hfff78793;
      memory[55] = 32'hfef42423;
      memory[56] = 32'hfe842783;
      memory[57] = 32'h0207c063;
      memory[58] = 32'hfe842783;
      memory[59] = 32'h00279793;
      memory[60] = 32'hfdc42703;
      memory[61] = 32'h00f707b3;
      memory[62] = 32'h0007a783;
      memory[63] = 32'hfe442703;
      memory[64] = 32'hfaf744e3;
      memory[65] = 32'hfe842783;
      memory[66] = 32'h00178793;
      memory[67] = 32'h00279793;
      memory[68] = 32'hfdc42703;
      memory[69] = 32'h00f707b3;
      memory[70] = 32'hfe442703;
      memory[71] = 32'h00e7a023;
      memory[72] = 32'hfec42783;
      memory[73] = 32'h00178793;
      memory[74] = 32'hfef42623;
      memory[75] = 32'hfec42703;
      memory[76] = 32'hfd842783;
      memory[77] = 32'hf4f746e3;
      memory[78] = 32'h00000013;
      memory[79] = 32'h00000013;
      memory[80] = 32'h02c12403;
      memory[81] = 32'h03010113;
      memory[82] = 32'h00008067;

   end
   always_comb begin
      inst       = memory[addr/4]; // Assuming addr is word-aligned
   end
endmodule