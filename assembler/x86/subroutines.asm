;;; subroutines.asm - useful subroutine definitions
;;; 
%include "system.inc"
section .bss

iobuf	resb	1	   	; 1 byte io buffer

section .data

lf	db	0x0a

msg	db	'Test suite: uncomment region to enable tests'
msgl	equ	$ - msg
	
tps	db	'This is output by putstr', 0x0a
tpsl	equ	$ - tps	
	
tgc	db	'Enter a character to be echod: ' 
tgcl	equ	$ - tgc
	
trn	db	'Enter number in base 10: '
trnl	equ	$ - trn	

ovf	db	'overflow!'
ovfl	equ	$ - ovf
	
section .text
	global _start

_start:
	mov	rdx, msgl
	mov	rcx, msg
	mov     rbx, 1		; stdout
	mov     rax, 4		; system call number ( sys_write )
	int     0x80		; call kernel

	call	linefeed
	call	_test
	call	finish
	
_test:	
	;; ;; test putchar
	;; mov	rdi, 'a'
	;; call	putchar
	;; mov	rdi, 'b'
	;; call	putchar
	;; mov	rdi, 'c'
	;; call	putchar
	;; call	linefeed

	;; ;; test putstr
	;; mov	rdx, tpsl
	;; mov	rcx, tps
	;; call	putstr

	;; ;; test getchar
	;; mov	rdx, tgcl
	;; mov	rcx, tgc
	;; call	putstr
	;; call	getchar
	;; mov	rdi, rax
	;; call	putchar
	;; call	linefeed

	;; ;; test prn16
	;; mov	rdi, 42
	;; call	prn16
	;; call	linefeed

	;; ;; test rn16	
	;; mov	rdx, trn
	;; mov	rcx, trnl
	;; call	putstr
	;; call	rn16

	;; 	mov	rdi, rax	; output what was read (16 bits only)
;; 	call	prn16
;; 	;; jnc	cont_test
;; 	cmp	rbx, 1
;; 	jne	cont_test	; jump if no overflow
	
;; 	call	linefeed	
;; 	mov	rdx, ovfl	; echo overflow msg	
;; 	mov	rcx, ovf
;; 	call	putstr
;; cont_test:	
;; 	call	linefeed

	;; test prn64
	mov	rdi, 1		; one byte
	call	prn64
	call 	linefeed

	mov	rdi, 256		; two bytes
	call	prn64
	call 	linefeed

	mov	rdi, 65536		; three bytes
	call	prn64
	call 	linefeed

	mov	rdi, 16777216		; four bytes
	call	prn64
	call 	linefeed

	;; test rn64
	mov	rdx, trnl
	mov	rcx, trn
	call	putstr
	call	linefeed
	
	call	rn64
	mov	rdi, rax
	call	linefeed
	call	prn64
	call	linefeed
	jmp	finish


;;; read a 16 bit unsigned number from stdin into AX
;;; RBX set to 1 if number bigger than 16 bits
rn16:
	;; push	rbx		; callee-saved registers
	push	rdi
	push	rsi

	mov	rsi, 0		; zero flag
	mov     rax, 0       
	push    rax             ; accumulated number initially 0 
_reading16:	
	call	getchar
	push	rax		; store rax over call to putchar
	mov	rdi, rax
	call	putchar
	pop	rax

	cmp     al, '0'         ; test for non-digits
        jl      _notd
        cmp     al, '9'
        jg      _notd

	mov	rsi, 1		; in number string
        sub     al, '0'
        mov     cx, 0
        mov     cl, al          ; cl has the digit
        pop     rax             ; ax <- numb
        mov     bx, 10          
        mul     bx              ; dx:ax <- ax * 10 
        cmp     dx, 0
        jne     _over
        add     ax, cx          ; ax <- ax + the digit
        jc      _over       
        push    rax             ; save the result so far
        jmp     _reading        ; get the next char
_notd16:
	cmp	rsi, 0		; did we read a number
	je	_reading
	pop	rax
	jmp	_end	
_over16:
	mov	rbx, 1
	;; stc			; doesnt work
_end16:
	pop	rsi
	pop	rdi		; restore callee-saved registers
	;; pop	rbx
	ret





