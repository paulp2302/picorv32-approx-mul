#------------------------------------------------------------------------------
# Module Identiy
#------------------------------------------------------------------------------
TOP_MODULE := Config8x8Mul
WIDTH      := 8

# Number of approx bits 
N4  ?= 4
N8  ?= 8
N16 := 0

MODULE_PARAMS := -set N4 $(N4) -set N8 $(N8)
PARAM_SUFFIX  := $(N8)_$(N4)

#------------------------------------------------------------------------------
# Simulation and Synthesis Parameters
#------------------------------------------------------------------------------
# Number of test vectors
NUM_TV ?= 1000

#------------------------------------------------------------------------------
# Directories and Paths
#------------------------------------------------------------------------------
SIM_DIR   := ./sim
SYNTH_DIR := ./synth
REF_DIR   := ../../REF
SRC_DIRS  := . ../2x2/ ../4x4 ../../ADD/

#------------------------------------------------------------------------------
# Files and Toolchains
#------------------------------------------------------------------------------
TESTBENCH      := testbench.v
WAVE_FILE      := waves.gtkw
CONFIGMUL_TCL  := ../../global_synth.tcl
TEST_VECTORS   := $(SIM_DIR)/tv_$(PARAM_SUFFIX)_$(NUM_TV).tv
REF_SCRIPT     := $(REF_DIR)/approxmulN.py
YOSYS_SIMCELLS := $(shell yosys-config --datdir/simcells.v)

# Find all verilog source files (exclude testbenches and simulation/synthesis dirs)
SRCS := $(shell find $(SRC_DIRS) -name '*.v' -and -not -name '*testbench.v' \
	-and -not -name '$(TESTBENCH)' | grep -v '/sim/' | grep -v '/synth/')

#------------------------------------------------------------------------------

include ../common.mk
