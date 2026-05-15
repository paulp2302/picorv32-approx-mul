#==============================================================================
# PICO-RV32 APPROXIMATE MULTIPLIER: MASTER BUILD SYSTEM
#==============================================================================

# Multiplier configurations (Default: Fully Accurate)
N16 ?= 0
N8  ?= 0
N4  ?= 0

# Pass parameters to sub-makes
export N16
export N8
export N4

CUSTOM_MUL_PATH := ./HW/synth/custom_mul.v

#------------------------------------------------------------------------------
# HARDWARE GENERATION TARGETS (Approximate Multiplier)
#------------------------------------------------------------------------------
.PHONY: mul-synth mul-pnr
mul-synth: $(CUSTOM_MUL_PATH)

mul-pnr:
	@echo "=> Running Out-Of-Context Benchmark for Multiplier..."
	$(MAKE) -C HW pnr N16=$(N16) N8=$(N8) N4=$(N4)

$(CUSTOM_MUL_PATH):
	@echo "=> Building Custom Multiplier RTL (N16=$(N16), N8=$(N8), N4=$(N4))..."
	$(MAKE) -C HW synth N16=$(N16) N8=$(N8) N4=$(N4)

#------------------------------------------------------------------------------
# SYSTEM INTEGRATION TARGETS (PicoSoC + Custom Multiplier)
#------------------------------------------------------------------------------
.PHONY: sim view bitstream prog
sim: $(CUSTOM_MUL_PATH) 
	@echo "=> Compiling Firmware and Running System Simulation..."
	$(MAKE) -C picorv32/picosoc sim

view:
	@echo "=> Opening Waveforms in GTKWave..."
	$(MAKE) -C picorv32/picosoc view

synsim: $(CUSTOM_MUL_PATH)
	@echo "=> Compiling Firmware and Running Simulation of synthesized System..."
	$(MAKE) -C picorv32/picosoc synsim

bitstream: $(CUSTOM_MUL_PATH)
	@echo "=> Running Full System Place-and-Route (PicoSoC + Multiplier)..."
	$(MAKE) -C picorv32/picosoc prog_bram

prog: bitstream
	@echo "=> Flashing to iCEbreaker Board..."
	$(MAKE) -C picorv32/picosoc prog_flash

#------------------------------------------------------------------------------

.PHONY: clean
clean:
	@echo "=> Cleaning Hardware Artifacts..."
	$(MAKE) -C HW clean
	@echo "=> Cleaning System Artifacts..."
	$(MAKE) -C picorv32/picosoc clean

#------------------------------------------------------------------------------

.PHONY: help
help:
	@echo "=========================================================="
	@echo " Master Build System: Approx-Mul RISC-V SoC"
	@echo "=========================================================="
	@echo " Usage: make <target> [N16=val] [N8=val] [N4=val]"
	@echo ""
	@echo " Hardware IP Targets:"
	@echo "   mul-synth  : Generate isolated custom_mul.v in synth/"
	@echo "   mul-pnr    : Benchmark the multiplier in isolation (Fmax/LUTs)"
	@echo ""
	@echo " Full System Targets (PicoSoC):"
	@echo "   sim       : Simulate the full SoC running firmware.c"
	@echo "   bitstream : Synthesize and route the full SoC for iCEbreaker"
	@echo "   prog      : Flash the bitstream to a physical board"
	@echo ""
	@echo " Clean:"
	@echo "   clean     : Remove all build artifacts across all folders"
	@echo "=========================================================="
