#-------------------------------------------------------
# Internal variables
#
TESTBENCH ?= tb_MultiBit.v # Change name when decided
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
approx: ApproxAddMulti
#
accurate: AccurateAddMulti
#
#-------------------------------------------------------
#
ApproxAddMulti:	
	iverilog \
		-l $(YOSYS_SIMCELLS) \
		-o ApproxAddMulti ApproxAddOneBit.v ApproxAddMultiBit.v \
		$(TESTBENCH) \
		-D TEST_MODE=1
	vvp ApproxAddMulti

AccurateAddMulti:	
	iverilog \
		-l $(YOSYS_SIMCELLS) \
		-o AccurateAddMulti AccurateAddOneBit.v AccurateAddMultiBit.v \
		$(TESTBENCH) \
		-D TEST_MODE=0
	vvp AccurateAddMulti

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
	rm -rf  AccurateAddMulti ApproxAddMulti
	rm -rf *.vcd
