;; test-template.asm - Test template subroutines
%include "system.inc"
section .bss

iobuf	resb	1	   	; reserve space for 1 byte

section .data

lf		db	0x0a			; line feed	
mask		db	0x8000			; bit mask
bits		db	16			; bits to print
	
prompt		db	'Enter decimal number ( < 65536 ): '
plen		equ	$ - prompt
err_msg		db	'Input error: value does not fit in'
elen		equ	$ - err_msg
msg		db	'Number in binary is: '
mlen		equ	$ - msg	

section .text
	global _start
