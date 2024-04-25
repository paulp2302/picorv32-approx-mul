#-------------------------------------------------------
# Internal variables
#
TESTBENCH ?= testbench.v # Change name when decided
#SBY_FILE ?= 2x2Mul.sby # If we want to use sby
#
#-------------------------------------------------------
#
# Simulation cell library
#
YOSYS_SIMCELLS := $(shell yosys-config --datdir/simcells.v)
#
#-------------------------------------------------------
#
# Variables
#
#VCD_FILES := $(patsubst t)
#
#-------------------------------------------------------
#
.PHONY: approx accurate
#
approx: Approx2x2Mul.v
#
accurate: Accurate2x2Mul.v
#
#-------------------------------------------------------
#
# Simulate Verilog designs
#
%.v: 
	iverilog \
		-l $(YOSYS_SIMCELLS) \
		-o $