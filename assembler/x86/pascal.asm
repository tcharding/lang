;;; pascal.asm - Pascal's Triangle
;;;
;;; Tobin Harding
;;; 30th April 2014
;;; 
%include "system.inc"
section .bss

iobuf		resb	1

section .data

lf		db	0x0a

prompt		db	'Pascals Triangle, Calculating C(n,k)'
promptl		equ	$ - prompt
	
pn		db	'Enter n: '	
pnl		equ	$ - pn
	
pk		db	'Enter k: '
pkl		equ	$ - pk
	
in_err		db	'Error: n is less than k. Please try again with n >= k'
in_errl		equ	$ - in_err
	
outmsg		db	'C(n,k): '
outmsgl		equ	$ - outmsg	

section .text
	global _start

_start:
	mov	rdx, promptl	; output prompt msg
	mov	rcx, prompt
	call	putstr
	call	linefeed
	
	;; prompt for n
	mov	rdx, pnl	; output msg
	mov	rcx, pn
	call	putstr		
	call	rn64		; read in n
	
	push	rax		; store n on stack
	call	linefeed

	;; prompt for k
	mov	edx, pkl	; output msg
	mov	ecx, pk
	call	putstr
	call	rn64		; read in k
	
	pop	rdi		; RDI = n
	mov	rsi, rax	; RSI = k

	call	linefeed
	
	call	assert_ngek	; assert n >= k
	cmp	rax, 0x01
	jne	input_error

	push	rsi		; push parameters onto stack in reverse order
	push	rdi
	call	combination	; C(n,k)
	sub	rsp, 0x10	; remove 16 bytes from stack (rsi and rdi)
	mov	rdi, rax	; mov ready for print
	
	mov	edx, outmsgl	; output msg
	mov	ecx, outmsg
	call	putstr
	
	call	prn64		; output result
	call	linefeed
	jmp	finish

input_error:
	mov	edx, in_errl	; output error msg
	mov	ecx, in_err
	call	putstr
	call	linefeed	; newline
	jmp	finish		; and finish
	
;;; assert n >= k
;;;
;;; inputs: RDI = n, RSI = k
;;; output: RAX, 0=false 1=true
assert_ngek:
	cmp	rdi, rsi
	jge	as_true
	mov	rax, 0x00	; false
	ret
as_true:
	mov	rax, 0x01	; true
	ret

;;; Combination(n, k)
;;; 
;;; inputs: supplied on stack
;;; output: RAX = C(n, k)
combination:
	push	rbp		; store callee-saved registers
	mov	rbp, rsp
	push	rdi		
	push	rsi		

	mov	rdi, [rbp-8]	; first parameter (n)	
	mov	rsi, [rbp-16]	; second parameter (k)
	
	cmp	rsi, rdi	; stop condition: C(x, x) = 1
	je	c_stop		
	cmp	rsi, 0		; stop condition: C(x, 0) = 1
	je	c_stop
	
	dec	rdi		; no check for zero, we are not on an edge
	call	combination	; C(n-1,k)
	push	rax		; store C(n-1,k)
	
	dec	rsi		; no check for zero, we are not on an edge
	call	combination	; C(n-1,k-1)
	pop	rcx		; get C(n-1,k)
	
	add	rax, rcx	; RAX = C(n-1,k) + C(n-1,k-1)
	jmp	c_end
c_stop:
	mov	rax, 0x01	; edge condition, C(n,k) = 1
c_end:
	pop	rsi		; restore callee-saved registers
	pop	rdi
	pop	rbp
	ret
	
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
	
;;; read ascii chacter from stdin into RAX
getchar:
	push	rbx		; callee-saved register
	
        rawmode			; use rawmode 
        mov     rdx, 1		; buffer length
        mov     rcx, iobuf	; output data
        mov     rbx, 0		; stdin
        mov     rax, 3		; system call number ( sys_read )
        int     0x80		; call kernel
        normalmode		; back to normal mode	
        mov     rax, [iobuf]	; move read char into RAX

	pop 	rbx		; restore callee-saved register
	ret			; return to caller
		
;;; Print string
;;;
;;; inputs: RCX = buffer, RDX = buffer length
putstr:
	push	rbx		; store callee-saved register
	mov     rbx, 1		; stdout
	mov     rax, 4		; system call number ( sys_write )
	int     0x80		; call kernel
	pop	rbx		; restore callee-saved register
	ret
	
;;; Print character in RDI
putchar:
	push	rbx		; store callee-saved register
	mov	rax, rdi	; get parameter
	mov	[iobuf], al	; low order byte
	mov     rdx, 1		; buffer length
	mov	rcx, iobuf	; output data
	mov     rbx, 1		; stdout
	mov     rax, 4		; system call number ( sys_write )
	int     0x80		; call kernel
	pop 	rbx		; restore callee-saved register
	ret			; return to caller	

;;; Print new line
linefeed:			; echo line feed
	push	rbx		; save callee-saved register
	mov     rdx, 1          ; buffer length
        mov     rcx, lf		; line feed
	mov     rbx, 1 		; stdout
        mov     rax, 4		; system call number ( sys_write )
        int     0x80		; call kernel
	pop	rbx		; restore callee-saved register
	ret			; return to caller

;;; Exit 
finish:
        mov     rax, 1		; system call number ( sys_exit )
        int     0x80        	; call kernel
