yosys -import

# inputs expected as env vars, if not set use 0 as default value
#
set N4 0

if {[info exists ::env(N4)]} {
    set N4 $::env(N4)
}

# Read the designs verilog files
read_verilog ../../ADD/OneBit/AccurateAddOneBit.v
read_verilog ../../ADD/OneBit/ApproxAddOneBit.v
read_verilog ../../ADD/Config/ConfigAddMultiBit.v
read_verilog ../2x2/Approx2x2Mul.v
read_verilog Config4x4Mul.v

# Reevaluate the configurable multiplier with the correct parameters
chparam -set N4 $N4 Config4x4Mul

# Synthesis
hierarchy -check -auto-top;;
opt_expr;;
procs;;
opt_expr;;
flatten;;
opt_expr;;
opt_clean;;
opt;;
stat

# Write the syntesized multiplier to file
# synth_ice40
write_verilog synth/Config4x4Mul.v
# write_json synth/Config16x16Mul.json