.equ STDOUT, 1
.equ WRITE, 64
.equ EXIT, 93

.section .text
.globl _start
_start:
	li a0, STDOUT       # File descriptor (stdout)
	la a1, message      # Address of the message
	li a2, 14           # Length of the message

	li a7, WRITE        # Syscall number for write
	ecall

	li a0, 0            # Exit code
	li a7, EXIT         # Syscall number for exit
	ecall

.section .data
message:
	.ascii "Hello World!\n"
	

# $(GCC)  -nostdlib -march=rv32i -mabi=ilp32 -Wl,-Tmain.ld $(FILE).s -o $(FILE).elf
    # $(OBJCOPY) -O binary $(FILE).elf $(FILE).bin