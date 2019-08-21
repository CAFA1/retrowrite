	.text
	.file	"tinylib.bc"
	.globl	do_heap
	.align	16, 0x90
	.type	do_heap,@function
do_heap:                                # @do_heap
	.cfi_startproc
# BB#0:
	pushq	%rbp
.Ltmp0:
	.cfi_def_cfa_offset 16
.Ltmp1:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
.Ltmp2:
	.cfi_def_cfa_register %rbp
	subq	$80, %rsp
	movl	$32, %eax
	movl	%eax, %edi
	callq	malloc@PLT
	leaq	.str(%rip), %rdi
	movq	%rax, -16(%rbp)
	movq	-16(%rbp), %rsi
	movb	$0, %al
	callq	__isoc99_scanf@PLT
	movq	-16(%rbp), %rdi
	movq	KEY@GOTPCREL(%rip), %rsi
	movl	%eax, -24(%rbp)         # 4-byte Spill
	callq	strcmp@PLT
	cmpl	$0, %eax
	je	.LBB0_14
# BB#1:
	movl	$0, -20(%rbp)
.LBB0_2:                                # =>This Inner Loop Header: Depth=1
	movq	KEY@GOTPCREL(%rip), %rax
	movslq	-20(%rbp), %rcx
	addq	%rcx, %rax
	movq	%rax, %rcx
	shrq	$3, %rcx
	movb	2147450880(%rcx), %dl
	cmpb	$0, %dl
	movq	%rax, -32(%rbp)         # 8-byte Spill
	movb	%dl, -33(%rbp)          # 1-byte Spill
	je	.LBB0_5
# BB#3:                                 #   in Loop: Header=BB0_2 Depth=1
	movq	-32(%rbp), %rax         # 8-byte Reload
	andq	$7, %rax
	movb	%al, %cl
	movb	-33(%rbp), %dl          # 1-byte Reload
	cmpb	%dl, %cl
	jl	.LBB0_5
# BB#4:
	movq	-32(%rbp), %rdi         # 8-byte Reload
	callq	__asan_report_load1@PLT
	#APP
	#NO_APP
.LBB0_5:                                #   in Loop: Header=BB0_2 Depth=1
	movq	-32(%rbp), %rax         # 8-byte Reload
	cmpb	$0, (%rax)
	je	.LBB0_13
# BB#6:                                 #   in Loop: Header=BB0_2 Depth=1
	movq	KEY@GOTPCREL(%rip), %rax
	movslq	-20(%rbp), %rcx
	addq	%rcx, %rax
	movq	%rax, %rcx
	shrq	$3, %rcx
	movb	2147450880(%rcx), %dl
	cmpb	$0, %dl
	movq	%rax, -48(%rbp)         # 8-byte Spill
	movb	%dl, -49(%rbp)          # 1-byte Spill
	je	.LBB0_9
# BB#7:                                 #   in Loop: Header=BB0_2 Depth=1
	movq	-48(%rbp), %rax         # 8-byte Reload
	andq	$7, %rax
	movb	%al, %cl
	movb	-49(%rbp), %dl          # 1-byte Reload
	cmpb	%dl, %cl
	jl	.LBB0_9
# BB#8:
	movq	-48(%rbp), %rdi         # 8-byte Reload
	callq	__asan_report_load1@PLT
	#APP
	#NO_APP
.LBB0_9:                                #   in Loop: Header=BB0_2 Depth=1
	movq	-48(%rbp), %rax         # 8-byte Reload
	movb	(%rax), %cl
	movslq	-20(%rbp), %rdx
	addq	-16(%rbp), %rdx
	movq	%rdx, %rsi
	shrq	$3, %rsi
	movb	2147450880(%rsi), %dil
	cmpb	$0, %dil
	movb	%cl, -50(%rbp)          # 1-byte Spill
	movq	%rdx, -64(%rbp)         # 8-byte Spill
	movb	%dil, -65(%rbp)         # 1-byte Spill
	je	.LBB0_12
