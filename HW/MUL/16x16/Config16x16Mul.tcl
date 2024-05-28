yosys -import

# inputs expected as env vars, if not set use 0 as default value
#
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

read_verilog ../../ADD/OneBit/AccurateAddOneBit.v
read_verilog ../../ADD/OneBit/ApproxAddOneBit.v
read_verilog -pwires ../../ADD/Config/ConfigAddMultiBit.v
read_verilog ../2x2/Approx2x2Mul.v
read_verilog -pwires ../4x4/Config4x4Mul.v
read_verilog -pwires ../8x8/Config8x8Mul.v
read_verilog Config16x16Mul.v

chparam -set N16 $N16 -set N8 $N8 -set N4 $N4 Config16x16Mul

# High level synthesis processes
hierarchy -check -auto-top
procs
clean
opt
clean

# Fine level synthesis
opt -full
clean
stat

# Write the syntesized multiplier to file
# synth_ice40
write_verilog synth/Config16x16Mul.v
# write_json synth/Config16x16Mul.json