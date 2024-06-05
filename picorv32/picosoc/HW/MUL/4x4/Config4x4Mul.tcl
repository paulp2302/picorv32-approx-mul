yosys -import

# inputs expected as env vars, if not set use 0 as default value
#
set N4 0

if {[info exists ::env(N4)]} {
    set N4 $::env(N4)
}

read_verilog ../../ADD/OneBit/AccurateAddOneBit.v
read_verilog ../../ADD/OneBit/ApproxAddOneBit.v
read_verilog -pwires ../../ADD/Config/ConfigAddMultiBit.v
read_verilog ../2x2/Approx2x2Mul.v
read_verilog Config4x4Mul.v

chparam -set N4 $N4 Config4x4Mul

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
write_verilog synth/Config4x4Mul.v
# write_json synth/Config16x16Mul.json