;;; Collection of helper functions
;;; 
;;; Tobin Harding

finish:
        ;; call newline
        mov     eax, 1		; system call number ( sys_exit )
        int     0x80        	; call kernel

newline:
	mov     edx, 1          ; buffer length
        mov     ecx, cr		; output data
        mov     ebx, 1 		; stdout
        mov     eax, 4		; system call number ( sys_write )
        int     0x80		; call kernel
	ret			; return to caller	
	
;; section .bss
;; 	iobuf   db      1
putchar:
	mov     [iobuf], al	; mov char to output buffer
	mov     edx, 1		; buffer length
	mov     ecx, iobuf	; output data
	mov     ebx, 1		; stdout
	mov     eax, 4		; system call number ( sys_write )
	int     0x80		; call kernel
	ret			; return to caller

;; %include "system.inc"
;; section .bss
;; 	iobuf   db      1
getchar:
        rawmode			; use rawmode 
        mov     edx, 1		; buffer length
        mov     ecx, iobuf	; output data
        mov     ebx, 0		; stdin
        mov     eax, 3		; system call number ( sys_read )
        int     0x80		; call kernel
        normalmode		; back to normal mode	
        mov     al, [iobuf]	; move read char into al
        ret			; return to caller
