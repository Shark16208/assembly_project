.section .text
.globl _start
_start:
    li sp, 0x80001000   # Set the stack pointer
    # add ra, pc, zero     # Save the stack pointer in s0 as frame pointer
    # addi ra, ra, 12   # Save the return address in ra
    # add sp, sp, -4       # Reserve space for the return address
    # sw ra, 0(sp)         # Save the return address
    # jal ra, get_put
    la a0, message
    call putstring

end_loop:
    li a0, 0            # Exit code 0
    li a7, 93 # Syscall number for exit
    ecall               # Make the syscall
    j end_loop

# get_put:
#     addi sp, sp, -8       # Reserve space for the return address
#     sw ra, 4(sp)          # Save the return address
#     sw s0, 0(sp)          # Save the old stack pointer
#     call getchar
#     call putchar
#     lw s0, 0(sp)          # Restore the old stack pointer
#     lw ra, 4(sp)          # Restore the return address
#     addi sp, sp, 8        # Free the reserved space
#     ret

# getchar:
#     lw a1, UART_DATA      # UART Data register
#     li a0, 0              # Initialize result register
# uart_read_wait:
#     lb t1, 5(a1)    # Check UART status register
#     andi t1, t1, 1        # Mask for "data available" bit
#     beqz t1, uart_read_wait
#     lb a0, 0(a1)      # Load the received character
#     ret

putchar:
    lw a1, UART_DATA      # UART Data register
    li a0, 0              # Initialize result register
uart_write_wait:
    lb t1, 5(a1)    # Check UART status register
    andi t1, t1, 0x40        # Mask for "transmitter ready" bit
    beqz t1, uart_write_wait
    sb a0, 0(a1)      # Write the character
    ret

putstring:
    addi sp, sp, -8
    sw a0, 4(sp)
    sw ra, 0(sp)
    lb a1, 0(a0)
    beqz a1, putstring_end
putstring_loop:
    sw a0, 4(sp)
    mv a0, a1
    call putchar
    lw a0, 4(sp)
    addi a0, a0, 1
    lb a1, 0(a0)
    bnez a1, putstring_loop
putstring_end:
    lw ra, 0(sp)
    lw a0, 4(sp)
    addi sp, sp, 8
    ret

.section .data
UART_DATA:
    .word 0x10000000
STACK_START:
    .word 0x80001000
message:
	.ascii "Hello World!\n"

.section .bss
UART_STATUS:
    .word 0
