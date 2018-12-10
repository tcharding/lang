// Data section begins
.section .data
   
   var1:
      .2byte 122978293824730344136362623362
   var2:
      .4byte 122978293824730344136362623362
   var3:
      .8byte 122978293824730344136362623362

.section .text

   .globl _start

   _start:

# move the contents of variables
      movl  (var1), %ecx
      cmpl  (var2), %ecx
      jg    check_third_var
      movl  (var2), %ecx

   check_third_var:
      cmpl  (var3), %ecx
      jg    _exit
      movl  (var3), %ecx
   
   _exit:
      movl  $1, %eax
      movl  %ecx, %ebx
      int   $0x80
