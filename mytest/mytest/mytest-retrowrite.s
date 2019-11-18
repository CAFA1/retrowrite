.section .rodata
.align 4
.type	_IO_stdin_used_400760,@object
.globl _IO_stdin_used_400760
_IO_stdin_used_400760: # 400760 -- 400764
.LC400760:
	.byte 0x1
.LC400761:
	.byte 0x0
.LC400762:
	.byte 0x2
.LC400763:
	.byte 0x0
.LC400764:
	.byte 0x25
.LC400765:
	.byte 0x73
.LC400766:
	.byte 0x0
.LC400767:
	.byte 0x6f
.LC400768:
	.byte 0x6b
.LC400769:
	.byte 0x0
.LC40076a:
	.byte 0x66
.LC40076b:
	.byte 0x61
.LC40076c:
	.byte 0x69
.LC40076d:
	.byte 0x6c
.LC40076e:
	.byte 0x0
.LC40076f:
	.byte 0x61
.LC400770:
	.byte 0x3d
.LC400771:
	.byte 0x25
.LC400772:
	.byte 0x64
.LC400773:
	.byte 0xa
.LC400774:
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
	movl -4(%rbp), %eax
.LC400650:
	movl %eax, .LC601050(%rip)
.LC400656:
	movl -4(%rbp), %eax
.LC400659:
	popq %rbp
.LC40065a:
	retq 
.size func1,.-func1
	.text
.globl main
.type main, @function
main:
.L40065b:
.LC40065b:
	pushq %rbp
.LC40065c:
	movq %rsp, %rbp
.LC40065f:
	subq $0x20, %rsp
.LC400663:
	movq %fs:0x28, %rax
.LC40066c:
	movq %rax, -8(%rbp)
.LC400670:
	xorl %eax, %eax
.LC400672:
	leaq -0x20(%rbp), %rax
.LC400676:
	movq %rax, %rsi
.LC400679:
	movl $0x400764, %edi
.LC40067e:
	movl $0, %eax
.LC400683:
	callq __isoc99_scanf@PLT
.LC400688:
	movzbl -0x20(%rbp), %eax
.LC40068c:
	cmpb $0x61, %al
.LC40068e:
	jne .L40069c
.LC400690:
	movl $0x400767, %edi
.LC400695:
	callq puts@PLT
.LC40069a:
	jmp .L4006a6
.L40069c:
.LC40069c:
	movl $0x40076a, %edi
.LC4006a1:
	callq puts@PLT
.L4006a6:
.LC4006a6:
	movl $2, %edi
.LC4006ab:
	callq .L400646
.LC4006b0:
	movl .LC601050(%rip), %eax
.LC4006b6:
	movl %eax, %esi
.LC4006b8:
	movl $0x40076f, %edi
.LC4006bd:
	movl $0, %eax
.LC4006c2:
	callq printf@PLT
.LC4006c7:
	nop 
.LC4006c8:
	movq -8(%rbp), %rax
.LC4006cc:
	xorq %fs:0x28, %rax
.LC4006d5:
	je .L4006dc
.LC4006d7:
	callq __stack_chk_fail@PLT
.L4006dc:
.LC4006dc:
	leave 
.LC4006dd:
	retq 
.size main,.-main
