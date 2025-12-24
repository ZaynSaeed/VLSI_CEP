# scripts_fp/setup_OpenRoad.tcl

set currentDir [pwd]
set CROC_DIR $currentDir

# Explicit directories
set report_dir "$CROC_DIR/reports/floorplan"
set save_dir   "$CROC_DIR/save/floorplan"

file mkdir $report_dir
file mkdir $save_dir

# Optional debug flag
set step_by_step_debug 0
