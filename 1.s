.section .data

number:
	.long 12345
number_end:

.section .text

.global _start

_start:										#global start
	movl $0, %edi
	movl number( , %edi, 4), %eax			#storing the number in register %eax
	movl $0, %esi							#A general purpose counter variable/register... Initialised to zero

#This loop decomposes the number into digits of char type and pushes each character into the Stack
num_gen_loop:
	cmpl $0, %eax
	je num_print_loop
	incl %esi
	movl $0 , %edx
	movl $10, %ebx
	idivl %ebx
	add $48, %edx
	pushl %edx
	jmp num_gen_loop

#This loop prints the number as a string by poping out elements from Stack
num_print_loop:
	cmpl $0, %esi
	je exit
	decl %esi
	movl $4, %eax
	movl $1, %ebx
	movl %esp, %ecx
	movl $4, %edx
	int $0x80
	popl %edx
	jmp num_print_loop

#General Purpose exit statement
exit:
	movl $1, %eax
	movl $0, %ebx
	int $0x80