# BB#10:                                #   in Loop: Header=BB0_2 Depth=1
	movq	-64(%rbp), %rax         # 8-byte Reload
	andq	$7, %rax
	movb	%al, %cl
	movb	-65(%rbp), %dl          # 1-byte Reload
	cmpb	%dl, %cl
	jl	.LBB0_12
# BB#11:
	movq	-64(%rbp), %rdi         # 8-byte Reload
	callq	__asan_report_store1@PLT
	#APP
	#NO_APP
.LBB0_12:                               #   in Loop: Header=BB0_2 Depth=1
	movq	-64(%rbp), %rax         # 8-byte Reload
	movb	-50(%rbp), %cl          # 1-byte Reload
	movb	%cl, (%rax)
	movl	-20(%rbp), %edx
	addl	$1, %edx
	movl	%edx, -20(%rbp)
	jmp	.LBB0_2
.LBB0_13:
	movl	$0, -4(%rbp)
	jmp	.LBB0_15
.LBB0_14:
	movl	$1, -4(%rbp)
.LBB0_15:
	movl	-4(%rbp), %eax
	addq	$80, %rsp
	popq	%rbp
	retq
.Lfunc_end0:
	.size	do_heap, .Lfunc_end0-do_heap
	.cfi_endproc

	.globl	do_stack
	.align	16, 0x90
	.type	do_stack,@function
do_stack:                               # @do_stack
	.cfi_startproc
# BB#0:
	pushq	%rbp
.Ltmp3:
	.cfi_def_cfa_offset 16
.Ltmp4:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
.Ltmp5:
	.cfi_def_cfa_register %rbp
	pushq	%rbx
	andq	$-32, %rsp
	subq	$160, %rsp
	movq	%rsp, %rbx
.Ltmp6:
	.cfi_offset %rbx, -24
	xorl	%eax, %eax
	movl	%eax, %ecx
	movq	__asan_option_detect_stack_use_after_return@GOTPCREL(%rip), %rdx
	cmpl	$0, (%rdx)
	movq	%rcx, 120(%rbx)         # 8-byte Spill
	je	.LBB1_2
# BB#1:
	movl	$96, %eax
	movl	%eax, %edi
	callq	__asan_stack_malloc_1@PLT
	movq	%rax, 120(%rbx)         # 8-byte Spill
.LBB1_2:
	movq	120(%rbx), %rax         # 8-byte Reload
	cmpq	$0, %rax
	movq	%rax, %rcx
	movq	%rax, 112(%rbx)         # 8-byte Spill
	movq	%rcx, 104(%rbx)         # 8-byte Spill
	jne	.LBB1_4
# BB#3:
	movq	%rsp, %rax
	addq	$-96, %rax
	andq	$-32, %rax
	movq	%rax, %rsp
	movq	%rax, 104(%rbx)         # 8-byte Spill
.LBB1_4:
	movq	104(%rbx), %rax         # 8-byte Reload
	leaq	.str(%rip), %rdi
	movl	$4059165169, %ecx       # imm = 0xF1F1F1F1
	movl	%ecx, %edx
	movq	do_stack@GOTPCREL(%rip), %rsi
	leaq	.L__asan_gen_(%rip), %r8
	movq	%rax, %r9
	addq	$32, %r9
	movq	$1102416563, (%rax)     # imm = 0x41B58AB3
	movq	%r8, 8(%rax)
	movq	%rsi, 16(%rax)
	movq	%rax, %rsi
	shrq	$3, %rsi
	movq	%rsi, %r8
	addq	$2147450880, %r8        # imm = 0x7FFF8000
	movq	%rdx, 2147450880(%rsi)
	movl	$-202116109, 2147450888(%rsi) # imm = 0xFFFFFFFFF3F3F3F3
	movq	%r9, %rsi
	movq	%rax, 96(%rbx)          # 8-byte Spill
	movb	$0, %al
	movq	%r8, 88(%rbx)           # 8-byte Spill
	movq	%r9, 80(%rbx)           # 8-byte Spill
	callq	__isoc99_scanf@PLT
	movq	KEY@GOTPCREL(%rip), %rsi
	movq	80(%rbx), %rdi          # 8-byte Reload
	movl	%eax, 76(%rbx)          # 4-byte Spill
	callq	strcmp@PLT
	cmpl	$0, %eax
	je	.LBB1_18
