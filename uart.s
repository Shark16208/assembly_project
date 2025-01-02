# .equ UART_DATA, 0x10000000
# .equ UART_STATUS, 0x10000004
# .equ STACK_START, 0x80001000

.section .text
.globl _start
_start:
    lw sp, STACK_START   # Set the stack pointer
    call get_put
    ebreak

get_put:
    addi sp, sp, -8       # Reserve space for the return address
    sw ra, 4(sp)          # Save the return address
    sw sp, 0(sp)          # Save the old stack pointer
    call getchar
    call putchar
    lw sp, 0(sp)          # Restore the old stack pointer
    lw ra, 4(sp)          # Restore the return address
    addi sp, sp, 8        # Free the reserved space
    ret

getchar:
    lw a1, UART_DATA      # UART Data register
    li a0, 0              # Initialize result register
uart_read_wait:
    lb t1, 5(a1)    # Check UART status register
    andi t1, t1, 1        # Mask for "data available" bit
    beqz t1, uart_read_wait
    lb a0, 0(a1)      # Load the received character
    ret

putchar:
    lw a1, UART_DATA      # UART Data register
    li a0, 0              # Initialize result register
uart_write_wait:
    lb t1, 5(a1)    # Check UART status register
    andi t1, t1, 0x40        # Mask for "transmitter ready" bit
    beqz t1, uart_write_wait
    sb a0, 0(a1)      # Write the character
    ret

.section .data
UART_DATA:
    .word 0x10000000
STACK_START:
    .word 0x80001000

.section .bss
UART_STATUS:
    .word 0