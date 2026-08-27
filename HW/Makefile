#------------------------------------------------------------------------------
# Top Level Synthesis of the PicoRV32 PCPI approximate multiplier
#------------------------------------------------------------------------------
#
#------------------------------------------------------------------------------
# Module Identity and Parameters
#------------------------------------------------------------------------------
TOP_MODULE := custom_mul
BENCHMARK_MODULE := benchmark_wrapper

# Multiplier accuracies (defaults are accurate)
N16 ?= 0
N8  ?= 0
N4  ?= 0

MODULE_PARAMS := -set N16 $(N16) -set N8 $(N8) -set N4 $(N4)

# Define the target device for nextpnr
DEVICE := up5k
PACKAGE := sg48

# Set an aggressive target frequency to force optimization
TARGET_FREQ := 20

#------------------------------------------------------------------------------
# Directories and Paths
#------------------------------------------------------------------------------
SYNTH_DIR := ./synth
SYNTH_OUT := $(SYNTH_DIR)/$(TOP_MODULE).v
SYNTH_JSON := $(SYNTH_DIR)/$(TOP_MODULE).json
ASC_FILE   := $(SYNTH_DIR)/$(TOP_MODULE).asc
REPORT_FILE := $(SYNTH_DIR)/report.json
SRC_DIRS := .
GLOBAL_TCL := global_synth.tcl
YOSYS_SIMCELLS := $(shell yosys-config --datdir/simcells.v)

# Define internal variable for the different sources
SRCS := $(shell find $(SRC_DIRS) -name '*.v' -and -not -name '*testbench.v' \
		-and -not -name '$(TESTBENCH)' | grep -v '/sim/' | grep -v '/synth/')
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
	@echo "make pnr"
	@echo "    Place and route the standalone configurable 16-Bit multiplier."
	@echo "    Determines the isolated resource usage and maximum frequncy."
	@echo ""
	@echo "make clean"
	@echo "    Delete generated files"
	@echo ""
#
#------------------------------------------------------------------------------

# Define target for the synthesis of the configurable multiplier
.PHONY: synth
synth: $(SYNTH_OUT)

# Define target for the standalone place and route
.PHONY: pnr
pnr: $(ASC_FILE)

#------------------------------------------------------------------------------

# Synthesize Verilog designs
$(SYNTH_OUT): $(SRCS) $(GLOBAL_TCL)
	mkdir -p $(SYNTH_DIR)
	TOP_MODULE=$(TOP_MODULE) MODULE_PARAMS="$(MODULE_PARAMS)" \
	yosys -p "read_verilog $(SRCS); tcl $(GLOBAL_TCL); write_verilog $@"
	@echo "Successfully built: $@"

# Create the JSON
$(SYNTH_JSON): $(SRCS) benchmark.v $(GLOBAL_TCL)
	mkdir -p $(SYNTH_DIR)
	TOP_MODULE=$(BENCHMARK_MODULE) MODULE_PARAMS="$(MODULE_PARAMS)" \
	yosys -p "read_verilog $(SRCS); tcl $(GLOBAL_TCL); synth_ice40 -top $(BENCHMARK_MODULE) -json $@"

# Place and route step
$(ASC_FILE): $(SYNTH_JSON)
	nextpnr-ice40 --$(DEVICE) --package $(PACKAGE) --json $< --asc $@ --freq $(TARGET_FREQ) --report $(REPORT_FILE)
	@echo "=================================================================="
	@echo " Look at the NextPNR log above for 'ICESTORM_LC' to get LUT count!"
	@echo " Look at the NextPNR log above for 'Max frequency' to get Fmax!"
	@echo " Structured data also written to: $(REPORT_FILE)"
	@echo "=================================================================="

#------------------------------------------------------------------------------

# Clean directory
.PHONY: clean
clean: 
	rm -rf $(SYNTH_DIR)
	$(MAKE) -C REF clean
	$(MAKE) -C MUL/2x2 clean
	$(MAKE) -C MUL/4x4 clean
	$(MAKE) -C MUL/8x8 clean
	$(MAKE) -C MUL/16x16 clean
	$(MAKE) -C ADD/OneBit clean
	$(MAKE) -C ADD/Config clean

#------------------------------------------------------------------------------
