# .section .text
# .globl _start
# _start:
#   li a0, 1
#   la a1, message
#   li a2, 14

#   addi a7, zero, 64
#   ecall

#   li a0, 0
#   addi a7, zero, 93
#   ecall

# .section .data
# message:
#   .asciz "Hello World!\n"

.equ STDOUT,    1
.equ WRITE,     64
.equ EXIT,      93

.globl  _start
_start:
        li      a0, STDOUT
        auipc   a1, 0
        addi    a1, a1, 28 # offset from the auipc to the string
        li      a2, 14
        li      a7, WRITE
        ecall
        li      a7, EXIT
        ecall
        .ascii  "Hello RISC-V!\n"