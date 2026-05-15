#------------------------------------------------------------------------------
# Internal variables
#
# Number of test vectors
NUM_TV ?= 1000
#
WAVE_FILE ?= waves.gtkw
TESTBENCH ?= testbench.v
TEST_VECTORS = tv_$(WIDTH_ADD)_$(N_ADD)_$(NUM_TV).tv
REF_DIR ?= ../../REF
REF_SCRIPT = $(REF_DIR)/approxaddN.py
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
WIDTH_ADD ?= 32
N_ADD ?= 13
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
	@echo "WIDTH_ADD=<int>"
	@echo "    Specifies the width of the test vectors of the configurable n-Bit adder."
	@echo ""
	@echo "N_ADD=<int>"
	@echo "    Specifies the number of approximate bits of the configurable n-Bit adder."
	@echo ""
	@echo "NUM_TV=<int>"
	@echo "    Specifies the number of test vectors used in the automated testbench."
	@echo ""
	@echo "TESTBENCH=<filename>"
	@echo "    Specifies the testbench to use for verifying the configurable n-Bit adder."
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
	@echo "make sim-gui"
	@echo "    Simulate the configurable MultiBit adder and open the traces in GTKWave."
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
tv: $(TEST_VECTORS)
#
# Define target for simulation
#
.PHONY: sim
sim: 
	@$(MAKE) $(SIM_DIR)/ConfigAddMultiBit.vcd
#
#
# Open waveforms in GTKWave
#
.PHONY: sim-gui
sim-gui: sim
	gtkwave $(SIM_DIR)/ConfigAddMultiBit.vcd $(WAVE_FILE) &
#
#------------------------------------------------------------------------------
#
# Generate the testvector file
#
$(TEST_VECTORS):
	@echo "Generating $(NUM_TV) test vectors for $(WIDTH_ADD)-bit adder with $(N_ADD) approximated bits..."
	python3 $(REF_SCRIPT) $(NUM_TV) $(WIDTH_ADD) $(N_ADD) $@
#
#------------------------------------------------------------------------------
#
# Simulate Verilog designs
#
$(SIM_DIR)/%.vcd: $(SRCS) $(TESTBENCH) $(TEST_VECTORS)
	mkdir -p $(dir $@)
	iverilog \
		-g2012 \
		-l $(YOSYS_SIMCELLS) \
		-o $(SIM_DIR)/$*.iverilog \
		$(SRCS) $(TESTBENCH) \
		-D 'VCD_FILE="$@"' \
		-D 'WIDTH_ADD=$(WIDTH_ADD)' \
		-D 'N_ADD=$(N_ADD)' \
		-D 'NUM_TV=$(NUM_TV)' \
		-D 'TEST_VECTORS="$(TEST_VECTORS)"'
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
