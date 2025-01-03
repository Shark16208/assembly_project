# .section .text
# .globl _start
# _start:
#     la sp, __stack_top   # Set the stack pointer
#     # add ra, pc, zero     # Save the stack pointer in s0 as frame pointer
#     # addi ra, ra, 12   # Save the return address in ra
#     # add sp, sp, -4       # Reserve space for the return address
#     # sw ra, 0(sp)         # Save the return address
#     # jal ra, get_put
#     la a0, message
#     call put_str

# end_loop:
#     ebreak
#     li a0, 0            # Exit code 0
#     li a7, 93 # Syscall number for exit
#     ecall               # Make the syscall
#     j end_loop

# # get_put:
# #     addi sp, sp, -8       # Reserve space for the return address
# #     sw ra, 4(sp)          # Save the return address
# #     sw s0, 0(sp)          # Save the old stack pointer
# #     call getchar
# #     call putchar
# #     lw s0, 0(sp)          # Restore the old stack pointer
# #     lw ra, 4(sp)          # Restore the return address
# #     addi sp, sp, 8        # Free the reserved space
# #     ret

# # getchar:
# #     lw a1, UART_DATA      # UART Data register
# #     li a0, 0              # Initialize result register
# # uart_read_wait:
# #     lb t1, 5(a1)    # Check UART status register
# #     andi t1, t1, 1        # Mask for "data available" bit
# #     beqz t1, uart_read_wait
# #     lb a0, 0(a1)      # Load the received character
# #     ret
# get_char:
#     addi sp, sp, -4
#     sw ra, 0(sp)
#     li a1, 0x10000000
# get_char_loop:
#     lb a2, 5(a1)
#     andi a2, a2, 0x01
#     beqz a2, get_char_loop
# get_char_done:
#     lb a0, 0(a1)
#     lw ra, 0(sp)
#     addi sp, sp, 4
#     ret

# # putchar:
# #     lw a1, UART_DATA      # UART Data register
# #     li a0, 0              # Initialize result register
# # uart_write_wait:
# #     lb t1, 5(a1)    # Check UART status register
# #     andi t1, t1, 0x40        # Mask for "transmitter ready" bit
# #     beqz t1, uart_write_wait
# #     sb a0, 0(a1)      # Write the character
# #     ret

# put_char:
#     addi sp, sp, -4
#     sw ra, 0(sp)
#     li a1, 0x10000000
# put_char_loop:
#     lb a2, 5(a1)
#     andi a2, a2, 0x40
#     beqz a2, put_char_loop
# put_char_done:
#     sb a0, 0(a1)
#     lw ra, 0(sp)
#     addi sp, sp, 4
#     ret

# # putstring:
# #     addi sp, sp, -8
# #     sw a0, 4(sp)
# #     sw ra, 0(sp)
# #     lb a1, 0(a0)
# #     beqz a1, putstring_end
# # putstring_loop:
# #     sw a0, 4(sp)
# #     mv a0, a1
# #     call putchar
# #     lw a0, 4(sp)
# #     addi a0, a0, 1
# #     lb a1, 0(a0)
# #     bnez a1, putstring_loop
# # putstring_end:
# #     lw ra, 0(sp)
# #     lw a0, 4(sp)
# #     addi sp, sp, 8
# #     ret

# put_str:
# # push a0, ra to stack
#     addi sp, sp, -8
#     sw a0, 0(sp)
#     sw ra, 4(sp)
# # load the first byte
#     lb a1, 0(a0)
#     beqz a1, put_str_done
# put_str_loop:
# # save a0 in stack
#     sw a0, 0(sp)
# # put cur char
#     mv a0, a1
#     call put_char
# # load a0 from stack
#     lw a0, 0(sp)
#     addi a0, a0, 1
# # load next byte, if not zero, continue loop
#     lb a1, 0(a0)
#     bnez a1, put_str_loop
# put_str_done:
# # pop a0, ra from stack (only store ra)
#     lw ra, 4(sp)
#     addi sp, sp, 8
#     ret

# .section .data
# UART_DATA:
#     .word 0x10000000
# STACK_START:
#     .word 0x80001000
# message:
# 	.string "Hello World!\n"

# .section .bss
# UART_STATUS:
#     .word 0


.section .text
.globl _start
_start:
    # Initialize the stack pointer
    li sp, 0x80001000

    # Load address of message
    la a0, message
    jal ra, put_str

end_loop:
    # Exit the program
    li a0, 0            # Exit code 0
    li a7, 93           # Syscall number for exit
    ecall               # Make the syscall
    j end_loop

put_str:
    # Save registers
    addi sp, sp, -8
    sw a0, 0(sp)
    sw ra, 4(sp)

    # Load first byte of string
    lb a1, 0(a0)
    beqz a1, put_str_done

put_str_loop:
    # Save a0 on stack
    sw a0, 0(sp)

    # Print current character
    mv a0, a1
    jal ra, put_char

    # Restore a0 and increment pointer
    lw a0, 0(sp)
    addi a0, a0, 1

    # Load next byte
    lb a1, 0(a0)
    bnez a1, put_str_loop

put_str_done:
    # Restore registers
    lw ra, 4(sp)
    addi sp, sp, 8
    ret

put_char:
    # Save registers
    addi sp, sp, -4
    sw ra, 0(sp)

    # UART write loop
    li a1, 0x10000000
put_char_loop:
    lb a2, 5(a1)
    andi a2, a2, 0x40  # Transmitter ready
    beqz a2, put_char_loop
    sb a0, 0(a1)

    # Restore registers
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

.section .data
message:
    .string "Hello World!\r\n"