# BB#5:
	movl	$0, 128(%rbx)
.LBB1_6:                                # =>This Inner Loop Header: Depth=1
	movq	KEY@GOTPCREL(%rip), %rax
	movslq	128(%rbx), %rcx
	addq	%rcx, %rax
	movq	%rax, %rcx
	shrq	$3, %rcx
	movb	2147450880(%rcx), %dl
	cmpb	$0, %dl
	movq	%rax, 64(%rbx)          # 8-byte Spill
	movb	%dl, 63(%rbx)           # 1-byte Spill
	je	.LBB1_9
# BB#7:                                 #   in Loop: Header=BB1_6 Depth=1
	movq	64(%rbx), %rax          # 8-byte Reload
	andq	$7, %rax
	movb	%al, %cl
	movb	63(%rbx), %dl           # 1-byte Reload
	cmpb	%dl, %cl
	jl	.LBB1_9
# BB#8:
	movq	64(%rbx), %rdi          # 8-byte Reload
	callq	__asan_report_load1@PLT
	#APP
	#NO_APP
.LBB1_9:                                #   in Loop: Header=BB1_6 Depth=1
	movq	64(%rbx), %rax          # 8-byte Reload
	cmpb	$0, (%rax)
	je	.LBB1_17
# BB#10:                                #   in Loop: Header=BB1_6 Depth=1
	movq	KEY@GOTPCREL(%rip), %rax
	movslq	128(%rbx), %rcx
	addq	%rcx, %rax
	movq	%rax, %rcx
	shrq	$3, %rcx
	movb	2147450880(%rcx), %dl
	cmpb	$0, %dl
	movq	%rax, 48(%rbx)          # 8-byte Spill
	movb	%dl, 47(%rbx)           # 1-byte Spill
	je	.LBB1_13
# BB#11:                                #   in Loop: Header=BB1_6 Depth=1
	movq	48(%rbx), %rax          # 8-byte Reload
	andq	$7, %rax
	movb	%al, %cl
	movb	47(%rbx), %dl           # 1-byte Reload
	cmpb	%dl, %cl
	jl	.LBB1_13
# BB#12:
	movq	48(%rbx), %rdi          # 8-byte Reload
	callq	__asan_report_load1@PLT
	#APP
	#NO_APP
.LBB1_13:                               #   in Loop: Header=BB1_6 Depth=1
	movq	48(%rbx), %rax          # 8-byte Reload
	movb	(%rax), %cl
	movslq	128(%rbx), %rdx
	movq	80(%rbx), %rsi          # 8-byte Reload
	addq	%rdx, %rsi
	movq	%rsi, %rdx
	shrq	$3, %rdx
	movb	2147450880(%rdx), %dil
	cmpb	$0, %dil
	movb	%cl, 46(%rbx)           # 1-byte Spill
	movq	%rsi, 32(%rbx)          # 8-byte Spill
	movb	%dil, 31(%rbx)          # 1-byte Spill
	je	.LBB1_16
# BB#14:                                #   in Loop: Header=BB1_6 Depth=1
	movq	32(%rbx), %rax          # 8-byte Reload
	andq	$7, %rax
	movb	%al, %cl
	movb	31(%rbx), %dl           # 1-byte Reload
	cmpb	%dl, %cl
	jl	.LBB1_16
# BB#15:
	movq	32(%rbx), %rdi          # 8-byte Reload
	callq	__asan_report_store1@PLT
	#APP
	#NO_APP
.LBB1_16:                               #   in Loop: Header=BB1_6 Depth=1
	movq	32(%rbx), %rax          # 8-byte Reload
	movb	46(%rbx), %cl           # 1-byte Reload
	movb	%cl, (%rax)
	movl	128(%rbx), %edx
	addl	$1, %edx
	movl	%edx, 128(%rbx)
	jmp	.LBB1_6
.LBB1_17:
	movl	$0, 132(%rbx)
	jmp	.LBB1_19
.LBB1_18:
	movl	$1, 132(%rbx)
