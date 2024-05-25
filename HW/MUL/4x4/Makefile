#-------------------------------------------------------
# Internal variables
#
TESTBENCH ?= testbench.v
#
#-------------------------------------------------------
#
# Simulation cell library
#
YOSYS_SIMCELLS := $(shell yosys-config --datdir/simcells.v)
#
#-------------------------------------------------------
# 
# Variables
# Define source directories
SRC_DIRS := . ../2x2/ ../../ADD/
SIM_DIR := ./sim
SYNTH_DIR := ./synth
#
# Define internal variable for the different sources
SRCS := $(shell find $(SRC_DIRS) -name '*.v' -and -not -name 'testbench.v')
#
# VCD_FILES := $(patsubst ./%.v,./%.vcd,$(wildcard ./*Mul*.v))
#
# Define the suffixes used in this Makefile
.SUFFIXES:
.SUFFIXES: .v .iverilog .vcd .synth
#
#------------------------------------------------------------------------------
#
# Define targets for simulation 'sim-accurate', 'sim-approx1', 'sim-approx2'
#
.PHONY: sim sim-accurate sim-approx1 sim-approx2 
sim: sim-accurate sim-approx1 sim-approx2
sim-accurate: 
	@$(MAKE) $(SIM_DIR)/Accurate4x4Mul.vcd MODE=0
sim-approx1: 
	@$(MAKE) $(SIM_DIR)/Approx4x4MulV1.vcd MODE=1
sim-approx2:
	@$(MAKE) $(SIM_DIR)/Approx4x4MulV2.vcd MODE=2
#
#
# Define targets for synthesis 'synth-accurate', 'synth-approx1', 'synth-approx2'
#
.PHONY: synth synth-accurate synth-approx1 synth-approx2
synth: synth-accurate synth-approx1 synth-approx2
synth-accurate: $(SYNTH_DIR)/Accurate4x4Mul.v
synth-approx1: $(SYNTH_DIR)/Approx4x4MulV1.v
synth-approx2: $(SYNTH_DIR)/Approx4x4MulV2.v
#
# Define targets for simulation of the synthesized modules 
# 'sim-synth-accurate', 'sim-synth-approx1', 'sim-synth-approx2'
#
.PHONY: sim-synth sim-synth-accurate sim-synth-approx1 sim-synth-approx2
sim-synth: sim-synth-accurate sim-synth-approx1 sim-synth-approx2
sim-synth-accurate: 
	@$(MAKE) $(SIM_DIR)/Accurate4x4Mul_synth.vcd MODE=0
sim-synth-approx1:
	@$(MAKE) $(SIM_DIR)/Approx4x4MulV1_synth.vcd MODE=1
sim-synth-approx2:
	@$(MAKE) $(SIM_DIR)/Approx4x4MulV2_synth.vcd MODE=2
#
#-------------------------------------------------------
#
# Simulate Verilog designs
#
$(SIM_DIR)/%.vcd: $(SRCS) $(TESTBENCH)
	mkdir -p $(dir $@)
	iverilog \
		-l $(YOSYS_SIMCELLS) \
		-o $(SIM_DIR)/$*.iverilog \
		$^ \
		-D TEST_MODE=$(MODE) \
		-D 'VCD_FILE="$@"'
	vvp $(SIM_DIR)/$*.iverilog
#
#------------------------------------------------------------------------------
#
# Synthesize Verilog designs
#
$(SYNTH_DIR)/%.v: %.ys
	mkdir -p $(dir $@)
	yosys -s $^
#
#------------------------------------------------------------------------------
#
# Simulate the synthesized Verilog designs
#
$(SIM_DIR)/%_synth.vcd: $(SYNTH_DIR)/%.v $(TESTBENCH)
	mkdir -p $(dir $@)
	iverilog \
		-l $(YOSYS_SIMCELLS) \
		-o $(SIM_DIR)/$*_synth.iverilog \
		$^ \
		-D TEST_MODE=$(MODE) \
		-D 'VCD_FILE="$@"'
	vvp $(SIM_DIR)/$*_synth.iverilog
#
#-------------------------------------------------------
#
# Clean directory
#
.PHONY: clean
clean: 
	rm -rf sim synth
#
#------------------------------------------------------------------------------