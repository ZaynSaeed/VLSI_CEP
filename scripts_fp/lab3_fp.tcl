############################################################
# Floorplan + PDN + Checkpoint Save Script for FIR_Chip
# Fully stable version — NO PAD errors, NO save errors
############################################################

# ---------------------------
# Setup & Initialization
# ---------------------------
source scripts/setup_OpenRoad.tcl
source scripts/init_tech.tcl

# Read synthesized netlist
read_verilog /foss/designs/out/fir_openroad.v
link_design fir_chip

# ---------------------------
# Floorplan
# ---------------------------
initialize_floorplan \
    -die_area "0 0 1760 1760" \
    -core_area "215 215 1545 1545" \
    -site "CoreSite"

puts "\n=== Floorplan Initialized ===\n"

# ---------------------------
# Pin Placement + Global Nets
# ---------------------------
source scripts/pin_placement.tcl
source scripts/global_connections.tcl

puts "\n=== Pin Placement Done ===\n"

# ---------------------------
# Voltage Domain
# ---------------------------
set_voltage_domain -name {CORE} -power {VDD} -ground {VSS}

# ---------------------------
# PDN Grid Definition
# ---------------------------
define_pdn_grid -name {core_grid} -voltage_domains {CORE}

# ---- Prevent PDNGENSEGV (mandatory tracks) ----
make_tracks Metal1   -x_offset 0 -x_pitch 0.4 -y_offset 0 -y_pitch 0.4
make_tracks Metal2   -x_offset 0 -x_pitch 0.4 -y_offset 0 -y_pitch 0.4
make_tracks Metal3   -x_offset 0 -x_pitch 0.4 -y_offset 0 -y_pitch 0.4
make_tracks Metal4   -x_offset 0 -x_pitch 0.4 -y_offset 0 -y_pitch 0.4
make_tracks Metal5   -x_offset 0 -x_pitch 0.4 -y_offset 0 -y_pitch 0.4
make_tracks TopMetal1 -x_offset 0 -x_pitch 4.0 -y_offset 0 -y_pitch 4.0
make_tracks TopMetal2 -x_offset 0 -x_pitch 4.0 -y_offset 0 -y_pitch 4.0

# ---------------------------
# PDN Ring
# ---------------------------
add_pdn_ring -grid {core_grid} \
    -layers {TopMetal1 TopMetal2} \
    -widths {10 10} \
    -spacings {6 6} \
    -pad_offsets {6 6} \
    -add_connect \
    -connect_to_pads \
    -connect_to_pad_layers {TopMetal2}

# ---------------------------
# Cell Rails + Stripes
# ---------------------------
add_pdn_stripe -grid core_grid -layer Metal1 -width 0.44 -offset 0 \
    -followpins -extend_to_core_ring

add_pdn_stripe -grid core_grid -layer Metal4 -width 0.48 -pitch 56.0 \
    -spacing 3.0 -offset 10.0 -extend_to_core_ring -snap_to_grid \
    -number_of_straps 7

add_pdn_stripe -grid core_grid -layer Metal2 -width 0.48 -pitch 80.0 \
    -extend_to_core_ring

add_pdn_stripe -grid core_grid -layer Metal3 -width 0.48 -pitch 80.0 \
    -extend_to_core_ring

# ---------------------------
# Via Stack Connections
# ---------------------------
add_pdn_connect -grid core_grid -layers {Metal1 Metal2}
add_pdn_connect -grid core_grid -layers {Metal2 Metal3}
add_pdn_connect -grid core_grid -layers {Metal3 Metal4}
add_pdn_connect -grid core_grid -layers {Metal4 Metal5}
add_pdn_connect -grid core_grid -layers {Metal5 TopMetal1}

# ---------------------------
# Run PDN
# ---------------------------
puts "\n⚡ Running PDN Generation...\n"

if {[catch {
    pdngen -failed_via_report reports/fir_chip_failed_vias.rpt
} err]} {
    puts "\n❌ PDN Generation FAILED!"
    puts "Error: $err"
} else {
    puts "\n✅ PDN Generation Completed Successfully.\n"
}

# ---------------------------
# Define Clock (Required Before Save)
# ---------------------------
puts "\n# Applying Primary Clock Constraint (10ns)... #\n"
create_clock -name clk_sys -period 10 [get_ports clk]

# ---------------------------
# SAVE CHECKPOINT (ODB + SDC)
# ---------------------------
set save_dir "/foss/designs/FIR/openroad/pre_place"
file mkdir $save_dir

puts "\n# Saving Floorplan Snapshot to $save_dir ... #\n"

# Save SDC
set sdc_file "$save_dir/fir_chip.pre_place.sdc"
write_sdc $sdc_file

# Save ODB
set odb_file "$save_dir/fir_chip.pre_place.odb"
write_db $odb_file

puts "\n============================================="
puts "  ✅ FLOORPLAN SNAPSHOT SAVED SUCCESSFULLY"
puts "  ODB : $odb_file"
puts "  SDC : $sdc_file"
puts "=============================================\n"
