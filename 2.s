.section .data

number:
	.long 15485862
number_end:

right:
	.ascii " is a prime number."				#A string for Prime Number
right_end:

wrong:
	.ascii " is not a prime number."			#A string for not Prime Number
wrong_end:

.section .text

.global _start

_start:                                         #global start
	movl $0, %edi
	movl number( , %edi, 4), %eax				#storing the number in register %eax
	movl $0, %esi								#A general purpose counter variable/register... Initialised to zero

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

#This loop prints the number as a string by poping out elements from stack Stack 
num_print_loop:
	cmpl $0, %esi
	je prime_check_init
	decl %esi
	movl $4, %eax
	movl $1, %ebx
	movl %esp, %ecx
	movl $4, %edx
	int $0x80
	popl %edx
	jmp num_print_loop

#This reference refers to initialisation of The actual Problem of Primality test
prime_check_init:
	movl $0, %edi
	movl $0, %edx
	movl number(, %edi, 4), %eax
	movl $2, %esi
	idivl %esi
	movl %eax, %ebx
	movl %ebx, %esi

#This loop checks for any factor of number between 1 and (number/2) if exits jumps to not_prime_confirm else to prime_confirm
prime_checker:
	movl number(, %edi, 4), %eax
	cmpl $1, %esi
	je prime_confirm
	movl $0, %edx
	idivl %esi
	decl %esi
	cmpl $0, %edx								#Checking if remainder(%edx) is 0 or not
	je not_prime_confirm
	jmp prime_checker

#executes in case the number is Prime
prime_confirm:
	movl $4, %eax
	movl $1, %ebx
	movl $right, %ecx
	movl $(right_end - right), %edx
	int $0x80
	jmp exit

#Execute in case the number is not prime
not_prime_confirm:
	movl $4, %eax
	movl $1, %ebx
	movl $wrong, %ecx
	movl $(wrong_end - wrong), %edx
	int $0x80
	jmp exit

#A general Purpose Exit code 
exit:
	movl $1, %eax
	movl $0, %ebx
	int $0x80
