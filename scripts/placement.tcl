############################################################
# Placement & Optimization Script
# Design: pipeline_proc_chip (CEP)
############################################################

#docker cp placement.tcl iic-osic-tools_shell_uid_0:/foss/designs/CEP/scripts
source scripts_fp/setup_OpenRoad.tcl
source /foss/designs/CEP/scripts_place/init_tech.tcl



set db_file "/foss/designs/CEP/out/floorplan/pipeline_proc_chip.pre_place.odb"
set sdc_file "/foss/designs/CEP/out/floorplan/pipeline_proc_chip.pre_place.sdc"

if {![file exists $db_file]} {
    puts "ERROR: Could not find database file at $db_file"
    exit 1
}

read_db $db_file
read_sdc $sdc_file
puts "\n✅ Loaded Floorplan Database: $db_file"

set_thread_count 8

puts "\n⚡ Starting Global Placement..."
# Using 0.70 density to be safe (since 0.65 triggered warnings before)
global_placement -density 0.70

# Report Usage
file mkdir reports/placement
report_cell_usage -file reports/placement/cellUsage_initial.rpt
puts "✔ Cell usage report saved."

# 4. Timing & Electrical Correction (Repair Design)
# ---------------------------------------------------------
# Set RC parasitics for IHP 130nm (Estimating on Metal 3/4 is standard)
set_wire_rc -clock -layer Metal4
set_wire_rc -signal -layer Metal3
estimate_parasitics -placement

puts "\n⚡ Checking Violations (Slew/Cap/Fanout)..."
report_check_types -violators > reports/placement/drv_violations.rpt

puts "\n⚡ Repairing Design (Resizing cells, inserting buffers)..."
# This fixes "weak" signals that can't drive long wires
repair_design -verbose

# Report results after repair
report_cell_usage -file reports/placement/cellUsage_fixed.rpt
report_check_types -violators > reports/placement/drv_violations_fixed.rpt

# 5. Detailed Placement
# ---------------------------------------------------------
# Snaps cells to the exact grid lines so they don't overlap
puts "\n⚡ Starting Detailed Placement..."
detailed_placement

# 6. Save Snapshot
# ---------------------------------------------------------
set save_dir "/foss/designs/CEP/out/placement"
file mkdir $save_dir

write_sdc $save_dir/pipeline_proc_chip.placed.sdc
write_db  $save_dir/pipeline_proc_chip.placed.odb

puts "\n============================================="
puts "  ✅ PLACEMENT COMPLETE & SAVED"
puts "  DB Location: $save_dir/pipeline_proc_chip.placed.odb"
puts "=============================================\n"