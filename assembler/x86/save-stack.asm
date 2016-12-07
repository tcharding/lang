;;; read.asm
section .data                   ;initialised data section

cr      db      0x0a        

section .bss                    ;unitialiased data section
section .text                   ;program section
        global _start           ;must be declared for linker

_start:
        call    main
        mov     eax, 1          ;system call number ( sys_exit )
        int     0x80            ;call kernel

main:   push    rbp             ;
        mov     rbp, rsp
        ;; main function here
        
        mov     rsp, rbp
        pop     rbp
        ret
