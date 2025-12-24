#docker cp synthesis.tcl iic-osic-tools_shell_uid_0:/foss/designs/CEP/scripts
# ============================================================
# Three-Stage RISC-V Pipeline Synthesis Script (Ready to Run)
# TOP MODULE: cep_chip
# ============================================================

#######################################
###### Read Technology Libraries ######
#######################################

# Standard Cells (Core Logic)
yosys read_liberty -lib /foss/pdks/ihp-sg13g2/libs.ref/sg13g2_stdcell/lib/sg13g2_stdcell_typ_1p20V_25C.lib
# I/O Pads (Typically higher voltage)
yosys read_liberty -lib /foss/pdks/ihp-sg13g2/libs.ref/sg13g2_io/lib/sg13g2_io_typ_1p5V_3p3V_25C.lib
# SRAM/Memory (If used by the core)
yosys read_liberty -lib /foss/pdks/ihp-sg13g2/libs.ref/sg13g2_sram/lib/RM_IHPSG13_2P_64x32_c2_typ_1p20V_25C.lib


#########################
###### Load Design ######
#########################

# Enable SystemVerilog plugin
yosys plugin -i slang.so

# Load RISC-V wrapper and file list
yosys read_slang --keep-hierarchy --top pipeline_proc_chip -F threesp.flist --allow-use-before-declare --ignore-unknown-modules


#########################
###### Elaboration ######
#########################

yosys stat
yosys tee -q -o "reports/pipeline_proc_firstrpt.rpt" stat
yosys write_verilog "out/pipeline_proc_firstrpt.v"

# Resolve hierarchy
yosys hierarchy -check -top pipeline_proc_chip
yosys proc


####################################
###### Coarse-grain Synthesis ######
####################################

yosys check
yosys fsm
yosys tee -q -o "reports/fsm.rpt" stat
yosys wreduce
yosys peepopt
yosys opt -noff
yosys memory
yosys opt_dff


###########################################
###### Define target clock frequency ######
###########################################

# 100MHz clock target (10000 ps) - Your performance constraint.
set period_ps 10000


##################################
###### Fine-grain synthesis ######
##################################

yosys techmap
yosys tee -q -o "reports/techmap.rpt" stat


############################
###### Flatten design ######
############################

# Flattening to enable cross-module optimization.
yosys flatten

yosys dfflibmap -liberty /foss/pdks/ihp-sg13g2/libs.ref/sg13g2_stdcell/lib/sg13g2_stdcell_typ_1p20V_25C.lib
yosys dfflegalize

# ABC Combinational Logic Mapping
yosys abc -liberty /foss/pdks/ihp-sg13g2/libs.ref/sg13g2_stdcell/lib/sg13g2_stdcell_typ_1p20V_25C.lib \
          -D ${period_ps} \
          -constr src/yosys_abc.constr \
          -script scripts/abc-opt.script


################################
###### Technology Mapping ######
################################

yosys write_verilog -noattr out/pipeline_proc_mapped.v
yosys stat -liberty /foss/pdks/ihp-sg13g2/libs.ref/sg13g2_stdcell/lib/sg13g2_stdcell_typ_1p20V_25C.lib


#######################################
###### Prepare for OpenROAD flow ######
#######################################

yosys splitnets -ports
yosys setundef -zero
yosys hilomap -hicell sg13g2_tiehi_1 Z -locell sg13g2_tielo_1 Z

# Final netlist for OpenROAD
yosys write_verilog -noattr out/pipeline_proc_openroad.v


exit