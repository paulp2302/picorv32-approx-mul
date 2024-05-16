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
.PHONY: test
#
#
#-------------------------------------------------------
#
test:	
	iverilog \
		-l $(YOSYS_SIMCELLS) \
		-o pcpi pcpi.v \
		$(TESTBENCH) 
	vvp pcpi
#
#
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
	rm -rf test %.vcd pcpi
