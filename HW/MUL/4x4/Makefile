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
.PHONY: approx1 approx2 accurate
#
approx1: Approx4x4MulV1
#
approx2: Approx4x4MulV2
#
accurate: Accurate4x4Mul
#
#-------------------------------------------------------
#
Approx4x4MulV1:	
	iverilog \
		-l $(YOSYS_SIMCELLS) \
		-o Approx4x4MulV1 ../2x2/Approx2x2Mul.v \
		Approx4x4MulV1.v \
		$(TESTBENCH) \
		-D TEST_MODE=1
	vvp Approx4x4MulV1

Approx4x4MulV2:	
	iverilog \
		-l $(YOSYS_SIMCELLS) \
		-o Approx4x4MulV2 ../2x2/Approx2x2Mul.v \
		../../ADD/OneBit/ApproxAddOneBit.v \
		../../ADD/MultiBit/ApproxAddMultiBit.v \
		Approx4x4MulV2.v \
		$(TESTBENCH) \
		-D TEST_MODE=2
	vvp Approx4x4MulV2

Accurate4x4Mul:	
	iverilog \
		-l $(YOSYS_SIMCELLS) \
		-o Accurate4x4Mul ../2x2/Accurate2x2Mul.v \
		Accurate4x4Mul.v \
		$(TESTBENCH) \
		-D TEST_MODE=0
	vvp Accurate4x4Mul

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
	rm -rf test *.vcd Accurate4x4Mul Approx4x4MulV1 Approx4x4MulV2
