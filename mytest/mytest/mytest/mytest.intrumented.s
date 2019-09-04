.section .fini_array
	.quad asan.module_dtor
.section .rodata
.align 4
.type	_IO_stdin_used_1,@object
.globl _IO_stdin_used_1
_IO_stdin_used_1: # 990 -- 994
.LC990:
	.byte 0x1
.LC991:
	.byte 0x0
.LC992:
	.byte 0x2
.LC993:
	.byte 0x0
.LC994:
	.byte 0x25
.LC995:
	.byte 0x73
.LC996:
	.byte 0x0
.LC997:
	.byte 0x6f
.LC998:
	.byte 0x6b
.LC999:
	.byte 0x0
.LC99a:
	.byte 0x66
.LC99b:
	.byte 0x61
.LC99c:
	.byte 0x69
.LC99d:
	.byte 0x6c
.LC99e:
	.byte 0x0
.LC99f:
	.byte 0x61
.LC9a0:
	.byte 0x3d
.LC9a1:
	.byte 0x25
.LC9a2:
	.byte 0x64
.LC9a3:
	.byte 0xa
.LC9a4:
	.byte 0x0
.section .init_array
.align 8
	.quad asan.module_ctor
.section .data
.align 8
.LC201040:
	.byte 0x0
.LC201041:
	.byte 0x0
.LC201042:
	.byte 0x0
.LC201043:
	.byte 0x0
.LC201044:
	.byte 0x0
.LC201045:
	.byte 0x0
.LC201046:
	.byte 0x0
.LC201047:
	.byte 0x0
.LC201048:
	.quad .LC201048
.type	c,@object
.globl c
c: # 201050 -- 201054
.LC201050:
	.byte 0x1
.LC201051:
	.byte 0x0
.LC201052:
	.byte 0x0
.LC201053:
	.byte 0x0
.section .bss
.align 1
.type	completed.7594,@object
.globl completed.7594
completed.7594: # 201054 -- 201055
.LC201054:
	.byte 0x0
.LC201055:
	.byte 0x0
.LC201056:
	.byte 0x0
.LC201057:
	.byte 0x0
.section .text
.align 16
	.text
.globl func1
.type func1, @function
func1:
.L870:
.LC870:
	pushq %rbp
.LC871:
	movq %rsp, %rbp
.LC874:
.LC_ASAN_ENTER_874: # 874: movl %edi, -4(%rbp): ['rax']
		pushq %rdi
leaq 8(%rsp), %rsp
	leaq  -4(%rbp), %rdi
	movq %rdi, %rax
	shrq $3, %rax
	movb 2147450880(%rax), %al
	testb %al, %al
	je .LC_ASAN_EX_2164
	andl $7, %edi
	addl $3, %edi
	movsbl %al, %eax
	cmpl %eax, %edi
	jl .LC_ASAN_EX_2164
	callq __asan_report_load4@PLT
.LC_ASAN_EX_2164:
leaq -8(%rsp), %rsp
	popq %rdi
	movl %edi, -4(%rbp)
.LC877:
.LC_ASAN_ENTER_877: # 877: movl -4(%rbp), %eax: ['rax']
		pushq %rdi
leaq 8(%rsp), %rsp
	leaq -4(%rbp), %rdi
	movq %rdi, %rax
	shrq $3, %rax
	movb 2147450880(%rax), %al
	testb %al, %al
	je .LC_ASAN_EX_2167
	andl $7, %edi
	addl $3, %edi
	movsbl %al, %eax
	cmpl %eax, %edi
	jl .LC_ASAN_EX_2167
	callq __asan_report_load4@PLT
.LC_ASAN_EX_2167:
leaq -8(%rsp), %rsp
	popq %rdi
	movl -4(%rbp), %eax
.LC87a:
.LC_ASAN_ENTER_87a: # 87a: movl %eax, .LC201050(%rip): []
		pushq %rdi
	pushq %rsi
leaq 16(%rsp), %rsp
	leaq  .LC201050(%rip), %rdi
	movq %rdi, %rsi
	shrq $3, %rsi
	movb 2147450880(%rsi), %sil
	testb %sil, %sil
	je .LC_ASAN_EX_2170
	andl $7, %edi
	addl $3, %edi
	movsbl %sil, %esi
	cmpl %esi, %edi
	jl .LC_ASAN_EX_2170
	callq __asan_report_load4@PLT
.LC_ASAN_EX_2170:
leaq -16(%rsp), %rsp
	popq %rsi
	popq %rdi
	movl %eax, .LC201050(%rip)
.LC880:
.LC_ASAN_ENTER_880: # 880: movl -4(%rbp), %eax: ['rax']
		pushq %rdi
