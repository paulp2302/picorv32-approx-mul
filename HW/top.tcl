yosys -import

# Parameter inputs expected as env vars
# if not set use 0 as default value
set N16 0
set N8 0
set N4 0

if {[info exists ::env(N16)]} {
    set N16 $::env(N16)
}
if {[info exists ::env(N8)]} {
    set N8 $::env(N8)
} 
if {[info exists ::env(N4)]} {
    set N4 $::env(N4)
}

# Read the designs verilog files
read_verilog ADD/OneBit/ApproxAddOneBit.v
read_verilog ADD/Config/ConfigAddMultiBit.v
read_verilog MUL/2x2/Approx2x2Mul.v
read_verilog MUL/4x4/Config4x4Mul.v
read_verilog MUL/8x8/Config8x8Mul.v
read_verilog MUL/16x16/Config16x16Mul.v
read_verilog PCPI/pcpi.v
read_verilog top.v

# Reevaluate the configurable multiplier with the correct parameters
chparam -set N16 $N16 -set N8 $N8 -set N4 $N4 Config16x16Mul

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
write_verilog custom_mul.v
#write_json synth/pcpi.json