prn16:				; print unsigned 16 bit number in rdi
	push	rbp		; save caller base pointer
	mov	ebp, esp	; set base pointer
	push	rbx		; callee-saved register

	mov	rax, rdi	; get parameter
	call	_loop

	pop 	rbx		; restore callee-saved register
	pop	rbp
	ret			; return to caller
_loop16:
	mov	rdx, 0		; clear rdx
	mov	rbx, 10		; 10 is the divisor
	div	rbx		; rax <- rax div 10, rdx <- remainder
	push	rdx
	cmp	rax, 0
	je	_out
	call	_loop
_out16:
	pop	rdx
        add    	dl, '0'
        mov    	rdi, rdx
        call 	putchar
	ret	
	
;;; get character from stdin, leave it in AX
getchar:
	push	rbx		; caller-saved register

        rawmode			; use rawmode 
        mov     rdx, 1		; buffer length
        mov     rcx, iobuf	; output data
        mov     rbx, 0		; stdin
        mov     rax, 3		; system call number ( sys_read )
        int     0x80		; call kernel
        normalmode		; back to normal mode	
        mov     rax, [iobuf]	; move read char into al

	pop 	rbx		; restore caller-saved register
	ret			; return to caller
	
;;; Print string (ecx=buffer, edx=length)
putstr:
	push	rbx		; save caller base pointer
	mov     rbx, 1		; stdout
	mov     rax, 4		; system call number ( sys_write )
	int     0x80		; call kernel
	pop	rbx		; restore caller-saved register
	ret
	
;;; Print character in RDI
putchar:
	push	rbx		; store callee-saved register
	mov	[iobuf], rdi
	mov     rdx, 1		; buffer length
	mov	rcx, iobuf	; output data
	mov     rbx, 1		; stdout
	mov     rax, 4		; system call number ( sys_write )
	int     0x80		; call kernel
	pop 	rbx		; restore caller-saved register
	ret			; return to caller
	

;;; Print line feed
linefeed:			; echo line feed
	push	rbx		; save callee-saved register
	mov     rdx, 1          ; buffer length
        mov     rcx, lf		; line feed
	mov     rbx, 1 		; stdout
        mov     rax, 4		; system call number ( sys_write )
        int     0x80		; call kernel
	pop	rbx		; restore callee-saved register
	ret			; return to caller
	
finish:
        mov     rax, 1		; system call number ( sys_exit )
        int     0x80        	; call kernel


	
;;; Read a 64 bit unsigned number from stdin into RAX
;;; 
;;; RDX set to 0x01 if overflow occurs
rn64:
	push	rdi		; callee-saved registers
	push	rsi		
	push	rbx
	
	mov	rsi, 0		; zero flag
	mov     rax, 0       
	push    rax             ; accumulated number initially 0 
_reading:	
	call	getchar
	
	cmp     al, '0'         ; test for non-digits
        jl      _notd
        cmp     al, '9'
        jg      _notd

	mov	rdi, rax	; echo character (digit)
	call	putchar
	mov	rsi, 0x01	; flag showing in number string
	
	mov	rcx, rdi	; current character (ascii)
        sub     rcx, '0'	; RCX = value of input character
        pop     rax             ; RAX = accumulated number so far
        mov     rbx, 10          
        mul     rbx             ; RDX:RAX <- RAX * 10
        cmp	rdx, 0
	jne	_over
        add     rax, rcx        ; ax <- ax + the digit
        jc      _over       
        push    rax             ; save the result so far
        jmp     _reading        ; get the next char
_notd:
	cmp	rsi, 0		; did we read a number
	je	_reading
	pop	rax
	jmp	_end	
_over:
	mov	rdx, 0x01	; 64 bit overflow
_end:
	pop	rbx		; restore callee-saved registers
	pop	rsi
	pop	rdi		
	ret

;;; Print unsigned 64 bit number in RDI
prn64:				
	push	rbx		; store callee-saved register
	
	mov	rax, rdi	; get parameter
	call	_loop		; call main loop

	pop 	rbx		; restore callee-saved register
	ret			; return to caller
_loop:
	mov	rdx, 0		; clear rdx
	mov	rbx, 10		; 10 is the divisor
	div	rbx		; rax <- rax div 10, rdx <- remainder
	push	rdx
	cmp	rax, 0
	je	_out
	call	_loop
_out:
	pop	rdi
        add    	rdi, 0x30	; calculate ascii value 
        call 	putchar
	ret	
	