leaq 8(%rsp), %rsp
	leaq -4(%rbp), %rdi
	movq %rdi, %rax
	shrq $3, %rax
	movb 2147450880(%rax), %al
	testb %al, %al
	je .LC_ASAN_EX_2176
	andl $7, %edi
	addl $3, %edi
	movsbl %al, %eax
	cmpl %eax, %edi
	jl .LC_ASAN_EX_2176
	callq __asan_report_load4@PLT
.LC_ASAN_EX_2176:
leaq -8(%rsp), %rsp
	popq %rdi
	movl -4(%rbp), %eax
.LC883:
	popq %rbp
.LC884:
	retq 
.size func1,.-func1
	.text
.globl main
.type main, @function
main:
.L885:
.LC885:
	pushq %rbp
.LC886:
	movq %rsp, %rbp
.LC889:
	subq $0x20, %rsp
.LC88d:
.ASAN_STACK_ENTER_2189: # None
		leaq -8(%rbp), %rdi
	shrq $3, %rdi
	movb $0xff, 2147450880(%rdi)
	movq %fs:0x28, %rax
.LC896:
	movq %rax, -8(%rbp)
.LC89a:
	xorl %eax, %eax
.LC89c:
	leaq -0x20(%rbp), %rax
.LC8a0:
	movq %rax, %rsi
.LC8a3:
	leaq .LC994(%rip), %rdi
.LC8aa:
	movl $0, %eax
.LC8af:
	callq __isoc99_scanf@PLT
.LC8b4:
.LC_ASAN_ENTER_8b4: # 8b4: movzbl -0x20(%rbp), %eax: ['rdi', 'rax']
		leaq -0x20(%rbp), %rax
	movq %rax, %rdi
	shrq $3, %rdi
	movb 2147450880(%rdi), %dil
	testb %dil, %dil
	je .LC_ASAN_EX_2228
	andl $7, %eax
	movsbl %dil, %edi
	cmpl %edi, %eax
	jl .LC_ASAN_EX_2228
	callq __asan_report_load1@PLT
.LC_ASAN_EX_2228:
	movzbl -0x20(%rbp), %eax
.LC8b8:
	cmpb $0x61, %al
.LC8ba:
	jne .L8ca
.LC8bc:
	leaq .LC997(%rip), %rdi
.LC8c3:
	callq puts@PLT
.LC8c8:
	jmp .L8d6
.L8ca:
.LC8ca:
	leaq .LC99a(%rip), %rdi
.LC8d1:
	callq puts@PLT
.L8d6:
.LC8d6:
	movl $2, %edi
.LC8db:
	callq .L870
.LC8e0:
.LC_ASAN_ENTER_8e0: # 8e0: movl .LC201050(%rip), %eax: ['rdi', 'rsi', 'rax']
		leaq .LC201050(%rip), %rsi
	movq %rsi, %rdi
	shrq $3, %rdi
	movb 2147450880(%rdi), %dil
	testb %dil, %dil
	je .LC_ASAN_EX_2272
	andl $7, %esi
	addl $3, %esi
	movsbl %dil, %edi
	cmpl %edi, %esi
	jl .LC_ASAN_EX_2272
	callq __asan_report_load4@PLT
.LC_ASAN_EX_2272:
	movl .LC201050(%rip), %eax
.LC8e6:
	movl %eax, %esi
.LC8e8:
	leaq .LC99f(%rip), %rdi
.LC8ef:
	movl $0, %eax
.LC8f4:
	callq printf@PLT
.LC8f9:
	nop 
.LC8fa:
.ASAN_STACK_EXIT_2298: # None
		leaq -8(%rbp), %rax
	shrq $3, %rax
	movb $0x0, 2147450880(%rax)
	movq -8(%rbp), %rax
.LC8fe:
	xorq %fs:0x28, %rax
.LC907:
	je .L90e
.LC909:
	callq __stack_chk_fail@PLT
.L90e:
.LC90e:
	leave 
.LC90f:
	retq 
.size main,.-main
	.text
.local asan.module_ctor
.type asan.module_ctor, @function
asan.module_ctor:
    .align    16, 0x90
# BB#0:
    pushq    %rax
.Ltmp11:
    callq    __asan_init_v4@PLT
    popq    %rax
    retq
.size asan.module_ctor,.-asan.module_ctor
	.text
.local asan.module_dtor
.type asan.module_dtor, @function
asan.module_dtor:
    .align    16, 0x90
# BB#0:
    pushq    %rax
.Ltmp12:
    popq    %rax
    retq
.size asan.module_dtor,.-asan.module_dtor
