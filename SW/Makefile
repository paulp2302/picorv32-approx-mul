# Select your RISC-V compiler here (riscv32i/riscv32im/riscv32ic/riscv32imc)
RISCV_ISA = i

TOOLCHAIN_PREFIX = /opt/riscv32$(RISCV_ISA)/bin/riscv32-unknown-elf-

CFLAGS = -MD -O3 -mabi=ilp32 -march=rv32$(RISCV_ISA) -DTIME -DRISCV
#OBJS = main.o

###############################################################

all: main.hex

size: main.elf
	$(TOOLCHAIN_PREFIX)size main.elf

main.elf: main.c
	$(TOOLCHAIN_PREFIX)gcc $(CFLAGS) -o $@ $< custom_inst.c
	chmod -x $@

main.hex: main.elf
	$(TOOLCHAIN_PREFIX)objcopy -O verilog $< $@
	chmod -x $@

run: main.hex

clean:
	rm -rf *.o *.d main.elf dhry.bin main.hex 

%.o: %.c
	$(TOOLCHAIN_PREFIX)gcc -c $(CFLAGS) $<

%.o: %.S
	$(TOOLCHAIN_PREFIX)gcc -c $(CFLAGS) $<


.PHONY: test clean size run all



