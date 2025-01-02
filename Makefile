TOOLCHAIN_PREFIX ?= riscv64-unknown-elf-

FILE = uart

OBJCOPY           = $(TOOLCHAIN_PREFIX)objcopy
LD                = $(TOOLCHAIN_PREFIX)ld
AS                = $(TOOLCHAIN_PREFIX)as
GCC               = $(TOOLCHAIN_PREFIX)gcc

all: $(FILE).s
	$(GCC)  -O0 -ggdb -nostdlib -march=rv32i -mabi=ilp32 -Wl,-Tmain.ld $(FILE).s -o $(FILE).elf
	$(OBJCOPY) -O binary $(FILE).elf $(FILE).bin
	xxd -e -c 4 -g 4 $(FILE).bin

obj: $(FILE).s
	$(GCC) -O0 -ggdb -nostartfiles -nostdlib -march=rv32i -mabi=ilp32 -Wl,-Tmain.ld $(FILE).s -o $(FILE)

obj2: $(FILE).s
	$(AS) -o $(FILE).o $(FILE).s
	$(LD) -o $(FILE).elf $(FILE).o
	
run: 
	qemu-riscv32 ./$(FILE)

run2:
	# qemu-system-riscv32 -nographic -machine virt -kernel $(FILE).elf -serial mon:stdio
	qemu-system-riscv32 -S -M virt -nographic -bios none -kernel $(FILE).elf -serial mon:stdio -gdb tcp::1234

debug:
	qemu-system-riscv32 -S -M virt -nographic -bios none -kernel $(FILE).elf -gdb tcp::1234

gdb:
	gdb-multiarch $(FILE).elf -ex "target serial mon:stdio" -ex "break _start" -ex "continue" -q

.PHONY: clean
clean:
	rm -rf *.o *.elf *.bin *.out .gdb_history