.LBB1_19:
	movl	132(%rbx), %eax
	movq	96(%rbx), %rcx          # 8-byte Reload
	movq	$1172321806, (%rcx)     # imm = 0x45E0360E
	movq	112(%rbx), %rdx         # 8-byte Reload
	cmpq	$0, %rdx
	movl	%eax, 24(%rbx)          # 4-byte Spill
	je	.LBB1_21
# BB#20:
	movabsq	$-723401728380766731, %rax # imm = 0xF5F5F5F5F5F5F5F5
	movq	88(%rbx), %rcx          # 8-byte Reload
	movq	%rax, (%rcx)
	movq	%rax, 8(%rcx)
	movq	112(%rbx), %rax         # 8-byte Reload
	movq	120(%rax), %rdx
	movb	$0, (%rdx)
	jmp	.LBB1_22
.LBB1_21:
	movq	88(%rbx), %rax          # 8-byte Reload
	movq	$0, (%rax)
	movl	$0, 8(%rax)
.LBB1_22:
	movl	24(%rbx), %eax          # 4-byte Reload
	leaq	-8(%rbp), %rsp
	popq	%rbx
	popq	%rbp
	retq
.Lfunc_end1:
	.size	do_stack, .Lfunc_end1-do_stack
	.cfi_endproc

	.globl	do_global
	.align	16, 0x90
	.type	do_global,@function
do_global:                              # @do_global
	.cfi_startproc
# BB#0:
	pushq	%rbp
.Ltmp7:
	.cfi_def_cfa_offset 16
.Ltmp8:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
.Ltmp9:
	.cfi_def_cfa_register %rbp
	pushq	%rbx
	andq	$-32, %rsp
	subq	$160, %rsp
	movq	%rsp, %rbx
.Ltmp10:
	.cfi_offset %rbx, -24
	xorl	%eax, %eax
	movl	%eax, %ecx
	movq	__asan_option_detect_stack_use_after_return@GOTPCREL(%rip), %rdx
	cmpl	$0, (%rdx)
	movq	%rcx, 120(%rbx)         # 8-byte Spill
	je	.LBB2_2
# BB#1:
	movl	$352, %eax              # imm = 0x160
	movl	%eax, %edi
	callq	__asan_stack_malloc_3@PLT
	movq	%rax, 120(%rbx)         # 8-byte Spill
.LBB2_2:
	movq	120(%rbx), %rax         # 8-byte Reload
	cmpq	$0, %rax
	movq	%rax, %rcx
	movq	%rax, 112(%rbx)         # 8-byte Spill
	movq	%rcx, 104(%rbx)         # 8-byte Spill
	jne	.LBB2_4
# BB#3:
	movq	%rsp, %rax
	addq	$-352, %rax             # imm = 0xFFFFFFFFFFFFFEA0
	andq	$-32, %rax
	movq	%rax, %rsp
	movq	%rax, 104(%rbx)         # 8-byte Spill
.LBB2_4:
	movq	104(%rbx), %rax         # 8-byte Reload
	leaq	.str(%rip), %rdi
	movabsq	$-868082078149771264, %rcx # imm = 0xF3F3F3F300000000
	movl	$4059165169, %edx       # imm = 0xF1F1F1F1
	movl	%edx, %esi
	movq	do_global@GOTPCREL(%rip), %r8
	leaq	.L__asan_gen_.1(%rip), %r9
	movq	%rax, %r10
	addq	$32, %r10
	movq	$1102416563, (%rax)     # imm = 0x41B58AB3
	movq	%r9, 8(%rax)
	movq	%r8, 16(%rax)
	movq	%rax, %r8
	shrq	$3, %r8
	movq	%r8, %r9
	addq	$2147450880, %r9        # imm = 0x7FFF8000
	movq	%rsi, 2147450880(%r8)
	movq	%rcx, 2147450912(%r8)
	movl	$-202116109, 2147450920(%r8) # imm = 0xFFFFFFFFF3F3F3F3
	movq	%r10, %rsi
	movq	%rax, 96(%rbx)          # 8-byte Spill
	movb	$0, %al
	movq	%r10, 88(%rbx)          # 8-byte Spill
	movq	%r9, 80(%rbx)           # 8-byte Spill
	callq	__isoc99_scanf@PLT
	movq	KEY@GOTPCREL(%rip), %rsi
	movq	88(%rbx), %rdi          # 8-byte Reload
	movl	%eax, 76(%rbx)          # 4-byte Spill
	callq	strcmp@PLT
	cmpl	$0, %eax
	je	.LBB2_18
