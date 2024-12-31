.section .data
syscalls:
  .equ STDOUT,    1
  .equ WRITE,     64
  .equ EXIT,      93
message:
  .ascii "Hello World!\n"

.section .text
.globl _start
_start:
  li a0, STDOUT
  la a1, message
  li a2, 14

  li a7, WRITE
  ecall

  li a7, EXIT
  ecall

