#------------------------------------------------------------------------------
#
# Internal variables
#
TESTBENCH ?= testbench.v
TEST_VECTORS ?= tv_config.tv
MUL4_PATH ?= ../MUL/4x4/$(TEST_VECTORS)
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
# Multiplier accuracies
N4 ?= 4
#
# Set the environment varialbes to generate the correct test vectors
export N4
export TEST_VECTORS
export MUL8_PATH
#
# Define source directories
SRC_DIRS := . ../2x2/ ../../ADD/
SIM_DIR := ./sim
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
	@echo "TESTBENCH=<filename>"
	@echo "    Specifies the testbench to use for verifying the configurable 16-Bit multiplier."
	@echo ""
	@echo "TESTVECTOR=<int>"
	@echo "    Specifies the name of the testvector file."
	@echo ""
	@echo "MUL16_PATH=<path/to/file>"
	@echo "    Specifies the path form the REF to the 16x16 directory."
	@echo ""
	@echo ""
	@echo "Targets"
	@echo "-------"
	@echo ""
	@echo "make tv"
	@echo "    Generate the testvector file."
	@echo ""
	@echo "make sim"
	@echo "    Simulate the configurable 16-Bit multiplier."
	@echo ""
	@echo "make synth"
	@echo "    Synthesize the configurable 16-Bit multiplier with the current parameters."
	@echo ""
	@echo "make sim-synth"
	@echo "    Simulate the synthesizedconfigurable 16-Bit multiplier."
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
	@$(MAKE) $(SIM_DIR)/Config4x4Mul.vcd MODE=0
#
# Define target for synthesis
#
.PHONY: synth
synth: $(SYNTH_DIR)/Config4x4Mul.v
#
# Define target for simulation of the synthesized module
#
.PHONY: sim-synth
sim-synth: 
	@$(MAKE) $(SIM_DIR)/Config4x4Mul_synth.vcd MODE=1
#
#------------------------------------------------------------------------------
#
# Generate the testvector file
#
$(TEST_VECTORS):
	cd ../../REF/ && make mul4 && make clean
#
#-------------------------------------------------------
#
# Simulate Verilog designs
#
$(SIM_DIR)/%.vcd: $(SRCS) $(TESTBENCH) $(TEST_VECTORS)
	mkdir -p $(dir $@)
	iverilog \
		-l $(YOSYS_SIMCELLS) \
		-o $(SIM_DIR)/$*.iverilog \
		$(SRCS) $(TESTBENCH) \
		-D TEST_MODE=$(MODE) \
		-D 'VCD_FILE="$@"' \
		-D 'N4=$(N4)' \
		-D 'TEST_VECTORS="$(TEST_VECTORS)"'
	vvp $(SIM_DIR)/$*.iverilog
#
#------------------------------------------------------------------------------
#
# Synthesize Verilog designs
#
$(SYNTH_DIR)/%.v: %.tcl
	mkdir -p $(dir $@)
	yosys $^
#
#------------------------------------------------------------------------------
#
# Simulate the synthesized Verilog designs
#
$(SIM_DIR)/%_synth.vcd: $(SYNTH_DIR)/%.v $(TESTBENCH) $(TEST_VECTORS)
	mkdir -p $(dir $@)
	iverilog \
		-l $(YOSYS_SIMCELLS) \
		-o $(SIM_DIR)/$*_synth.iverilog \
		$(SYNTH_DIR)/$*.v $(TESTBENCH) \
		-D TEST_MODE=$(MODE) \
		-D 'VCD_FILE="$@"' \ 
		-D 'TEST_VECTORS="$(TESTVECTOR)"'
	vvp $(SIM_DIR)/$*_synth.iverilog
#
#------------------------------------------------------------------------------
#
# Clean directory
#
.PHONY: clean
clean: 
	rm -rf *.iverilog *.vcd sim synth $(TEST_VECTORS)
#
#------------------------------------------------------------------------------