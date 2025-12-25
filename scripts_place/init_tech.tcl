# Initialize the PDK (IHP SG13G2) – Corrected for /foss/pdks installation

utl::report "Init tech for IHP SG13G2 (corrected paths)"

# --- Correct PDK directory root ---
set pdk_dir "/foss/pdks/ihp-sg13g2"

# --- Standard cell paths ---
set pdk_cells_lib ${pdk_dir}/libs.ref/sg13g2_stdcell/lib
set pdk_cells_lef ${pdk_dir}/libs.ref/sg13g2_stdcell/lef

# --- SRAM paths ---
set pdk_sram_lib ${pdk_dir}/libs.ref/sg13g2_sram/lib
set pdk_sram_lef ${pdk_dir}/libs.ref/sg13g2_sram/lef

# --- IO pad paths ---
set pdk_io_lib ${pdk_dir}/libs.ref/sg13g2_io/lib
set pdk_io_lef ${pdk_dir}/libs.ref/sg13g2_io/lef

# --- Bond pad (UPDATED to your FIR directory) ---
set pdk_pad_lef /foss/designs/FIR/bondpad/lef

# --- Liberty corners ---
define_corners tt ff

puts "Init standard cells"
read_liberty -corner tt ${pdk_cells_lib}/sg13g2_stdcell_typ_1p20V_25C.lib
read_liberty -corner ff ${pdk_cells_lib}/sg13g2_stdcell_fast_1p32V_m40C.lib

puts "Init IO cells"
read_liberty -corner tt ${pdk_io_lib}/sg13g2_io_typ_1p2V_3p3V_25C.lib
read_liberty -corner ff ${pdk_io_lib}/sg13g2_io_fast_1p32V_3p6V_m40C.lib

puts "Init SRAM macros"
read_liberty -corner tt ${pdk_sram_lib}/RM_IHPSG13_1P_256x64_c2_bm_bist_typ_1p20V_25C.lib
read_liberty -corner ff ${pdk_sram_lib}/RM_IHPSG13_1P_256x64_c2_bm_bist_fast_1p32V_m55C.lib

puts "Init tech LEF"
read_lef ${pdk_cells_lef}/sg13g2_tech.lef

puts "Init cell LEF"
read_lef ${pdk_cells_lef}/sg13g2_stdcell.lef

puts "Init IO LEF"
read_lef ${pdk_io_lef}/sg13g2_io.lef

puts "Init Bond Pad LEF"
read_lef ${pdk_pad_lef}/bondpad_70x70.lef

puts "Init SRAM LEF"
read_lef ${pdk_sram_lef}/RM_IHPSG13_1P_256x64_c2_bm_bist.lef

# --- CTS / Filler definitions ---
set ctsBuf [list sg13g2_buf_16 sg13g2_buf_8 sg13g2_buf_4 sg13g2_buf_2]
set ctsBufRoot sg13g2_buf_8

set stdfill [list sg13g2_fill_8 sg13g2_fill_4 sg13g2_fill_2 sg13g2_fill_1]

set iocorner sg13g2_Corner
set iofill [list sg13g2_Filler10000 sg13g2_Filler4000 sg13g2_Filler2000 sg13g2_Filler1000 sg13g2_Filler400 sg13g2_Filler200]

# Repair timing should not use IO pads as buffers
set dont_use_cells sg13g2_IOPad*

# --- Metal tracks ---
proc makeTracks {} {
    utl::report "Metal Tracks"
    make_tracks Metal1    -x_offset 0 -x_pitch 0.48 -y_offset 0 -y_pitch 0.48
    make_tracks Metal2    -x_offset 0 -x_pitch 0.42 -y_offset 0 -y_pitch 0.42
    make_tracks Metal3    -x_offset 0 -x_pitch 0.48 -y_offset 0 -y_pitch 0.48
    make_tracks Metal4    -x_offset 0 -x_pitch 0.42 -y_offset 0 -y_pitch 0.42
    make_tracks Metal5    -x_offset 0 -x_pitch 0.48 -y_offset 0 -y_pitch 0.48
    make_tracks TopMetal1 -x_offset 1.46 -x_pitch 2.28 -y_offset 1.46 -y_pitch 2.28
    make_tracks TopMetal2 -x_offset 2.00 -x_pitch 4.00 -y_offset 2.00 -y_pitch 4.00
}