# BB#5:
	movl	$0, 128(%rbx)
.LBB2_6:                                # =>This Inner Loop Header: Depth=1
	movslq	128(%rbx), %rax
	movq	88(%rbx), %rcx          # 8-byte Reload
	addq	%rax, %rcx
	movq	%rcx, %rax
	shrq	$3, %rax
	movb	2147450880(%rax), %dl
	cmpb	$0, %dl
	movq	%rcx, 64(%rbx)          # 8-byte Spill
	movb	%dl, 63(%rbx)           # 1-byte Spill
	je	.LBB2_9
# BB#7:                                 #   in Loop: Header=BB2_6 Depth=1
	movq	64(%rbx), %rax          # 8-byte Reload
	andq	$7, %rax
	movb	%al, %cl
	movb	63(%rbx), %dl           # 1-byte Reload
	cmpb	%dl, %cl
	jl	.LBB2_9
# BB#8:
	movq	64(%rbx), %rdi          # 8-byte Reload
	callq	__asan_report_load1@PLT
	#APP
	#NO_APP
.LBB2_9:                                #   in Loop: Header=BB2_6 Depth=1
	movq	64(%rbx), %rax          # 8-byte Reload
	cmpb	$0, (%rax)
	je	.LBB2_17
# BB#10:                                #   in Loop: Header=BB2_6 Depth=1
	movslq	128(%rbx), %rax
	movq	88(%rbx), %rcx          # 8-byte Reload
	addq	%rax, %rcx
	movq	%rcx, %rax
	shrq	$3, %rax
	movb	2147450880(%rax), %dl
	cmpb	$0, %dl
	movq	%rcx, 48(%rbx)          # 8-byte Spill
	movb	%dl, 47(%rbx)           # 1-byte Spill
	je	.LBB2_13
# BB#11:                                #   in Loop: Header=BB2_6 Depth=1
	movq	48(%rbx), %rax          # 8-byte Reload
	andq	$7, %rax
	movb	%al, %cl
	movb	47(%rbx), %dl           # 1-byte Reload
	cmpb	%dl, %cl
	jl	.LBB2_13
# BB#12:
	movq	48(%rbx), %rdi          # 8-byte Reload
	callq	__asan_report_load1@PLT
	#APP
	#NO_APP
.LBB2_13:                               #   in Loop: Header=BB2_6 Depth=1
	movq	KEY@GOTPCREL(%rip), %rax
	movq	48(%rbx), %rcx          # 8-byte Reload
	movb	(%rcx), %dl
	movslq	128(%rbx), %rsi
	addq	%rsi, %rax
	movq	%rax, %rsi
	shrq	$3, %rsi
	movb	2147450880(%rsi), %dil
	cmpb	$0, %dil
	movq	%rax, 32(%rbx)          # 8-byte Spill
	movb	%dl, 31(%rbx)           # 1-byte Spill
	movb	%dil, 30(%rbx)          # 1-byte Spill
	je	.LBB2_16
# BB#14:                                #   in Loop: Header=BB2_6 Depth=1
	movq	32(%rbx), %rax          # 8-byte Reload
	andq	$7, %rax
	movb	%al, %cl
	movb	30(%rbx), %dl           # 1-byte Reload
	cmpb	%dl, %cl
	jl	.LBB2_16
# BB#15:
	movq	32(%rbx), %rdi          # 8-byte Reload
	callq	__asan_report_store1@PLT
	#APP
	#NO_APP
.LBB2_16:                               #   in Loop: Header=BB2_6 Depth=1
	movq	32(%rbx), %rax          # 8-byte Reload
	movb	31(%rbx), %cl           # 1-byte Reload
	movb	%cl, (%rax)
	movl	128(%rbx), %edx
	addl	$1, %edx
	movl	%edx, 128(%rbx)
	jmp	.LBB2_6
