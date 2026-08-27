#------------------------------------------------------------------------------
#
# Internal variables
#
TESTBENCH ?= testbench.v
TEST_VECTORS_ACC ?= tv_accurate.tv
TEST_VECTORS_APPROX ?= tv_approx.tv
WAVE_FILE ?= waves.gtkw

# Select the accurate (0, default) or approximate (1) multiplier variant
APPROX ?= 0
ifeq ($(APPROX),0)
MODULE_NAME := Accurate2x2Mul
else
MODULE_NAME := Approx2x2Mul
endif
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
SYNTH_DIR := ./synth
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
	@echo "APPROX=<0|1>"
	@echo "    Selects the accurate (0, default) or approximate (1) 2-Bit multiplier."
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
	@echo "make sim"
	@echo "    Simulate the configurable (APPROX) 2-Bit multiplier."
	@echo ""
	@echo "make synth"
	@echo "    Synthesize the configurable (APPROX) 2-Bit multiplier."
	@echo ""
	@echo "make sim-synth"
	@echo "    Simulate the synthesized configurable (APPROX) 2-Bit multiplier."
	@echo ""
	@echo "make sim-gui"
	@echo "    Show the trace of the configurable (APPROX) 2-Bit multiplier simulation in GTKWave."
	@echo ""
	@echo "make sim-synth-gui"
	@echo "    Show the trace of the synthesized configurable (APPROX) 2-Bit multiplier simulation in GTKWave."
	@echo ""
	@echo "make clean"
	@echo "    Delete generated files"
	@echo ""
#
#------------------------------------------------------------------------------
#
# Define target for simulation of the configurable (APPROX) multiplier
#
.PHONY: sim
sim:
	@$(MAKE) $(SIM_DIR)/$(MODULE_NAME).vcd
#
# Define target for synthesis of the configurable (APPROX) multiplier
#
.PHONY: synth
synth: $(SYNTH_DIR)/$(MODULE_NAME).v
#
# Define target for simulation of the synthesized configurable (APPROX) multiplier
#
.PHONY: sim-synth
sim-synth:
	@$(MAKE) $(SIM_DIR)/$(MODULE_NAME)_synth.vcd
#
# Define target for GUI simulation of the configurable (APPROX) multiplier
#
.PHONY: sim-gui
sim-gui: sim
	gtkwave $(SIM_DIR)/$(MODULE_NAME).vcd $(WAVE_FILE) &
#
# Define target for GUI simulation of the synthesized configurable (APPROX) multiplier
#
.PHONY: sim-synth-gui
sim-synth-gui: sim-synth
	gtkwave $(SIM_DIR)/$(MODULE_NAME)_synth.vcd $(WAVE_FILE) &
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
		$(SRCS) $(TESTBENCH) \
		-D 'APPROX=$(APPROX)' \
		-D 'VCD_FILE="$@"' \
		-D 'ACC_TEST_VECTORS="$(TEST_VECTORS_ACC)"' \
		-D 'APPROX_TEST_VECTORS="$(TEST_VECTORS_APPROX)"'
	vvp $(SIM_DIR)/$*.iverilog
#
#------------------------------------------------------------------------------
#
# Synthesize Verilog designs (each variant is a standalone, unparameterized
# module - no shared submodules, so each is synthesized from its own file).
# Mirrors the same passes as ../../global_synth.tcl, minus chparam (there are
# no module parameters to fix here).
#
$(SYNTH_DIR)/%.v: %.v
	mkdir -p $(dir $@)
	yosys -p "read_verilog $<; hierarchy -check -top $*;; opt_expr;; proc;; opt_expr;; flatten;; opt_expr;; opt_clean;; opt;; write_verilog $@"
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
		$(SYNTH_DIR)/$*.v $(TESTBENCH) \
		-D 'APPROX=$(APPROX)' \
		-D 'VCD_FILE="$@"' \
		-D 'ACC_TEST_VECTORS="$(TEST_VECTORS_ACC)"' \
		-D 'APPROX_TEST_VECTORS="$(TEST_VECTORS_APPROX)"'
	vvp $(SIM_DIR)/$*_synth.iverilog
#
#------------------------------------------------------------------------------
#
# Clean directory
#
.PHONY: clean
clean:
	rm -rf $(SIM_DIR) $(SYNTH_DIR)
