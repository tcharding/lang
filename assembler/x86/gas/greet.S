.section .data

   prompt_str:
      .ascii "Enter Your Name: "
   pstr_end:
      .set PSTR_SIZE, pstr_end - prompt_str

   greet_str:
      .ascii "Hello "
   gstr_end:
      .set GSTR_SIZE, gstr_end - greet_str

.section .bss

// Reserve 32 bytes of memory
   .lcomm  buff, 32

// A macro with two parameters
//  implements the write system call
   .macro write str, str_size 
      movl  $4, %eax
      movl  $1, %ebx
      movl  \str, %ecx
      movl  \str_size, %edx
      int   $0x80
   .endm


// Implements the read system call
   .macro read buff, buff_size
      movl  $3, %eax
      movl  $0, %ebx
      movl  \buff, %ecx
      movl  \buff_size, %edx
      int   $0x80
   .endm


.section .text

   .globl _start

   _start:
      write $prompt_str, $PSTR_SIZE
      read  $buff, $32

// Read returns the length in eax
      pushl %eax

// Print the hello text
      write $greet_str, $GSTR_SIZE

      popl  %edx

// edx = length returned by read
   write $buff, %edx

   _exit:
      movl  $1, %eax
      movl  $0, %ebx
      int   $0x80