.LBB2_17:
	movl	$0, 132(%rbx)
	jmp	.LBB2_19
.LBB2_18:
	movl	$1, 132(%rbx)
.LBB2_19:
	movl	132(%rbx), %eax
	movq	96(%rbx), %rcx          # 8-byte Reload
	movq	$1172321806, (%rcx)     # imm = 0x45E0360E
	movq	112(%rbx), %rdx         # 8-byte Reload
	cmpq	$0, %rdx
	movl	%eax, 24(%rbx)          # 4-byte Spill
	je	.LBB2_21
# BB#20:
	movabsq	$-723401728380766731, %rax # imm = 0xF5F5F5F5F5F5F5F5
	movq	80(%rbx), %rcx          # 8-byte Reload
	movq	%rax, (%rcx)
	movq	%rax, 8(%rcx)
	movq	%rax, 16(%rcx)
	movq	%rax, 24(%rcx)
	movq	%rax, 32(%rcx)
	movq	%rax, 40(%rcx)
	movq	%rax, 48(%rcx)
	movq	%rax, 56(%rcx)
	movq	112(%rbx), %rax         # 8-byte Reload
	movq	504(%rax), %rdx
	movb	$0, (%rdx)
	jmp	.LBB2_22
.LBB2_21:
	movq	80(%rbx), %rax          # 8-byte Reload
	movq	$0, (%rax)
	movq	$0, 32(%rax)
	movl	$0, 40(%rax)
.LBB2_22:
	movl	24(%rbx), %eax          # 4-byte Reload
	leaq	-8(%rbp), %rsp
	popq	%rbx
	popq	%rbp
	retq
.Lfunc_end2:
	.size	do_global, .Lfunc_end2-do_global
	.cfi_endproc

	.align	16, 0x90
	.type	asan.module_ctor,@function
asan.module_ctor:                       # @asan.module_ctor
	.cfi_startproc
# BB#0:
	pushq	%rax
.Ltmp11:
	.cfi_def_cfa_offset 16
	callq	__asan_init@PLT
	callq	__asan_version_mismatch_check_v6@PLT
	leaq	__unnamed_1(%rip), %rdi
	movl	$3, %eax
	movl	%eax, %esi
	callq	__asan_register_globals@PLT
	popq	%rax
	retq
.Lfunc_end3:
	.size	asan.module_ctor, .Lfunc_end3-asan.module_ctor
	.cfi_endproc

	.align	16, 0x90
	.type	asan.module_dtor,@function
asan.module_dtor:                       # @asan.module_dtor
	.cfi_startproc
# BB#0:
	pushq	%rax
.Ltmp12:
	.cfi_def_cfa_offset 16
	leaq	__unnamed_1(%rip), %rdi
	movl	$3, %eax
	movl	%eax, %esi
	callq	__asan_unregister_globals@PLT
	popq	%rax
	retq
.Lfunc_end4:
	.size	asan.module_dtor, .Lfunc_end4-asan.module_dtor
	.cfi_endproc

	.type	KEY,@object             # @KEY
	.data
	.globl	KEY
	.align	32
KEY:
	.asciz	"SUPERSECRETKEYSUPERSECRETKEYSUPERSECRETKEY\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000"
	.asciz	"ULTRA\000\000"
	.zero	56
	.size	KEY, 128

	.type	BAR,@object             # @BAR
	.globl	BAR
	.align	32
BAR:
	.asciz	"SUPERSECRETKEY\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000"
	.asciz	"ULTRA\000\000"
	.zero	56
	.size	BAR, 128

	.type	.str,@object            # @.str
	.section	.rodata,"a",@progbits
	.align	32
.str:
	.asciz	"%s"
	.zero	61
	.size	.str, 64

	.section	.init_array.1,"aw",@init_array
	.align	8
	.quad	asan.module_ctor
	.type	.L__asan_gen_,@object   # @__asan_gen_
	.section	.rodata.str1.1,"aMS",@progbits,1
