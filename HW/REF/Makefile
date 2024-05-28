#-------------------------------------------------------
#
# Internal variables
#
PYTHON ?= python3
#
#-------------------------------------------------------
# 
# Variables
#
# Number of testvectors for the random tests
TV_NUM = 100
#
# Adder width and accuracy
WIDTH_ADD ?= 10
N_ADD ?= 0
#
# Multiplier accuracy parameters
N16 = 16
N8 = 8
N4 = 4
#
# Paths
ADD1_PATH = ../ADD/OneBit/tv_approx.tv
ADDN_PATH ?= ../ADD/Config/tv_config.tv
MUL2_PATH = ../MUL/2x2/tv_approx.tv
MUL4_PATH = ../MUL/4x4/tv_config.tv
MUL8_PATH = ../MUL/8x8/tv_config.tv
MUL16_PATH = ../MUL/16x16/tv_config.tv
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
	@echo "for options to take effect when execting targets."
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
	@echo "TV_NUM=<int>"
	@echo "    Specifies the number of random test vectors to be generated"
	@echo ""
	@echo "WIDTH_ADD=<int>"
	@echo "    Specifies the width of the test vectors of the n-Bit approx adder"
	@echo ""
	@echo "N_ADD=<int>"
	@echo "    Specifies the number of approximate bits of the n-Bit approx adder"
	@echo ""
	@echo "N16=<int>"
	@echo "    Specifies the number of appox. bits of the adders in the 16-Bit approx. multiplier"
	@echo ""
	@echo "N8=<int>"
	@echo "    Specifies the number of appox. bits of the adders in the 8-Bit approx. multiplier"
	@echo ""
	@echo "N4=<int>"
	@echo "    Specifies the number of appox. bits of the adders in the 4-Bit approx. multiplier"
	@echo ""
	@echo "*_PATH=<./path/to/filename>"
	@echo "    Specifies the relative path to the output files for the corresponding target"
	@echo ""
	@echo ""
	@echo "Targets"
	@echo "-------"
	@echo ""
	@echo "make help"
	@echo "    Print help text"
	@echo ""
	@echo "make all"
	@echo "    Generate all testvectors"
	@echo ""
	@echo "make add1"
	@echo "    Generate a truth table for the approximate 1-Bit adder."
	@echo ""
	@echo "make addN"
	@echo "    Generate random testvectors for the approximate N-Bit adder."
	@echo ""
	@echo "make mul2"
	@echo "    Generate a truth table for the approximate 2x2 multiplier."
	@echo ""
	@echo "make mul4"
	@echo "    Generate random testvectors for the approximate 4x4 multiplier."
	@echo ""
	@echo "make mul8"
	@echo "    Generate random testvectors for the approximate 8x8 multiplier."
	@echo ""
	@echo "make mul16"
	@echo "    Generate random testvectors for the approximate 16x16 multiplier."
	@echo ""
	@echo "make clean"
	@echo "    Delete generated files"
	@echo "    But does not delete testvector files written to other directories"
	@echo ""
#
#------------------------------------------------------------------------------
#
# Targets for creating different test vectors
#
.PHONY = add1 addN mul2 mul4 mul8 mul16 all
#
all: add1 addN mul2 mul4 mul8 mul16
#
add1: approxadd1.py
	$(PYTHON) approxadd1.py $(ADD1_PATH)
#
addN: approxaddN.py
	$(PYTHON) approxaddN.py $(TV_NUM) \
	$(WIDTH_ADD) $(N_ADD) $(ADDN_PATH)
#
mul2: approxmul2.py 
	$(PYTHON) approxmul2.py $(MUL2_PATH)
#
mul4: approxadd1.py approxaddN.py approxmul2.py approxmulN.py
	$(PYTHON) approxmulN.py $(TV_NUM) \
	4 $(N16) $(N8) $(N4) $(MUL4_PATH)
#
mul8: approxadd1.py approxaddN.py approxmul2.py approxmulN.py
	$(PYTHON) approxmulN.py $(TV_NUM) \
	8 $(N16) $(N8) $(N4) $(MUL8_PATH)
#
mul16: approxadd1.py approxaddN.py approxmul2.py approxmulN.py
	$(PYTHON) approxmulN.py $(TV_NUM) \
	16 $(N16) $(N8) $(N4) $(MUL16_PATH)
#
#-------------------------------------------------------
#
# Clean directory
#
.PHONY: clean
clean:
	rm -rf __pycache__ *.txt
#
#------------------------------------------------------------------------------