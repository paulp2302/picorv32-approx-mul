#------------------------------------------------------------------------------
# Internal variables
#
TESTBENCH ?= testbench.v
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
# Define source directories
SRC_DIRS := .
SIM_DIR := ./sim
#
# Define internal variable for the different sources
SRCS := $(shell find $(SRC_DIRS) -name '*.v' -and -not -name '*testbench.v' \
		-and -not -name '$(TESTBENCH)')
#
# Define the suffixes used in this Makefile
.SUFFIXES:
.SUFFIXES: .v .iverilog .vcd .tv
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
	@echo "    Specifies the testbench to use for verifying the configurable n-Bit adder."
	@echo ""
	@echo ""
	@echo "Targets"
	@echo "-------"
	@echo ""
	@echo "make accurate"
	@echo "    Simulate the accurate OneBit adder."
	@echo ""
	@echo "make approx"
	@echo "    Simulate the approximate OneBit adder."
	@echo ""
	@echo "make clean"
	@echo "    Delete generated files"
	@echo ""
#
#------------------------------------------------------------------------------
#
# Define target for simulation of the approximate OneBit adder
#
.PHONY: approx 
approx: $(SIM_DIR)/Approx2x2Mul.vcd MODE=1
#
# Define target for simulation of the accurate OneBit adder
#
.PHONY: accurate
accurate: $(SIM_DIR)/Accurate2x2Mul.vcd MODE=0
#
#------------------------------------------------------------------------------
#
# Simulate Verilog designs
#
$(SIM_DIR)/%.vcd: $(SRCS) $(TESTBENCH)
	mkdir -p $(dir $@)
	iverilog \
		-g2012 \
		-l $(YOSYS_SIMCELLS) \
		-o $(SIM_DIR)/$*.iverilog \
		$(SRCS) $(TESTBENCH) \
		-D 'VCD_FILE="$@"' \
		-D 'TEST_MODE="$(MODE)"'
	vvp $(SIM_DIR)/$*.iverilog
#
#------------------------------------------------------------------------------
#
# Clean directory
#
.PHONY: clean
clean: 
	rm -rf $(SIM_DIR)
#
#------------------------------------------------------------------------------