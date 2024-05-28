#------------------------------------------------------------------------------
# Internal variables
#
TESTBENCH ?= testbench.v
TEST_VECTORS ?= tv_conf.tv
ADDN_PATH ?= ../ADD/Config/$(TESTVECTOR)
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
# Default values for width and accuracy
WIDTH_ADD ?= 8
N_ADD ?= 4
#
# Set environment variables for the testvector generations
export WIDTH_ADD
export N_ADD
export TEST_VECTORS
export ADDN_PATH
#
# Define source directories
SRC_DIRS := . ../../ADD/OneBit
SIM_DIR := ./sim
#
# Define internal variable for the different sources
SRCS := $(shell find $(SRC_DIRS) -name '*.v' -and -not -name '*testbench.v' \
		-and -not -name '$(TESTBENCH)')
#
# Define the suffixes used in this Makefile
.SUFFIXES:
.SUFFIXES: .v .iverilog .vcd
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
	@echo "WIDTH_ADD=<int>"
	@echo "    Specifies the width of the test vectors of the configurable n-Bit adder."
	@echo ""
	@echo "N_ADD=<int>"
	@echo "    Specifies the number of approximate bits of the configurable n-Bit adder."
	@echo ""
	@echo "TESTBENCH=<filename>"
	@echo "    Specifies the testbench to use for verifying the configurable n-Bit adder."
	@echo ""
	@echo "TESTVECTOR=<int>"
	@echo "    Specifies the name of the testvector file."
	@echo ""
	@echo "ADDN_PATH=<path/to/file>"
	@echo "    Specifies the path form the REF to the ADD/Config directory."
	@echo ""
	@echo ""
	@echo "Targets"
	@echo "-------"
	@echo ""
	@echo "make tv"
	@echo "    Generate the testvector file."
	@echo ""
	@echo "make sim"
	@echo "    Simulate the configurable MultiBit adder."
	@echo ""
	@echo "make clean"
	@echo "    Delete generated files"
	@echo ""
#
#------------------------------------------------------------------------------
#
# Define target for the test vector generation
#
.PHONY: tv
tv: $(TESTVECTOR)
#
# Define target for simulation
#
.PHONY: sim
sim: 
	@$(MAKE) $(SIM_DIR)/ConfigAddMultiBit.vcd
#
#------------------------------------------------------------------------------
#
# Generate the testvector file
#
$(TESTVECTOR):
	cd ../../REF/ && make addN && make clean
#
#------------------------------------------------------------------------------
#
# Simulate Verilog designs
#
$(SIM_DIR)/%.vcd: $(SRCS) $(TESTBENCH) $(TESTVECTOR)
	mkdir -p $(dir $@)
	iverilog \
		-g2012 \
		-l $(YOSYS_SIMCELLS) \
		-o $(SIM_DIR)/$*.iverilog \
		$(SRCS) $(TESTBENCH) \
		-D 'VCD_FILE="$@"' \
		-D 'WIDTH_ADD=$(WIDTH_ADD)' \
		-D 'N_ADD=$(N_ADD)' \
		-D 'TEST_VECTORS="$(TESTVECTOR)"'
	vvp $(SIM_DIR)/$*.iverilog
#
#------------------------------------------------------------------------------
#
# Clean directory
#
.PHONY: clean
clean: 
	rm -rf sim *.tv
#
#------------------------------------------------------------------------------