.L__asan_gen_:
	.asciz	"1 32 32 6 secret"
	.size	.L__asan_gen_, 17

	.type	.L__asan_gen_.1,@object # @__asan_gen_.1
.L__asan_gen_.1:
	.asciz	"1 32 256 6 secret"
	.size	.L__asan_gen_.1, 18

	.type	.L__asan_gen_.2,@object # @__asan_gen_.2
	.section	.rodata,"a",@progbits
.L__asan_gen_.2:
	.asciz	"tinylib.bc"
	.size	.L__asan_gen_.2, 11

	.type	.L__asan_gen_.3,@object # @__asan_gen_.3
	.section	.rodata.str1.1,"aMS",@progbits,1
.L__asan_gen_.3:
	.asciz	"KEY"
	.size	.L__asan_gen_.3, 4

	.type	.L__asan_gen_.4,@object # @__asan_gen_.4
.L__asan_gen_.4:
	.asciz	"./tinylib.h"
	.size	.L__asan_gen_.4, 12

	.type	.L__asan_gen_.5,@object # @__asan_gen_.5
	.section	.data.rel.ro,"aw",@progbits
	.align	8
.L__asan_gen_.5:
	.quad	.L__asan_gen_.4
	.long	14                      # 0xe
	.long	12                      # 0xc
	.size	.L__asan_gen_.5, 16

	.type	.L__asan_gen_.6,@object # @__asan_gen_.6
	.section	.rodata.str1.1,"aMS",@progbits,1
.L__asan_gen_.6:
	.asciz	"BAR"
	.size	.L__asan_gen_.6, 4

	.type	.L__asan_gen_.7,@object # @__asan_gen_.7
.L__asan_gen_.7:
	.asciz	"./tinylib.h"
	.size	.L__asan_gen_.7, 12

	.type	.L__asan_gen_.8,@object # @__asan_gen_.8
	.section	.data.rel.ro,"aw",@progbits
	.align	8
.L__asan_gen_.8:
	.quad	.L__asan_gen_.7
	.long	15                      # 0xf
	.long	12                      # 0xc
	.size	.L__asan_gen_.8, 16

	.type	.L__asan_gen_.9,@object # @__asan_gen_.9
	.section	.rodata.str1.1,"aMS",@progbits,1
.L__asan_gen_.9:
	.asciz	"<string literal>"
	.size	.L__asan_gen_.9, 17

	.type	.L__asan_gen_.10,@object # @__asan_gen_.10
.L__asan_gen_.10:
	.asciz	"tinylib.c"
	.size	.L__asan_gen_.10, 10

	.type	.L__asan_gen_.11,@object # @__asan_gen_.11
	.section	.data.rel.ro,"aw",@progbits
	.align	8
.L__asan_gen_.11:
	.quad	.L__asan_gen_.10
	.long	9                       # 0x9
	.long	11                      # 0xb
	.size	.L__asan_gen_.11, 16

	.type	__unnamed_1,@object     # @0
	.data
	.align	16
__unnamed_1:
	.quad	KEY
	.quad	72                      # 0x48
	.quad	128                     # 0x80
	.quad	.L__asan_gen_.3
	.quad	.L__asan_gen_.2
	.quad	0                       # 0x0
	.quad	.L__asan_gen_.5
	.quad	BAR
	.quad	72                      # 0x48
	.quad	128                     # 0x80
	.quad	.L__asan_gen_.6
	.quad	.L__asan_gen_.2
	.quad	0                       # 0x0
	.quad	.L__asan_gen_.8
	.quad	.str
	.quad	3                       # 0x3
	.quad	64                      # 0x40
	.quad	.L__asan_gen_.9
	.quad	.L__asan_gen_.2
	.quad	0                       # 0x0
	.quad	.L__asan_gen_.11
	.size	__unnamed_1, 168

	.section	.fini_array.1,"aw",@fini_array
	.align	8
	.quad	asan.module_dtor

	.ident	"clang version 3.8.0-2ubuntu4 (tags/RELEASE_380/final)"
	.section	".note.GNU-stack","",@progbits
