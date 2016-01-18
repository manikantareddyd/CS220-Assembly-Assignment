.section .data

#Input String
the_string:
  .ascii "Hello World\n"
the_string_end:

.section .text

.global _start

_start:
  movl $the_string, %edi
  movl $(the_string_end-the_string), %eax
  subl $2, %eax
  mov %eax, %ebx
  movl $0,%esi

#This loop inverts the string. It swaps the ends recursively 
reverser:
  cmp %ebx,%esi
  jge print_string
  #swapper
  movb the_string(,%esi,1),%cl
  movb the_string(,%ebx,1),%al
  movb %cl,the_string(,%ebx,1)
  movb %al,the_string(,%esi,1)
  #swapper ends
  decl %ebx						#decrementing end
  incl %esi						#incrementing start
  jmp reverser

#This stdout's the string
print_string:
  movl $4,%eax
  movl $1,%ebx
  movl $the_string,%ecx
  movl $(the_string_end-the_string),%edx
  int $0x80
  jmp exit

# General purpose exit
exit:
  movl $1,%eax
  movl $0,%ebx
  int $0x80
