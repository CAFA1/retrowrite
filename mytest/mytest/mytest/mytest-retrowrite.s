.section .rodata
.align 4
.type	_IO_stdin_used_400790,@object
.globl _IO_stdin_used_400790
_IO_stdin_used_400790: # 400790 -- 400794
.LC400790:
	.byte 0x1
.LC400791:
	.byte 0x0
.LC400792:
	.byte 0x2
.LC400793:
	.byte 0x0
.LC400794:
	.byte 0x25
.LC400795:
	.byte 0x73
.LC400796:
	.byte 0x0
.LC400797:
	.byte 0x6f
.LC400798:
	.byte 0x6b
.LC400799:
	.byte 0x61
.LC40079a:
	.byte 0x0
.LC40079b:
	.byte 0x66
.LC40079c:
	.byte 0x61
.LC40079d:
	.byte 0x69
.LC40079e:
	.byte 0x6c
.LC40079f:
	.byte 0x61
.LC4007a0:
	.byte 0x0
.LC4007a1:
	.byte 0x6f
.LC4007a2:
	.byte 0x6b
.LC4007a3:
	.byte 0x62
.LC4007a4:
	.byte 0x0
.LC4007a5:
	.byte 0x66
.LC4007a6:
	.byte 0x61
.LC4007a7:
	.byte 0x69
.LC4007a8:
	.byte 0x6c
.LC4007a9:
	.byte 0x62
.LC4007aa:
	.byte 0x0
.LC4007ab:
	.byte 0x61
.LC4007ac:
	.byte 0x3d
.LC4007ad:
	.byte 0x25
.LC4007ae:
	.byte 0x64
.LC4007af:
	.byte 0xa
.LC4007b0:
	.byte 0x0

.section .data
.align 8
.LC601040:
	.byte 0x0
.LC601041:
	.byte 0x0
.LC601042:
	.byte 0x0
.LC601043:
	.byte 0x0
.LC601044:
	.byte 0x0
.LC601045:
	.byte 0x0
.LC601046:
	.byte 0x0
.LC601047:
	.byte 0x0
.LC601048:
	.byte 0x0
.LC601049:
	.byte 0x0
.LC60104a:
	.byte 0x0
.LC60104b:
	.byte 0x0
.LC60104c:
	.byte 0x0
.LC60104d:
	.byte 0x0
.LC60104e:
	.byte 0x0
.LC60104f:
	.byte 0x0
.type	c_601050,@object
.globl c_601050
c_601050: # 601050 -- 601054
.LC601050:
	.byte 0x1
.LC601051:
	.byte 0x0
.LC601052:
	.byte 0x0
.LC601053:
	.byte 0x0
.section .bss
.align 1
.type	completed.7594_601054,@object
.globl completed.7594_601054
completed.7594_601054: # 601054 -- 601055
.LC601054:
	.byte 0x0
.LC601055:
	.byte 0x0
.LC601056:
	.byte 0x0
.LC601057:
	.byte 0x0
.section .text
.align 16
	.text
.globl func1
.type func1, @function
func1:
.L400646:
.LC400646:
	pushq %rbp
.LC400647:
	movq %rsp, %rbp
.LC40064a:
	movl %edi, -4(%rbp)
.LC40064d:
	leaq .LC601050(%rip), %rax
.LC400654:
	movl -4(%rbp), %edx
.LC400657:
	movl %edx, 0(%rax)
.LC400659:
	movl -4(%rbp), %eax
.LC40065c:
	popq %rbp
.LC40065d:
	retq 
.size func1,.-func1
	.text
.globl main
.type main, @function
main:
.L40065e:
.LC40065e:
	pushq %rbp
.LC40065f:
	movq %rsp, %rbp
.LC400662:
	subq $0x20, %rsp
.LC400666:
	movq %fs:0x28, %rax
.LC40066f:
	movq %rax, -8(%rbp)
.LC400673:
	xorl %eax, %eax
.LC400675:
	leaq -0x20(%rbp), %rax
.LC400679:
	movq %rax, %rsi
.LC40067c:
	leaq .LC400794(%rip), %rdi
.LC400683:
	movl $0, %eax
.LC400688:
	callq __isoc99_scanf@PLT
.LC40068d:
	movzbl -0x20(%rbp), %eax
.LC400691:
	cmpb $0x31, %al
.LC400693:
	jne .L4006a3
.LC400695:
	leaq .LC400797(%rip), %rdi
.LC40069c:
	callq puts@PLT
.LC4006a1:
	jmp .L4006af
.L4006a3:
.LC4006a3:
	leaq .LC40079b(%rip), %rdi
.LC4006aa:
	callq puts@PLT
.L4006af:
.LC4006af:
	movzbl -0x1f(%rbp), %eax
.LC4006b3:
	cmpb $0x32, %al
.LC4006b5:
	jne .L4006c5
.LC4006b7:
	leaq .LC4007a1(%rip), %rdi
.LC4006be:
	callq puts@PLT
.LC4006c3:
	jmp .L4006d1
.L4006c5:
.LC4006c5:
	leaq .LC4007a5(%rip), %rdi
.LC4006cc:
	callq puts@PLT
.L4006d1:
.LC4006d1:
	movl $2, %edi
.LC4006d6:
	callq .L400646
.LC4006db:
	leaq .LC601050(%rip), %rax
.LC4006e2:
	movl 0(%rax), %eax
.LC4006e4:
	movl %eax, %esi
.LC4006e6:
	leaq .LC4007ab(%rip), %rdi
.LC4006ed:
	movl $0, %eax
.LC4006f2:
	callq printf@PLT
.LC4006f7:
	nop 
.LC4006f8:
	movq -8(%rbp), %rax
.LC4006fc:
	xorq %fs:0x28, %rax
.LC400705:
	je .L40070c
.LC400707:
	callq __stack_chk_fail@PLT
.L40070c:
.LC40070c:
	leave 
.LC40070d:
	retq 
.size main,.-main
