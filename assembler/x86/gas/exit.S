# Text segment begins
.section .text

        .globl _start

# Program entry point
   _start:

// Put the code number for system call
      movl  $1, %eax

// Put the return value
      movl  $5, %ebx

// Trap to Linux
      int   $0x80
