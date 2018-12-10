; NOTE: the macro 'normalmode' can be used only after using the macro
; 'rawmode'
;
; TO ASSEMBLE and LINK the program in file 'filename.asm'
; yasm -f elf filename.asm         # this will produce hello.o ELF object file
; ld -o filename filename.o        # this will produce hello executable

; c_lflag bits
%assign ISIG    0000001q
%assign ICANON  0000002q
%assign XCASE   0000004q
%assign ECHO    0000010q
%assign ECHOE   0000020q
%assign ECHOK   0000040q
%assign ECHONL  0000100q
%assign NOFLSH  0000200q
%assign TOSTOP  0000400q
%assign ECHOCTL 0001000q
%assign ECHOPRT 0002000q
%assign ECHOKE  0004000q
%assign FLUSHO  0010000q
%assign PENDIN  0040000q
%assign IEXTEN  0100000q
section .bss

oldtermios	resw	30
newtermios	resw	30
%macro rawmode 0
        mov     edx,newtermios  ; read old termios
        mov     ecx,0x5401 ;TCGETS
        mov     ebx,0   ;file descriptor (stdin)
        mov     eax,54   ;system call number (sys_ioctl)
        int     0x80    ;call kernel

	mov	edx,dword [newtermios+12]
	mov	[oldtermios],edx	;save old termios
        mov     edx,newtermios  ; set termios
	and	dword [newtermios+12],~(ICANON|ECHO|ISIG)
        mov     ecx,0x5402 ;TCSETS
        mov     ebx,0   ;file descriptor (stdin)
        mov     eax,54   ;system call number (sys_ioctl)
        int     0x80    ;call kernel
%endmacro
%macro normalmode 0
	mov	edx,[oldtermios]	;read old termios
	mov	dword [newtermios+12],edx
        mov     edx,newtermios  ; set termios
        mov     ecx,0x5402 ;TCSETS
        mov     ebx,0   ;file descriptor (stdin)
        mov     eax,54   ;system call number (sys_ioctl)
        int     0x80    ;call kernel
%endmacro
