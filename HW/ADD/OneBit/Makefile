#-------------------------------------------------------
# Internal variables
#
TESTBENCH ?= tb_OneBit.v # Change name when decided
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
approx: ApproxAddOne
#
accurate: AccurateAddOne
#
#-------------------------------------------------------
#
ApproxAddOne:	
	iverilog \
		-l $(YOSYS_SIMCELLS) \
		-o ApproxAddOne ApproxAddOneBit.v \
		$(TESTBENCH) \
		-D TEST_MODE=1
	vvp ApproxAddOne

AccurateAddOne:	
	iverilog \
		-l $(YOSYS_SIMCELLS) \
		-o AccurateAddOne AccurateAddOneBit.v \
		$(TESTBENCH) \
		-D TEST_MODE=0
	vvp AccurateAddOne

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
	rm -rf  AccurateAddOne ApproxAddOne
	rm -rf *.vcd
