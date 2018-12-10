;;; scratch pad
%include "system.inc"
section .bss

iobuf	resb	1

section .data

lf	db	0x0a

section .text
	global _start

_start:
	mov 	rax, 0x01
	mov	rdi, rax
	call	fact
	mov	rdi, rax
	call 	prn16
	call	linefeed
	jmp	finish

;;; factorial n (16 bit)
;;;
;;; RAX = factorial RDI
;;; returns 0 on overflow
fact:	
	push	rbp
	mov	rbp, rsp
	push	rdi
	push	rbx

	mov	rax, rdi	; get parameter (n)
	
	cmp	rax, 0x00	; fact(n) = 1, (n == 1 || n == 0)
	je	ret_one
	cmp	rax, 0x01
	je	ret_one

	mov	rbx, rax	; store n
	mov	rdi, rax
	dec	rdi		; n - 1
	call	fact		; rax = fact(n - 1)
	xor	rdx, rdx	; clear register
	mul	bx		; 16 bit multiplication
	cmp	dx, 0		; check dx for overflow
	jne	fact_ovfl
	jmp	fact_end
fact_ovfl:
	mov	rax, 0x00	; return 0 on overflow
	jmp	fact_end
ret_one:
	mov	rax, 0x01
fact_end:
	pop	rbx
	pop	rdi
	pop	rbp
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
_loop:
	mov	rdx, 0		; clear rdx
	mov	rbx, 10		; 10 is the divisor
	div	rbx		; rax <- rax div 10, rdx <- remainder
	push	rdx
	cmp	rax, 0
	je	_out
	call	_loop
_out:
	pop	rdx
        add    	dl, '0'
        mov    	rdi, rdx
        call 	putchar
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
