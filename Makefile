TOOLCHAIN_PREFIX ?= riscv64-unknown-elf-

FILE = uart

OBJCOPY           = $(TOOLCHAIN_PREFIX)objcopy
LD                = $(TOOLCHAIN_PREFIX)ld
AS                = $(TOOLCHAIN_PREFIX)as
GCC               = $(TOOLCHAIN_PREFIX)gcc

all: $(FILE).s
	$(GCC) -O0 -ggdb -nostdlib -march=rv32i -mabi=ilp32 -Wl,-Tmain.ld $(FILE).s -o $(FILE).elf
	$(OBJCOPY) -O binary $(FILE).elf $(FILE).bin
	xxd -e -c 4 -g 4 $(FILE).bin

obj: $(FILE).s
	$(GCC) -O0 -ggdb -nostartfiles -nostdlib -march=rv32i -mabi=ilp32 -Wl,-T main.ld $(FILE).s -o $(FILE)

obj2: $(FILE).s
	$(AS) -march=rv32i -mabi=ilp32 -o $(FILE).o $(FILE).s
	$(LD) -m elf32lriscv -T main.ld -o $(FILE).elf $(FILE).o
	# $(GCC)  -nostdlib -march=rv32i -mabi=ilp32 -Wl,-T main.ld $(FILE).s -o $(FILE).elf
    # $(OBJCOPY) -O binary $(FILE).elf $(FILE).bin
	
obj3: $(FILE).s
	$(AS) -march=rv32i -mabi=ilp32 $(FILE).s -o $(FILE).o
	$(GCC) -T main.ld -march=rv32i -mabi=ilp32 -nostdlib -static -o $(FILE).elf $(FILE).o
	
run: 
	qemu-riscv32 ./$(FILE)

run2:
	qemu-system-riscv32 -nographic -machine virt -bios none -kernel $(FILE).elf
	# qemu-system-riscv32 -machine virt -kernel $(FILE).elf -nographic -bios none

run3:
	@echo "Ctrl-A C for QEMU console, then quit to exit"
	qemu-system-riscv32 -nographic -serial mon:stdio -machine virt -bios none -kernel $(FILE).elf

debug:
	qemu-system-riscv32 -S -M virt -nographic -bios none -kernel $(FILE).elf -gdb tcp::1234

gdb:
	gdb-multiarch $(FILE).elf -ex "target remote :1234" -ex "break _start" -ex "continue" -q

.PHONY: clean
clean:
	rm -rf *.o *.elf *.bin *.out .gdb_history
