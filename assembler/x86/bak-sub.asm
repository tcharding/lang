;;; subroutines.asm - useful subroutine definitions
;;; 
%include "system.inc"
section .bss

iobuf	resb	1	   	; 1 byte io buffer

section .data

		
msg		db	'Testing useful subroutine definitions'
mlen		equ	$ - msg
tpc		db	'Testing putchar expected output: a'
tpcl		equ	$ - tpc
tgc		db	'Testing getchar, type a character (space to quit): ' 
tgcl		equ	$ - tgc
tpn		db	'Testing printnum, expected output: 10'
tpnl		equ	$ - tpn	

section .text
	global _start

_start:
	call	lf
	jmp	finish
	
	;; test putstr
	mov	edx, mlen	; message 
	mov	ecx, msg
	call	putstr
	
	;; test newline
	call	newline

	;; test putchar
	mov	edx, tpcl
	mov	ecx, tpc
	call 	putstr
	call	newline
	
	mov	eax, 'a'
	call	putchar
	call 	newline

	;; test getchar
	mov	edx, tgcl
	mov	ecx, tgc
	call 	putstr
	call	newline
gch_loop:
	xor	rax, rax
	call	getchar
	cmp	al, 32
	je	gch_cont
	mov	rdi, rax
	call	putchar
	jmp	gch_loop
gch_cont:
	call	newline

	;; test printnum
	mov	edx, tpnl
	mov	ecx, tpn
	call 	putstr
	call	newline

	xor	rax, rax
	mov	eax, 10
	call	printnum
	call	newline

	jmp 	finish

;;; read a 16 bit unsigned number from stdin into ax
;;; bx is set to 1 on overflow. 
readnum:
        mov     edi, 0          ; flag indicating not in a number string
        mov     rax, 0       
        push    rax             ; accumulated number initially 0
reading:
        call    getchar         ; read a char into al
	push	rax
        call    putchar         ; write a char from al
	pop	rax

        cmp     al, '0'         ; test for non-digits
        jl      atest
        cmp     al, '9'
        jg      atest

        mov     edi, 1          ; start of a number string
        sub     al, '0'
        mov     cx, 0
        mov     cl, al          ; cl has the digit
        pop     rax             ; ax <- numb
        mov     bx, 10          
        mul     bx              ; dx:ax <- ax * 10
        cmp     dx, 0
        jne     over
        add     ax, cx          ; ax <- ax + the digit
        jc      over       
        push    rax             ; save the result so far
        jmp     reading         ; get the next char
atest:
        cmp     edi, 0          ; haven't got a number string yet
        je      reading
        pop     rax             ; return result in ax
        mov     bx, 0
        ret
over:   mov     bx, 1
        ret	
	
printnum:                      	; print the unsigned 16 bit number in eax
	push	rbx	      	 
        mov    	edx, 0	      	 
        mov    	ebx, 10
        div    	ebx             ; eax <- eax div 10, edx <- remainder
        push   	rdx             ; rdx for 64 bits, edx otherwise
        cmp    	eax, 0
        je     	printnum1
        call   	printnum
printnum1:
        pop    	rdx
        add    	dl, '0'
        mov    	al, dl
        call 	putchar
	pop	rbx
        ret
	
;;; get character from stdin, leave it in AX
getchar:
	push	rbp		; save caller base pointer
	mov	ebp, esp	; set base pointer
	push	rbx		; caller-saved register

        rawmode			; use rawmode 
        mov     edx, 1		; buffer length
        mov     ecx, iobuf	; output data
        mov     ebx, 0		; stdin
        mov     eax, 3		; system call number ( sys_read )
        int     0x80		; call kernel
        normalmode		; back to normal mode	
        mov     al, [iobuf]	; move read char into al

	pop 	rbx		; restore caller-saved register
	pop	rbp
	ret			; return to caller

;;; print character in AL
putchar:
	push	rbp		; save caller base pointer
	mov	ebp, esp	; set base pointer
	push	rbx		; caller-saved register

	mov	[iobuf], al
	mov     edx, 1		; buffer length
	mov	ecx, iobuf	; output data
	mov     ebx, 1		; stdout
	mov     eax, 4		; system call number ( sys_write )
	int     0x80		; call kernel
	
	pop 	rbx		; restore caller-saved register
	pop	rbp
	ret			; return to caller
	
;;; Helper subroutines
lf:				; echo line feed
	push	rbx		; save callee-saved register
	mov     edx, 1          ; buffer length
        mov     ecx, 0x0a	; line feed
	mov     ebx, 1 		; stdout
        mov     eax, 4		; system call number ( sys_write )
        int     0x80		; call kernel
	pop	rbx		; restore callee-saved register
	ret			; return to caller
	
finish:
        mov     eax, 1		; system call number ( sys_exit )
        int     0x80        	; call kernel
