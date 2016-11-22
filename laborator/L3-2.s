	.file	"L3-2.c"
	.text
	.globl	fact_while
	.align	16, 0x90
	.type	fact_while,@function
fact_while:                             # @fact_while
	.cfi_startproc
# BB#0:
	pushq	%rbp
.Ltmp2:
	.cfi_def_cfa_offset 16
.Ltmp3:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
.Ltmp4:
	.cfi_def_cfa_register %rbp
	movl	%edi, -4(%rbp)
	movl	$1, -8(%rbp)
.LBB0_1:                                # =>This Inner Loop Header: Depth=1
	cmpl	$1, -4(%rbp)
	jle	.LBB0_3
# BB#2:                                 #   in Loop: Header=BB0_1 Depth=1
	movl	-4(%rbp), %eax
	movl	-8(%rbp), %ecx
	imull	%eax, %ecx
	movl	%ecx, -8(%rbp)
	movl	-4(%rbp), %eax
	subl	$1, %eax
	movl	%eax, -4(%rbp)
	jmp	.LBB0_1
.LBB0_3:
	movl	-8(%rbp), %eax
	popq	%rbp
	ret
.Ltmp5:
	.size	fact_while, .Ltmp5-fact_while
	.cfi_endproc


	.ident	"Ubuntu clang version 3.4-1ubuntu3 (tags/RELEASE_34/final) (based on LLVM 3.4)"
	.section	".note.GNU-stack","",@progbits
