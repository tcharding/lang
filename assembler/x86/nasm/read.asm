; read.asm
%include "system.inc"

section .bss

        chars   resb     6

section .data

cr      equ     0x0a
prompt  db      'Enter 5 characters : '	
prompt_ln  equ     $ - prompt
msg     db      'You entered : '
msg_ln equ     $ - msg

section .text
        global _start

_start:

        mov     edx, prompt_ln
        mov     ecx, prompt
        mov     ebx, 1          ; specify stdout
        mov     eax, 4          ; sys_write function code
        int     0x80            ; interupt

        mov     eax, 3          ; sys_read
        mov     ebx, 0          ; stdin
        mov     ecx, chars      ; buffer for input
        mov	edx, 6          ; size of buffer
        int     0x80            ; interupt

        mov     edx, msg_ln     ; len of msg
        mov     ecx, msg        ; register address of msg
        mov     ebx, 1          ; stdout
        mov     eax, 4          ; sys_write
        int     0x80            

        mov     edx, 6          ; buffer length
        mov     ecx, chars      ; buffer address
        mov     ebx, 1          ; stdout
        mov     eax, 4          ; sys_write
        int     0x80            ; interupt
        
        mov     eax, 1          ; sys_exit function code
        int     0x80            ; interupt
 
