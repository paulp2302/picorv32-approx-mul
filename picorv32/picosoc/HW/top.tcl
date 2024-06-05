yosys -import

# inputs expected as env vars, if not set use 0 as default value
#
set N16 16
set N8 8
set N4 4

if {[info exists ::env(N16)]} {
    set N16 $::env(N16)
}
if {[info exists ::env(N8)]} {
    set N8 $::env(N8)
} 
if {[info exists ::env(N4)]} {
    set N4 $::env(N4)
}

read_verilog ADD/OneBit/ApproxAddOneBit.v
read_verilog ADD/Config/ConfigAddMultiBit.v
read_verilog MUL/2x2/Approx2x2Mul.v
read_verilog MUL/4x4/Config4x4Mul.v
read_verilog MUL/8x8/Config8x8Mul.v
read_verilog MUL/16x16/Config16x16Mul.v
read_verilog PCPI/pcpi.v
read_verilog top.v

chparam -set N16 $N16 -set N8 $N8 -set N4 $N4 Config16x16Mul

# High level synthesis processes
hierarchy -check -auto-top;;
opt_expr;;
procs;;
opt_expr;;
flatten;;
opt_expr;;
opt_clean;;
opt;;
stat

# Fine level synthesis
#opt -full
clean
stat

# Write the syntesized multiplier to file
#synth_ice40
write_verilog ../top.v
#write_json synth/pcpi.json