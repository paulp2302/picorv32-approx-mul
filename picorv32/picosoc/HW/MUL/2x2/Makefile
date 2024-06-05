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
# TODO
# Variables
#
#VCD_FILES := $(patsubst t)
#
#-------------------------------------------------------
# TODO
.PHONY: approx accurate
#
approx: Approx2x2Mul
#
accurate: Accurate2x2Mul
#
#-------------------------------------------------------
#
Approx2x2Mul:	
	iverilog \
		-l $(YOSYS_SIMCELLS) \
		-o Approx2x2Mul Approx2x2Mul.v \
		$(TESTBENCH) \
		-D TEST_MODE=1
	vvp Approx2x2Mul

Accurate2x2Mul:	
	iverilog \
		-l $(YOSYS_SIMCELLS) \
		-o Accurate2x2Mul Accurate2x2Mul.v \
		$(TESTBENCH) \
		-D TEST_MODE=0
	vvp Accurate2x2Mul

#-------------------------------------------------------
#
# Simulate Verilog designs
#
#.PHONY: test
#test:	
#	iverilog \
#		-l $(YOSYS_SIMCELLS) \
#		-o test Approx2x2Mul.v $(TESTBENCH)
#	vvp test
#
#-------------------------------------------------------
#
# Clean directory
#
.PHONY: clean
clean: 
	rm -rf test %.vcd Accurate2x2Mul Approx2x2Mul
