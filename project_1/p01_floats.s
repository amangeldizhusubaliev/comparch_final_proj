.section .data

input: .string "%d%d%d%d"
output: .string "%lf "
output_arr: .string "array: "
empty: .string ""

output_sum: .string "sum = %lf\n"
output_average: .string "average = %lf\n"
output_geometric_sum: .string "geometric sum = %lf\n"

a: .int 0, 0   # rdi
x: .int 0, 0   # rsi
c: .int 0, 0   # r8
m: .int 0, 0   # rcx

arr: .double 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
drt: .double 0
num: .int 0, 0

.section .text

# RANDOM ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

rnd_gen:
    mov $0, %r12

	fildl x(%rip)
    fstpl (%r9, %r12, 8)
	
    fildl m(%rip)

.rnd.loop:
	cmp $16, %r12
	jge .rnd.loop.end

	# mov (%r9, %r12, 8), %rax
	fldl (%r9, %r12, 8)
    # mul %rdi
    fildl a(%rip)
    fmulp 
	# add %r8, %rax
    fildl c(%rip)
    faddp 
	# div %rcx
    fprem
	# mov %rdx, 8(%r9, %r12, 8)
	fstpl 8(%r9, %r12, 8)

    inc %r12
	jmp .rnd.loop	
		
.rnd.loop.end:
    fstpl drt(%rip) # clear fpu 'stack'
	ret

# SUM ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

sum:
    mov $0, %r12
    fldl (%r9, %r12, 8)

.sum.loop:
    inc %r12
    cmp $15, %r12
    jg .sum.loop.end

    fldl (%r9, %r12, 8)
    faddp

    jmp .sum.loop

.sum.loop.end:
    lea drt(%rip), %rax
    fstpl (%rax)

    ret

# AVERAGE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

average:
    mov $0, %r12
    fldl (%r9, %r12, 8)

.average.loop:
    inc %r12
    cmp $15, %r12
    jg .average.loop.end

    fldl (%r9, %r12, 8)
    faddp

    jmp .average.loop

.average.loop.end:
    lea num(%rip), %r8
    mov %r12, (%r8)

    fildl num(%rip)
    fdivrp

    lea drt(%rip), %rax
    fstpl (%rax)

    ret

# GEOMETRIC SUM ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

geometric_sum:
    lea num(%rip), %r8
    mov $0, %r12
    mov %r12, (%r8)
    fildl num(%rip)
    
    mov $1, %rsi

    mov $0, %r12
.geometric_sum.loop:
    cmp $15, %r12
    jg .geometric_sum.loop.end

    fldl (%r9, %r12, 8)
    
    lea num(%rip), %r8
    mov %rsi, (%r8)
    fildl num(%rip)

    fmulp
    faddp
    
    mov %rsi, %rax
    mov $2, %r8
    mul %r8
    mov %rax, %rsi

    inc %r12
    jmp .geometric_sum.loop

.geometric_sum.loop.end:
    lea drt(%rip), %rax
    fstpl (%rax)

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

    lea arr(%rip), %r9    
    call rnd_gen

# ARRAY ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    lea output_arr(%rip), %rdi
    xor %eax, %eax
    call printf@plt

    mov $0, %r12
.loop:
	cmp $16, %r12
	jge .loop.end

	lea output(%rip), %rdi
    lea arr(%rip), %r9
	movsd (%r9, %r12, 8), %xmm0
	mov $1, %eax
    call printf@plt

	inc %r12
	jmp .loop
.loop.end:
    lea empty(%rip), %rdi
    xor %eax, %eax
    call puts@plt

# SUM ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    lea arr(%rip), %r9
    call sum
    lea output_sum(%rip), %rdi
    movsd (%rax), %xmm0
    mov $1, %eax
    call printf@plt

# AVERAGE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    lea arr(%rip), %r9
    call average
    lea output_average(%rip), %rdi
    movsd (%rax), %xmm0
    mov $1, %eax
    call printf@plt

# GEOMETRIC SUM ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    lea arr(%rip), %r9
    call geometric_sum
    lea output_geometric_sum(%rip), %rdi
    movsd (%rax), %xmm0
    mov $1, %eax
    call printf@plt

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    add $8, %rsp

	xor %eax, %eax
	ret