.section .data
input: .string "%d %d %d %d"
output: .string "%d\n"

a: .int 0, 0
x: .int 0, 0
c: .int 0, 0
m: .int 0, 0

.section .text

rnd_gen:
	mov $0, %r12
	
.rnd.loop:
	cmp $10, %r12
	jge .rnd.loop.end

	mov (%rsi, %r12, 8), %rax
	mul %rdi
	add %r8, %rax
	div %rcx
	mov %rdx, 8(%rsi, %r12, 8)
	inc %r12
	jmp .rnd.loop	
		
.rnd.loop.end:

	ret



.global main

main:
	sub $8, %rsp

	lea input(%rip), %rdi
	lea a(%rip), %rsi
	lea x(%rip), %rdx
	lea c(%rip), %rcx
	lea m(%rip), %r8
	xor %eax, %eax
	call scanf@plt
	
	sub $80, %rsp
	push %rbp
	mov %rsp, %rbp

	

	mov a(%rip), %rdi
	mov x(%rip), %rsi
	mov %rsi, 8(%rbp)
	lea 8(%rbp), %rsi
	mov c(%rip), %r8
	mov m(%rip), %rcx	
	
	call rnd_gen

	mov $0, %r12
.loop:
	cmp $10, %r12
	jge .loop.end

	
	lea output(%rip), %rdi			
	mov 8(%rbp, %r12, 8), %rsi
	xor %eax, %eax
	call printf@plt

	inc %r12
	jmp .loop
.loop.end:
	
	leave	
	add $88, %rsp
		
	xor %eax, %eax
	ret
