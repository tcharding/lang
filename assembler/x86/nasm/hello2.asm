; hello2.asm

section .bss

section .data

cr      equ     0x0a
msg     db      'Hello world!', 0x0a
len     equ     $ - msg
msg2    db      'Second line', cr
len2     equ     $ - msg2

section .text
        global _start

_start:

        mov     edx, len
        mov     ecx, msg
        mov     ebx, 1          ; specify stdout
        mov     eax, 4          ; sys_write function code
        int     0x80            ; tell kernel to perform system call

        mov     edx, len2
        mov     ecx, msg2        
        mov     ebx, 1          ; specify stdout
        mov     eax, 4          ; sys_write function code
        int     0x80            ; tell kernel to perform system call
        
        mov     eax, 1          ; sys_exit function code
        int     0x80            ; tell kernel to perform system call
 
