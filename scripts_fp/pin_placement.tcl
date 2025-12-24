#PIN PLACEMENT 1st one

#docker cp pin_placement.tcl iic-osic-tools_shell_uid_0:/foss/designs/CEP/scripts_fp

puts "\n=== Starting IO / Pad Placement ===\n"
make_io_sites \
    -horizontal_site sg13g2_ioSite \
    -vertical_site   sg13g2_ioSite \
    -corner_site     sg13g2_ioSite \
    -offset 0
set chipW 1760.0
set chipH 1760.0

# IO row safe limits (DO NOT CHANGE)
set rowMin 180
set rowMax 1580
set left_pads {pad_clk pad_rst}

set n_left [llength $left_pads]
set pitch_left [expr {($rowMax - $rowMin)/($n_left + 1)}]

for {set i 0} {$i < $n_left} {incr i} {
    set y [expr {$rowMin + ($i+1)*$pitch_left}]
    place_pad -master sg13g2_IOPadIn \
        -row IO_WEST \
        -location $y \
        [lindex $left_pads $i]
}

set bottom_outputs {}
for {set i 0} {$i < 16} {incr i} {
    lappend bottom_outputs pad_out$i
}

set n_bot [llength $bottom_outputs]
set pitch_bot [expr {($chipW - 360)/($n_bot + 1)}]

for {set i 0} {$i < $n_bot} {incr i} {
    set x [expr {180 + ($i+1)*$pitch_bot}]
    place_pad -master sg13g2_IOPadOut16mA \
        -row IO_SOUTH \
        -location $x \
        [lindex $bottom_outputs $i]
}
set right_outputs {}
for {set i 16} {$i < 32} {incr i} {
    lappend right_outputs pad_out$i
}

set n_right [llength $right_outputs]
set pitch_right [expr {($rowMax - $rowMin)/($n_right + 1)}]

for {set i 0} {$i < $n_right} {incr i} {
    set y [expr {$rowMin + ($i+1)*$pitch_right}]
    place_pad -master sg13g2_IOPadOut16mA \
        -row IO_EAST \
        -location $y \
        [lindex $right_outputs $i]
}
set top_pads {
    pad_vdd0 pad_vss0
    pad_vdd1 pad_vss1
    pad_vddio0 pad_vssio0
    pad_vddio1 pad_vssio1
}

set n_top [llength $top_pads]
set pitch_top [expr {($chipW - 360)/($n_top + 1)}]

for {set i 0} {$i < $n_top} {incr i} {
    set x [expr {180 + ($i+1)*$pitch_top}]
    place_pad -master [expr {[string match *vdd* [lindex $top_pads $i]] ? "sg13g2_IOPadIOVdd" : "sg13g2_IOPadIOVss"}] \
        -row IO_NORTH \
        -location $x \
        [lindex $top_pads $i]
}

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

puts "\n✅ IO / Pad Placement Completed Successfully\n"



