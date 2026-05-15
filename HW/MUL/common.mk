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
	@echo "for options to take effect when executing targets."
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
	@echo "    Specifies the testbench to use for verifying the configurable $(WIDTH)-Bit multiplier."
	@echo ""
	@echo "NUM_TV=<int>"
	@echo "    Specifies the number of test vectors used in the automated testbench."
	@echo ""
	@echo ""
	@echo "Targets"
	@echo "-------"
	@echo ""
	@echo "make tv"
	@echo "    Generate the testvector file."
	@echo ""
	@echo "make sim"
	@echo "    Simulate the configurable $(WIDTH)-Bit multiplier."
	@echo ""
	@echo "make synth"
	@echo "    Synthesize the configurable $(WIDTH)-Bit multiplier with the current parameters."
	@echo ""
	@echo "make sim-synth"
	@echo "    Simulate the synthesized configurable $(WIDTH)-Bit multiplier."
	@echo ""
	@echo "make clean"
	@echo "    Delete generated files"
	@echo ""
#
#------------------------------------------------------------------------------
#
# Display current configuration of the environment variables
#
.PHONY: info
info:
	@echo "========================================"
	@echo " Current Build Configuration"
	@echo "========================================"
	@echo " Top Module  : $(TOP_MODULE)"
	@echo " Bit Width   : $(WIDTH)"
	@echo " Test Vectors: $(NUM_TV)"
	@echo "----------------------------------------"
	@echo " Approx Bits (N16) : $(N16)"
	@echo " Approx Bits (N8)  : $(N8)"
	@echo " Approx Bits (N4)  : $(N4)"
	@echo "----------------------------------------"
	@echo " Param Suffix: $(PARAM_SUFFIX)"
	@echo "========================================"
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
	@$(MAKE) $(SIM_DIR)/$(TOP_MODULE)_$(PARAM_SUFFIX).vcd MODE=0
#
# Define target for synthesis
#
.PHONY: synth
synth: $(SYNTH_DIR)/$(TOP_MODULE)_$(PARAM_SUFFIX).v
#
# Define target for simulation of the synthesized module
#
.PHONY: sim-synth
sim-synth: 
	@$(MAKE) $(SIM_DIR)/$(TOP_MODULE)_$(PARAM_SUFFIX)_synth.vcd MODE=1
#
# Define target for GUI simulation
#
.PHONY: sim-gui
sim-gui: sim
	gtkwave $(SIM_DIR)/$(TOP_MODULE)_$(PARAM_SUFFIX).vcd $(WAVE_FILE) &

#
# Define target for GUI simulation of synthesized module
#
.PHONY: sim-synth-gui
sim-synth-gui: sim-synth
	gtkwave $(SIM_DIR)/$(TOP_MODULE)_$(PARAM_SUFFIX)_synth.vcd $(WAVE_FILE) &
#------------------------------------------------------------------------------
#
# Generate the testvector file
#
$(TEST_VECTORS):
	mkdir -p $(SIM_DIR)
	@echo "Generating $(NUM_TV) test vectors for $(TOP_MODULE)"
	@echo "Use configuration N16=$(N16) N8=$(N8) N4=$(N4)"
	python3 $(REF_SCRIPT) $(NUM_TV) $(WIDTH) $(N16) $(N8) $(N4) $@
#
#------------------------------------------------------------------------------
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
		-D 'N16=$(N16)' \
		-D 'N8=$(N8)' \
		-D 'N4=$(N4)' \
		-D 'NUM_TV=$(NUM_TV)' \
		-D 'TEST_VECTORS="$(TEST_VECTORS)"'
	vvp $(SIM_DIR)/$*.iverilog
#
#------------------------------------------------------------------------------
#
# Synthesize Verilog designs
#
$(SYNTH_DIR)/%.v: $(CONFIGMUL_TCL) $(SRCS)
	mkdir -p $(dir $@)
	TOP_MODULE=$(TOP_MODULE) MODULE_PARAMS="$(MODULE_PARAMS)" \
	yosys -p "read_verilog $(SRCS); tcl $<; write_verilog $@"
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
		-D 'TEST_VECTORS="$(TEST_VECTORS)"'
	vvp $(SIM_DIR)/$*_synth.iverilog
#
#------------------------------------------------------------------------------
#
# Clean directory
#
.PHONY: clean
clean: 
	rm -rf $(SIM_DIR) $(SYNTH_DIR)
#
#------------------------------------------------------------------------------
