.section .data

input: .string "%d%d%d%d"
output: .string "%d "
output_arr: .string "array: "
empty: .string ""

output_min: .string "min = %d\n"
output_max: .string "max = %d\n"
output_sum: .string "sum = %d\n"
output_average: .string "average = %d\n"
output_mode: .string "mode = %d\n"
output_median: .string "median = %d\n"
output_geometric_sum: .string "geometric sum = %d\n"

a: .int 0, 0
x: .int 0, 0
c: .int 0, 0
m: .int 0, 0

.section .text

# RANDOM ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

rnd_gen:
	mov $0, %r12
	
.rnd.loop:
	cmp $16, %r12
	jge .rnd.loop.end

	mov (%r9, %r12, 8), %rax
	mul %rdi
	add %r8, %rax
	div %rcx
	mov %rdx, 8(%r9, %r12, 8)
	inc %r12
	jmp .rnd.loop	
		
.rnd.loop.end:
	ret

# SORT ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

sort: 
    mov $0, %r12

.sort.loop_i:
    cmp $15, %r12
    jge .sort.return

    mov %r12, %r13

.sort.loop_j:
    inc %r13
    cmp $16, %r13
    jge .sort.loop_j.end
    
    mov (%r9, %r12, 8), %rdx
    mov (%r9, %r13, 8), %rcx
    cmp %rdx, %rcx
    jl .sort.swap

.sort.continue:
    jmp .sort.loop_j

.sort.swap:
    mov %rcx, (%r9, %r12, 8)
    mov %rdx, (%r9, %r13, 8)
    jmp .sort.continue

.sort.loop_j.end:
    inc %r12
    jmp .sort.loop_i

.sort.return:
    xor %rax, %rax
    ret

# SUM ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

sum: 
    xor %rax, %rax
    mov $0, %r12

.sum.loop:
    cmp $15, %r12
    jg .sum.return
    add (%r9, %r12, 8), %rax
    inc %r12
    jmp .sum.loop

.sum.return:
    ret

# AVERAGE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

average: 
    xor %rax, %rax
    mov $0, %r12

.average.loop:
    cmp $15, %r12
    jg .average.end
    add (%r9, %r12, 8), %rax
    inc %r12
    jmp .average.loop

.average.end:
    mov $16, %rcx
    div %rcx
    ret

# MEDIAN ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

median:
    mov $7, %r12
    mov (%r9, %r12, 8), %rax
    add 8(%r9, %r12, 8), %rax
    mov $2, %r12
    div %r12
    ret

# MODE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

mode:
    mov $0, %r12
    mov (%r9, %r12, 8), %rax 
    mov $1, %r8              
    mov $1, %r13             

.mode.loop:
    inc %r12
    cmp $15, %r12
    jg .mode.loop.end

    mov (%r9, %r12, 8), %rdx
    mov -8(%r9, %r12, 8), %rcx;
    cmp %rdx, %rcx
    je .mode.loop.equal

    cmp %r8, %r13
    jl .mode.loop.new_mode
    mov $1, %r8
    jmp .mode.loop

.mode.loop.new_mode:
    mov %r8, %r13
    mov -8(%r9, %r12, 8), %rax
    mov $1, %r8
    jmp .mode.loop

.mode.loop.equal:
    inc %r8
    jmp .mode.loop

.mode.loop.end:
    cmp %r8, %r13
    jl .mode.corner_case

    ret

.mode.corner_case:
    mov -8(%r9, %r12, 8), %rax
    ret

# GEOMETRIC SUM ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

geometric_sum:
    mov $0, %rdi
    mov $1, %rsi
    mov $0, %r12

.geometric_sum.loop:
    cmp $15, %r12
    jg .geometric_sum.return

    mov (%r9, %r12, 8), %rax
    mul %rsi
    add %rax, %rdi

    mov %rsi, %rax
    mov $2, %r8
    mul %r8
    mov %rax, %rsi

    inc %r12
    jmp .geometric_sum.loop

.geometric_sum.return:
    mov %rdi, %rax
    ret

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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
	
	sub $128, %rsp
	push %rbp
	mov %rsp, %rbp

	mov a(%rip), %rdi
	mov x(%rip), %rsi
	mov %rsi, 8(%rbp)
	lea 8(%rbp), %r9
	mov c(%rip), %r8
	mov m(%rip), %rcx	
	
	call rnd_gen
    lea 8(%rbp), %r9
    call sort

# ARRAY ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    lea output_arr(%rip), %rdi
    xor %eax, %eax
    call printf@plt

    mov $0, %r12
.loop:
	cmp $16, %r12
	jge .loop.end

	lea output(%rip), %rdi			
	mov 8(%rbp, %r12, 8), %rsi
	xor %eax, %eax
	call printf@plt

	inc %r12
	jmp .loop

.loop.end:	
    lea empty(%rip), %rdi
    xor %eax, %eax
    call puts@plt

# MIN ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    lea output_min(%rip), %rdi
    mov $0, %r12
    mov 8(%rbp, %r12, 8), %rsi
    xor %eax, %eax
    call printf@plt

# MAX ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    lea output_max(%rip), %rdi
    mov $15, %r12
    mov 8(%rbp, %r12, 8), %rsi
    xor %eax, %eax
    call printf@plt

# SUM ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    lea 8(%rbp), %r9
    call sum
    lea output_sum(%rip), %rdi
    mov %rax, %rsi
    xor %eax, %eax
    call printf@plt

# AVERAGE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    lea 8(%rbp), %r9
    call average
    lea output_average(%rip), %rdi
    mov %rax, %rsi
    xor %eax, %eax
    call printf@plt

# MEDIAN ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    lea 8(%rbp), %r9
    call median
    lea output_median(%rip), %rdi
    mov %rax, %rsi
    xor %eax, %eax
    call printf@plt

# MODE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    lea 8(%rbp), %r9
    call mode
    lea output_mode(%rip), %rdi
    mov %rax, %rsi
    xor %eax, %eax
    call printf@plt

# GEOMETRIC SUM ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    lea 8(%rbp), %r9
    call geometric_sum
    lea output_geometric_sum(%rip), %rdi
    mov %rax, %rsi
    xor %eax, %eax
    call printf@plt

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	leave	
	add $136, %rsp
		
	xor %eax, %eax
	ret