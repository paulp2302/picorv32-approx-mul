#-------------------------------------------------------
# Python Reference Implementation & Algorithmic Evaluation
#-------------------------------------------------------
PYTHON ?= python3

# Default parameters for plot generation
TV_NUM ?= 10000
WIDTH  ?= 16
N16    ?= 0
N8     ?= 0
N4     ?= 0

#------------------------------------------------------------------------------
# Help target
#------------------------------------------------------------------------------
.PHONY: help
help:
	@echo "=========================================================="
	@echo " Reference Model & Statistical Evaluation"
	@echo "=========================================================="
	@echo "This directory contains the Python algorithmic models."
	@echo "Test vectors are generated dynamically by the HW Makefiles."
	@echo ""
	@echo "Use this Makefile to generate plots for Design Space Exploration."
	@echo ""
	@echo "Targets:"
	@echo "  make plots    : Generate accuracy plots for a configuration."
	@echo "  make clean    : Remove Python cache and plots directory."
	@echo ""
	@echo "Parameters:"
	@echo "  TV_NUM (default: 10000) : Sample size for statistical evaluation"
	@echo "  WIDTH  (default: 16)    : Bit-width of the multiplier (4, 8, 16)"
	@echo "  N16, N8, N4 (default: 0): Approximate adder configuration"
	@echo "=========================================================="

#------------------------------------------------------------------------------
# Statistical Evaluation & Plotting
#------------------------------------------------------------------------------
.PHONY: plots
plots:
	@echo "Running Design Space Exploration..."
	@echo "Evaluating $(WIDTH)-bit Multiplier: N16=$(N16), N8=$(N8), N4=$(N4)"
	$(PYTHON) exactVSapproxMul.py $(TV_NUM) $(WIDTH) $(N16) $(N8) $(N4)

#------------------------------------------------------------------------------
# Clean directory
#------------------------------------------------------------------------------
.PHONY: clean
clean:
	rm -rf __pycache__ plots/
