#docker cp floorplan.tcl iic-osic-tools_shell_uid_0:/foss/designs/CEP/scripts
#source scripts/floorplan.tcl

############################################################
# Floorplan + PDN + Save Script
# Design: pipeline_proc_chip (CEP)
# Tech  : SG13G2
############################################################

# ---------------------------
# Setup & Initialization
# ---------------------------
source scripts_fp/setup_OpenRoad.tcl
source scripts_fp/init_tech.tcl

read_verilog /foss/designs/CEP/out/pipeline_proc_openroad.v
link_design pipeline_proc_chip

puts "\n=== Design Linked: pipeline_proc_chip ===\n"

# ---------------------------
# Floorplan
# ---------------------------
initialize_floorplan \
    -die_area  "0 0 1760 1760" \
    -core_area "215 215 1545 1545" \
    -site CoreSite






puts "\n=== Floorplan Initialized ===\n"
#set_io_pin_constraint -pin_depth 35

# ---------------------------
# IO + Pin Placement
# ---------------------------
source scripts_fp/pin_placement.tcl

# ---------------------------
# Global Nets
# ---------------------------
source scripts_fp/global_connections.tcl

puts "\n=== IO + Global Nets Done ===\n"

# ---------------------------
# Voltage Domain
# ---------------------------
set_voltage_domain -name CORE -power VDD -ground VSS

# ---------------------------
# PDN Grid
# ---------------------------
define_pdn_grid -name core_grid -voltage_domains CORE

# ---- Routing Tracks (PDN safe) ----
make_tracks Metal1    -x_offset 0 -x_pitch 0.4 -y_offset 0 -y_pitch 0.4
make_tracks Metal2    -x_offset 0 -x_pitch 0.4 -y_offset 0 -y_pitch 0.4
make_tracks Metal3    -x_offset 0 -x_pitch 0.4 -y_offset 0 -y_pitch 0.4
make_tracks Metal4    -x_offset 0 -x_pitch 0.4 -y_offset 0 -y_pitch 0.4
make_tracks Metal5    -x_offset 0 -x_pitch 0.4 -y_offset 0 -y_pitch 0.4
make_tracks TopMetal1 -x_offset 0 -x_pitch 4.0 -y_offset 0 -y_pitch 4.0
make_tracks TopMetal2 -x_offset 0 -x_pitch 4.0 -y_offset 0 -y_pitch 4.0

# ---------------------------
# PDN Ring
# ---------------------------
add_pdn_ring -grid core_grid \
    -layers {TopMetal1 TopMetal2} \
    -widths {10 10} \
    -spacings {6 6} \
    -pad_offsets {6 6} \
    -connect_to_pads \
    -connect_to_pad_layers {TopMetal2} \
    -add_connect

# ---------------------------
# PDN Stripes
# ---------------------------
add_pdn_stripe -grid core_grid -layer Metal1 -width 0.44 \
    -followpins -extend_to_core_ring

add_pdn_stripe -grid core_grid -layer Metal4 -width 0.48 \
    -pitch 56.0 -spacing 3.0 -offset 10.0 \
    -extend_to_core_ring -snap_to_grid 
#    -number_of_straps 7

add_pdn_stripe -grid core_grid -layer Metal2 -width 0.48 \
    -pitch 80.0 -extend_to_core_ring

add_pdn_stripe -grid core_grid -layer Metal3 -width 0.48 \
    -pitch 80.0 -extend_to_core_ring

# ---------------------------
# PDN Via Connections
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
pdngen -failed_via_report reports/floorplan/pipeline_proc_failed_vias.rpt

puts "\n✅ PDN Completed Successfully\n"

# ---------------------------
# Clock Constraint (Low-Power Friendly)
# ---------------------------
create_clock -name clk_sys -period 10 [get_ports clk]

# ---------------------------
# Save Checkpoint
# ---------------------------
set save_dir "/foss/designs/CEP/openroad/pre_place"
file mkdir $save_dir

write_sdc $save_dir/pipeline_proc_chip.pre_place.sdc
write_db  $save_dir/pipeline_proc_chip.pre_place.odb

puts "\n============================================="
puts "  ✅ FLOORPLAN SNAPSHOT SAVED"
puts "=============================================\n"
