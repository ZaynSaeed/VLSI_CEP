# =============================
# CEP Clock Tree Synthesis Script (Adapted)
# Design: pipeline_proc_chip
# Tech  : IHP SG13G2
# =============================

# 1. Setup & Initialization
# -----------------------------

#docker cp CTS.tcl iic-osic-tools_shell_uid_0:/foss/designs/CEP/scripts
set proj_name pipeline_proc_chip
set top_design pipeline_proc_chip

# Source your standard setup files
source scripts_fp/setup_OpenRoad.tcl
source /foss/designs/CEP/scripts_place/init_tech.tcl

# Create report directory
file mkdir reports/cts

# 2. Load Placed DB and Constraints
# -----------------------------
# We read the output from the previous "Placement" step
set db_file "/foss/designs/CEP/out/placement/${proj_name}.placed.odb"
set sdc_file "/foss/designs/CEP/out/placement/${proj_name}.placed.sdc"

if {![file exists $db_file]} {
    puts "ERROR: Could not find database file at $db_file"
    exit 1
}

read_db $db_file
read_sdc $sdc_file
puts "\n✅ Loaded Placed Database: $db_file"

# 3. RC Extraction for CTS
# -----------------------------
set_wire_rc -clock -layer Metal4
set_wire_rc -signal -layer Metal3 
# (Note: IHP usually uses M3 for signal routing and M4 for clock/power)

estimate_parasitics -placement

# Optional clock net clean-up (Removes pre-existing buffers if any)
repair_clock_inverters

# 4. Run CTS (With IHP Buffer Specifics)
# -----------------------------
# CRITICAL CHANGE: Added buffer list. Generic CTS fails without this in OpenROAD.
configure_cts_characterization -max_slew 1.5e-9 -max_cap 1.0e-12

clock_tree_synthesis -root_buf sg13g2_buf_16 \
                     -buf_list "sg13g2_buf_4 sg13g2_buf_8 sg13g2_buf_16" \
                     -sink_clustering_enable \
                     -sink_clustering_size 25 \
                     -balance_levels

# Fix up the clock nets after building the tree
repair_clock_nets

# 5. CTS Reports
# -----------------------------
# Note: 'clk_sys' is the name defined in your SDC file
report_clock_latency -clock clk_sys > reports/cts/clock_latency.rpt
report_cts -out_file reports/cts/cts_summary.rpt

# 6. Timing After CTS
# -----------------------------
estimate_parasitics -placement
set_propagated_clock [all_clocks]

report_checks -path_group clk_sys > reports/cts/timing_post_cts.rpt

# 7. Optimize Design (Post-CTS Repair)
# -----------------------------
puts "\n⚡ Repairing Logic and Timing..."
# Fix max_cap / max_fanout violations
repair_design -verbose

# Fix Setup violations (Hold fixing usually happens in Routing/Post-Route)
repair_timing -setup -verbose

# 8. Legalize Placement Again
# -----------------------------
# Buffers inserted by CTS might overlap other cells. This fixes overlaps.
detailed_placement

# 9. Area + Power Reports
# -----------------------------
report_design_area > reports/cts/area.rpt
report_power -corner tt > reports/cts/power.rpt

# 10. Save Output for Routing
# -----------------------------
set save_dir "/foss/designs/CEP/out/cts"
file mkdir $save_dir

write_db  $save_dir/${proj_name}.cts.odb
write_sdc $save_dir/${proj_name}.cts.sdc

puts "\n============================================="
puts "  ✅ CTS COMPLETE & SAVED"
puts "  DB Location: $save_dir/${proj_name}.cts.odb"
puts "=============================================\n"