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
# Multiplier accuracies
N16 ?= 16
N8 ?= 8
N4 ?= 4
#
# Set the environment varialbes to generate the correct test vectors
export N16
export N8
export N4
#
# Define source directories
SRC_DIRS := .
SYNTH_DIR := ./synth
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
	@echo "$(SRCS)"
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
	@echo "N16=<int>"
	@echo "    Specifies the number of appox. bits of the adders in the 16-Bit approx. multiplier."
	@echo ""
	@echo "N8=<int>"
	@echo "    Specifies the number of appox. bits of the adders in the 8-Bit approx. multiplier."
	@echo ""
	@echo "N4=<int>"
	@echo "    Specifies the number of appox. bits of the adders in the 4-Bit approx. multiplier."
	@echo ""
	@echo ""
	@echo "Targets"
	@echo "-------"
	@echo ""
	@echo "make synth"
	@echo "    Synthesize the configurable 16-Bit multiplier with PCPI interface."
	@echo ""
	@echo "make clean"
	@echo "    Delete generated files"
	@echo ""
#
#------------------------------------------------------------------------------
#
# Define target for the test vector generation
#
.PHONY: synth
synth: $(SYNTH_DIR)/top.v
#
#------------------------------------------------------------------------------
#
# Synthesize Verilog designs
#
$(SYNTH_DIR)/%.v: %.tcl
	yosys $^
#
#------------------------------------------------------------------------------
#
# Clean directory
#
.PHONY: clean
clean: 
	rm -rf custom_mul.v
#
#------------------------------------------------------------------------------