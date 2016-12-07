;;; hello.asm
        
section .data                   ;initialised data section
        cr      equ     0x0A
        msg     db      'Hello, World!', cr ;string constant
        len     equ     $ - msg ;length of string msg
        
section .text                   ;program section
        global _start           ;must be declared for linker

_start:
        call    main
        mov     eax, 1          ;system call number ( sys_exit )
        int     0x80            ;call kernel

main:   push    ebp             ;
        mov     ebp, esp

        mov     edx, len        ;buffer length
        mov     ecx, msg        ;output buffer
        mov     ebx, 1          ;stdout
        mov     eax, 4          ;system call number ( sys_write )
        int     0x80            ;call kernel
        
        mov     esp, ebp
        pop     ebp
        ret
