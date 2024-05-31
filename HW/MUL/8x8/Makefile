#-------------------------------------------------------
# Internal variables
#
TESTBENCH ?= testbench.v # Change name when decided
#SBY_FILE ?= 4x4Mul.sby # If we want to use sby
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
approx1: Approx8x8MulV1
#
approx2: Approx8x8MulV2
#
approx3: Approx8x8MulV3
#
accurate: Accurate8x8Mul
#
#-------------------------------------------------------
#
Approx8x8MulV1:	
	iverilog \
		-l $(YOSYS_SIMCELLS) \
		-o Approx8x8MulV1 ../2x2/Approx2x2Mul.v \
		../4x4/Approx4x4MulV1.v \
		Approx8x8MulV1.v \
		$(TESTBENCH) \
		-D TEST_MODE=1
	vvp Approx8x8MulV1

Approx8x8MulV2:	
	iverilog \
		-l $(YOSYS_SIMCELLS) \
		-o Approx8x8MulV2 ../2x2/Approx2x2Mul.v \
		../4x4/Approx4x4MulV2.v \
		../../ADD/OneBit/ApproxAddOneBit.v \
		../../ADD/MultiBit/ApproxAddMultiBit.v \
		Approx8x8MulV2.v \
		$(TESTBENCH) \
		-D TEST_MODE=2
	vvp Approx8x8MulV2

Approx8x8MulV3:	
	iverilog \
		-l $(YOSYS_SIMCELLS) \
		-o Approx8x8MulV3 ../2x2/Approx2x2Mul.v \
		../4x4/Approx4x4MulV1.v \
		../../ADD/OneBit/ApproxAddOneBit.v \
		../../ADD/MultiBit/ApproxAddMultiBit.v \
		Approx8x8MulV3.v \
		$(TESTBENCH) \
		-D TEST_MODE=3
	vvp Approx8x8MulV3

Accurate8x8Mul:	
	iverilog \
		-l $(YOSYS_SIMCELLS) \
		-o Accurate8x8Mul ../2x2/Accurate2x2Mul.v \
		../4x4/Accurate4x4Mul.v \
		Accurate8x8Mul.v \
		$(TESTBENCH) \
		-D TEST_MODE=0
	vvp Accurate8x8Mul

Config8x8Mul:	
	iverilog \
		-l $(YOSYS_SIMCELLS) \
		-o Config8x8Mul ../2x2/Approx2x2Mul.v \
		../4x4/Config4x4Mul.v ../../ADD/OneBit/ApproxAddOneBit.v ../../ADD/Config/ConfigAddMultiBit.v \
		../../ADD/OneBit/AccurateAddOneBit.v Config8x8Mul.v \
		$(TESTBENCH) \
		-D TEST_MODE=0
	vvp Config8x8Mul

#-------------------------------------------------------
#
# Simulate Verilog designs
#
#.PHONY: test
#test:	
#	iverilog \
#		-l $(YOSYS_SIMCELLS) \
#		-o test Approx4x4Mul.v $(TESTBENCH)
#	vvp test
#
#-------------------------------------------------------
#
# Clean directory
#
.PHONY: clean
clean: 
	rm -rf test *.vcd Accurate8x8Mul Approx8x8MulV1 Approx8x8MulV2 Approx8x8MulV3 Config8x8Mul
