#------------------------------------------------------------------------------
#
# Internal variables
#
TESTBENCH ?= testbench.v
TEST_VECTORS_ACC ?= tv_accurate.tv
TEST_VECTORS_APPROX ?= tv_approx.tv
WAVE_FILE ?= waves.gtkw
#
#------------------------------------------------------------------------------
#
# Simulation cell library
#
YOSYS_SIMCELLS := $(shell yosys-config --datdir/simcells.v)
#
#------------------------------------------------------------------------------
# 
# Variables
#
# Define sources and output directories
SRCS := Accurate2x2Mul.v Approx2x2Mul.v
SIM_DIR := ./sim
#
# Define the suffixes used in this Makefile
.SUFFIXES:
.SUFFIXES: .v .iverilog .vcd .tv
#
# Define the mode variable used to control the testbench
MODE = 0
#
#------------------------------------------------------------------------------
#
# Help target
#
.PHONY: help
help:
	@echo ""
	@echo "Options"
	@echo "-------"
	@echo ""
	@echo "Options can be set from the command line, and directly in the"
	@echo "Makefile. Please note that it may be necessary to call"
	@echo ""
	@echo "    make clean"
	@echo ""
	@echo "for options to take effect when execting targets."
	@echo ""
	@echo ""
	@echo "When calling 'make' from the command line, options can be permanently"
	@echo "set for a session by exporting an environment variable:"
	@echo ""
	@echo "    export OPTION=value"
	@echo "    make target_1"
	@echo "    make target_2"
	@echo "    ..."
	@echo "    make target_n"
	@echo ""
	@echo "For a single run of 'make', the environment variable can be set as"
	@echo "follows:"
	@echo ""
	@echo "    OPTION=value make target_1"
	@echo ""
	@echo "To make the value of an option independent from the command line, it"
	@echo "can be set in the Makefile, e.g.:"
	@echo ""
	@echo "    OPTION ?= value"
	@echo ""
	@echo ""
	@echo "TESTBENCH=<filename>"
	@echo "    Specifies the testbench to use for the 2-Bit multipliers."
	@echo ""
	@echo "TEST_VECTOR_ACC=<filename>"
	@echo "    Specifies the name of the testvector file for the accurate multiplier."
	@echo ""
	@echo "TEST_VECTOR_APPROX=<filename>"
	@echo "    Specifies the name of the testvector file for the approximate multiplier."
	@echo ""
	@echo "Targets"
	@echo "-------"
	@echo ""
	@echo "make accurate"
	@echo "    Simulate the accurate 2-Bit multiplier."
	@echo ""
	@echo "make approx"
	@echo "    Simulate the approximate 2-Bit multiplier."
	@echo ""
	@echo "make accurate-gui"
	@echo "    Show the trace of the accurate 2-Bit multiplier simulation in GTKWave."
	@echo ""
	@echo "make approx"
	@echo "    Show the trace of the approximate 2-Bit multiplier simulation in GTKWave."
	@echo ""
	@echo "make clean"
	@echo "    Delete generated files"
	@echo ""
#
#------------------------------------------------------------------------------
#
# Define target for simulation of the approximate multiplier
#
.PHONY: approx
approx: MODE=1
approx: $(SIM_DIR)/Approx2x2Mul.vcd
#
# Define target for simulation of the accurate multiplier
#
.PHONY: accurate
accurate: MODE=0
accurate: $(SIM_DIR)/Accurate2x2Mul.vcd
#
# Define target to display the traces of the approximate multiplier
#
.PHONY: approx-gui
approx-gui: approx
	gtkwave $(SIM_DIR)/Approx2x2Mul.vcd $(WAVE_FILE) &
#
# Define target to display the traces of the accurate multiplier
#
.PHONY: accurate-gui
accurate-gui: accurate
	gtkwave $(SIM_DIR)/Accurate2x2Mul.vcd $(WAVE_FILE) &
#
#------------------------------------------------------------------------------
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
		-D 'VCD_FILE="$@"' \
		-D 'ACC_TEST_VECTORS="$(TEST_VECTORS_ACC)"' \
		-D 'APPROX_TEST_VECTORS="$(TEST_VECTORS_APPROX)"'
	vvp $(SIM_DIR)/$*.iverilog
#
#------------------------------------------------------------------------------
#
# Clean directory
#
.PHONY: clean
clean: 
	rm -rf $(SIM_DIR)
