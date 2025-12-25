############################################################
# ELASTIC PIN PLACEMENT SCRIPT
# Automatically adjusts pin locations based on Die Size
############################################################

puts "\n=== Starting Elastic IO Placement ===\n"

# =========================================================
# 1. USER CONFIGURATION (CHANGE THIS TO RESIZE CHIP)
# =========================================================
# Set this to match your floorplan.tcl Die Area!
set die_size 2800.0 

# Margins: Keep pins away from the corners (usually 300um is safe)
set margin   300.0

# =========================================================
# 2. AUTOMATIC CALCULATIONS (DO NOT TOUCH)
# =========================================================
set min_pos $margin
set max_pos [expr {$die_size - $margin}]
set span    [expr {$max_pos - $min_pos}]

puts "   -> Die Size: $die_size"
puts "   -> Placement Range: $min_pos to $max_pos"
puts "   -> Active Span: $span"

# Setup Sites
make_io_sites -horizontal_site sg13g2_ioSite \
              -vertical_site   sg13g2_ioSite \
              -corner_site     sg13g2_ioSite \
              -offset 0

# =========================================================
# 3. WEST SIDE (Inputs) - 2 Pins
# =========================================================
# Spacing logic: Divide the span by (Pins + 1)
set w_count 2
set w_step  [expr {$span / ($w_count + 1)}]

# Pin 1
place_pad -master sg13g2_IOPadIn -row IO_WEST \
    -location [expr {$min_pos + 1 * $w_step}] \
    pad_clk

# Pin 2
place_pad -master sg13g2_IOPadIn -row IO_WEST \
    -location [expr {$min_pos + 2 * $w_step}] \
    pad_reset


# =========================================================
# 4. SOUTH SIDE (Outputs arr0 & arr1) - 8 Pins
# =========================================================
set s_count 8
set s_step  [expr {$span / ($s_count + 1)}]

# arr0 Group
place_pad -master sg13g2_IOPadOut16mA -row IO_SOUTH -location [expr {$min_pos + 1 * $s_step}] pad_arr0_0
place_pad -master sg13g2_IOPadOut16mA -row IO_SOUTH -location [expr {$min_pos + 2 * $s_step}] pad_arr0_1
place_pad -master sg13g2_IOPadOut16mA -row IO_SOUTH -location [expr {$min_pos + 3 * $s_step}] pad_arr0_2
place_pad -master sg13g2_IOPadOut16mA -row IO_SOUTH -location [expr {$min_pos + 4 * $s_step}] pad_arr0_3

# arr1 Group
place_pad -master sg13g2_IOPadOut16mA -row IO_SOUTH -location [expr {$min_pos + 5 * $s_step}] pad_arr1_0
place_pad -master sg13g2_IOPadOut16mA -row IO_SOUTH -location [expr {$min_pos + 6 * $s_step}] pad_arr1_1
place_pad -master sg13g2_IOPadOut16mA -row IO_SOUTH -location [expr {$min_pos + 7 * $s_step}] pad_arr1_2
place_pad -master sg13g2_IOPadOut16mA -row IO_SOUTH -location [expr {$min_pos + 8 * $s_step}] pad_arr1_3


# =========================================================
# 5. EAST SIDE (Outputs arr2 & arr3) - 8 Pins
# =========================================================
set e_count 8
set e_step  [expr {$span / ($e_count + 1)}]

# arr2 Group
place_pad -master sg13g2_IOPadOut16mA -row IO_EAST -location [expr {$min_pos + 1 * $e_step}] pad_arr2_0
place_pad -master sg13g2_IOPadOut16mA -row IO_EAST -location [expr {$min_pos + 2 * $e_step}] pad_arr2_1
place_pad -master sg13g2_IOPadOut16mA -row IO_EAST -location [expr {$min_pos + 3 * $e_step}] pad_arr2_2
place_pad -master sg13g2_IOPadOut16mA -row IO_EAST -location [expr {$min_pos + 4 * $e_step}] pad_arr2_3

# arr3 Group
place_pad -master sg13g2_IOPadOut16mA -row IO_EAST -location [expr {$min_pos + 5 * $e_step}] pad_arr3_0
place_pad -master sg13g2_IOPadOut16mA -row IO_EAST -location [expr {$min_pos + 6 * $e_step}] pad_arr3_1
place_pad -master sg13g2_IOPadOut16mA -row IO_EAST -location [expr {$min_pos + 7 * $e_step}] pad_arr3_2
place_pad -master sg13g2_IOPadOut16mA -row IO_EAST -location [expr {$min_pos + 8 * $e_step}] pad_arr3_3


# =========================================================
# 6. NORTH SIDE (Power Supply) - 8 Pins
# =========================================================
set n_count 8
set n_step  [expr {$span / ($n_count + 1)}]

# Pair 1: Core Power (VDD0/VSS0)
place_pad -master sg13g2_IOPadVdd -row IO_NORTH -location [expr {$min_pos + 1 * $n_step}] pad_vdd0
place_pad -master sg13g2_IOPadVss -row IO_NORTH -location [expr {$min_pos + 2 * $n_step}] pad_vss0

# Pair 2: Core Power (VDD1/VSS1)
place_pad -master sg13g2_IOPadVdd -row IO_NORTH -location [expr {$min_pos + 3 * $n_step}] pad_vdd1
place_pad -master sg13g2_IOPadVss -row IO_NORTH -location [expr {$min_pos + 4 * $n_step}] pad_vss1

# Pair 3: IO Power (VDDIO0/VSSIO0)
place_pad -master sg13g2_IOPadIOVdd -row IO_NORTH -location [expr {$min_pos + 5 * $n_step}] pad_vddio0
place_pad -master sg13g2_IOPadIOVss -row IO_NORTH -location [expr {$min_pos + 6 * $n_step}] pad_vssio0

# Pair 4: IO Power (VDDIO1/VSSIO1)
place_pad -master sg13g2_IOPadIOVdd -row IO_NORTH -location [expr {$min_pos + 7 * $n_step}] pad_vddio1
place_pad -master sg13g2_IOPadIOVss -row IO_NORTH -location [expr {$min_pos + 8 * $n_step}] pad_vssio1


# =========================================================
# 7. Finalize
# =========================================================
place_corners sg13g2_Corner

set fillers {
    sg13g2_Filler10000
    sg13g2_Filler4000
    sg13g2_Filler2000
    sg13g2_Filler1000
    sg13g2_Filler400
    sg13g2_Filler200
}
place_io_fill -row IO_NORTH {*}$fillers
place_io_fill -row IO_SOUTH {*}$fillers
place_io_fill -row IO_EAST  {*}$fillers
place_io_fill -row IO_WEST  {*}$fillers

connect_by_abutment
remove_io_rows

puts "\n✅ Elastic Pad Placement Done (Size: $die_size)\n"